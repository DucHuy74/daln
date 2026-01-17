package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.dto.request.WorkspaceAddMemberRequest;
import com.xxxx.backend_mvc.dto.request.WorkspaceCreateRequest;
import com.xxxx.backend_mvc.dto.request.WorkspaceUpdateRequest;
import com.xxxx.backend_mvc.dto.response.WorkspaceMemberResponse;
import com.xxxx.backend_mvc.dto.response.WorkspaceResponse;
import com.xxxx.backend_mvc.entity.Backlog;
import com.xxxx.backend_mvc.entity.Profile;
import com.xxxx.backend_mvc.entity.workspace.*;
import com.xxxx.backend_mvc.enums.InvitationStatus;
import com.xxxx.backend_mvc.enums.NotificationType;
import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.mapper.WorkspaceMapper;
import com.xxxx.backend_mvc.repository.*;
import org.springframework.transaction.annotation.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class WorkspaceService {

    static final int INVITE_EXPIRE_DAYS = 3;

    WorkspaceRepository workspaceRepository;
    WorkspaceRoleRepository workspaceRoleRepository;
    WorkspaceMemberRepository workspaceMemberRepository;
    InvitationRepository invitationRepository;
    ProfileRepository profileRepository;
    WorkspaceMapper workspaceMapper;
    BackgroundJobService backgroundJobService;
    NotificationService notificationService;

    private String getCurrentUserId() {
        var authentication = SecurityContextHolder.getContext().getAuthentication();

        if (!(authentication instanceof JwtAuthenticationToken jwtAuth)) {
            throw new AppException(ErrorCode.UNAUTHORIZED);
        }
        return jwtAuth.getToken().getSubject();
    }

    private WorkspaceMember requireAdmin(String workspaceId, String userId) {
        WorkspaceMember member =
                workspaceMemberRepository
                        .findByWorkspace_IdAndProfile_UserId(workspaceId, userId)
                        .orElseThrow(() -> new AppException(ErrorCode.NO_PERMISSION));

        if (member.getWorkspaceRole().getRoleName() != WorkspaceRoleType.ADMIN) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }
        return member;
    }

    @Transactional
    public WorkspaceResponse createWorkspace(WorkspaceCreateRequest request) {

        String userId = getCurrentUserId();

        Profile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        Workspace workspace = Workspace.builder()
                .name(request.getName())
                .type(request.getType())
                .access(request.getAccess())
                .build();

        Backlog backlog = Backlog.builder()
                .name("Backlog")
                .workspace(workspace)
                .build();

        workspace.setBacklog(backlog);

        workspace = workspaceRepository.saveAndFlush(workspace);

        WorkspaceRole adminRole = workspaceRoleRepository.save(
                WorkspaceRole.builder()
                        .workspace(workspace)
                        .roleName(WorkspaceRoleType.ADMIN)
                        .build()
        );

        workspaceMemberRepository.save(
                WorkspaceMember.builder()
                        .workspace(workspace)
                        .profile(profile)
                        .workspaceRole(adminRole)
                        .build()
        );

        return workspaceMapper.toWorkspaceResponse(workspace);
    }

    @Transactional
    public WorkspaceResponse updateWorkspace(
            String workspaceId,
            WorkspaceUpdateRequest request) {

        String userId = getCurrentUserId();

        Workspace workspace = workspaceRepository.findById(workspaceId)
                .orElseThrow(() -> new AppException(ErrorCode.WORKSPACE_NOT_FOUND));

        requireAdmin(workspaceId, userId);

        workspaceMapper.updateWorkspace(workspace, request);

        return workspaceMapper.toWorkspaceResponse(workspace);
    }

    @Transactional
    public void inviteMemberToWorkspace(
            String workspaceId,
            WorkspaceAddMemberRequest request) {

        String userId = getCurrentUserId();

        WorkspaceMember admin = requireAdmin(workspaceId, userId);

        Profile invitee = profileRepository
                .findByEmail(request.getEmail())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        if (invitee.getUserId().equals(userId)) {
            throw new AppException(ErrorCode.INVALID_INVITE);
        }

        if (workspaceMemberRepository
                .findByWorkspace_IdAndProfile_UserId(workspaceId, invitee.getUserId())
                .isPresent()) {
            throw new AppException(ErrorCode.MEMBER_EXISTED);
        }

        if (invitationRepository.existsByWorkspaceIdAndInviteeUserIdAndStatus(
                workspaceId,
                invitee.getUserId(),
                InvitationStatus.PENDING)) {
            throw new AppException(ErrorCode.INVITATION_ALREADY_SENT);
        }

        WorkspaceInvitation invitation = invitationRepository.save(
                WorkspaceInvitation.builder()
                        .workspaceId(workspaceId)
                        .inviterId(userId)
                        .inviteeUserId(invitee.getUserId())
                        .email(invitee.getEmail())
                        .status(InvitationStatus.PENDING)
                        .expiredAt(
                                Instant.now().plus(INVITE_EXPIRE_DAYS, ChronoUnit.DAYS)
                        )
                        .build()
        );

        notificationService.notifyUser(
                invitee.getUserId(),
                "Workspace Invitation",
                "You were invited to join workspace " + admin.getWorkspace().getName(),
                NotificationType.WORKSPACE_INVITE,
                invitation.getId()
        );

        Profile inviter = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        TransactionSynchronizationManager.registerSynchronization(
                new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        backgroundJobService.sendInviteEmailAsync(
                                request.getEmail(),
                                admin.getWorkspace().getName(),
                                inviter.getFirstName() + " " + inviter.getLastName()
                        );
                    }
                }
        );
    }

    public List<WorkspaceResponse> getAllWorkspaces() {

        String userId = getCurrentUserId();

        return workspaceMemberRepository
                .findAllByProfile_UserId(userId)
                .stream()
                .map(member -> {
                    Workspace workspace = member.getWorkspace();
                    WorkspaceResponse res =
                            workspaceMapper.toWorkspaceResponse(workspace);

                    res.setRoles(
                            List.of(member.getWorkspaceRole().getRoleName().name())
                    );

                    res.setOwnerId(
                            workspace.getMembers().stream()
                                    .filter(m -> m.getWorkspaceRole().getRoleName()
                                            == WorkspaceRoleType.ADMIN)
                                    .map(m -> m.getProfile().getUserId())
                                    .findFirst()
                                    .orElse(null)
                    );
                    return res;
                })
                .toList();
    }

    @Transactional
    public void deleteWorkspace(String workspaceId) {

        String userId = getCurrentUserId();

        WorkspaceMember admin = requireAdmin(workspaceId, userId);

        workspaceRepository.delete(admin.getWorkspace());
    }

    public List<WorkspaceMemberResponse> getMembers(String workspaceId) {

        String userId = getCurrentUserId();

        workspaceMemberRepository
                .findByWorkspace_IdAndProfile_UserId(workspaceId, userId)
                .orElseThrow(() -> new AppException(ErrorCode.NO_PERMISSION));

        return workspaceMemberRepository
                .findAllByWorkspace_Id(workspaceId)
                .stream()
                .map(m -> WorkspaceMemberResponse.builder()
                        .userId(m.getProfile().getUserId())
                        .email(m.getProfile().getEmail())
                        .role(m.getWorkspaceRole().getRoleName())
                        .build())
                .toList();
    }
}
