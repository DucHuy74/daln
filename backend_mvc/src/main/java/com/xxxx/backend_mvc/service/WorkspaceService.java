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

    WorkspaceRepository workspaceRepository;
    WorkspaceRoleRepository workspaceRoleRepository;
    WorkspaceMemberRepository workspaceMemberRepository;
    InvitationRepository invitationRepository;
    ProfileRepository profileRepository;
    WorkspaceMapper workspaceMapper;
    BackgroundJobService backgroundJobService;

    private String getCurrentUserId() {
        var authentication = SecurityContextHolder.getContext().getAuthentication();

        if (!(authentication instanceof JwtAuthenticationToken jwtAuth)) {
            throw new AppException(ErrorCode.UNAUTHORIZED);
        }

        return jwtAuth.getToken().getSubject(); // UUID từ Keycloak (sub)
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

        // gán 2 chiều
        workspace.setBacklog(backlog);

        //save & flush để có ID + timestamp
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

        WorkspaceMember member =
                workspaceMemberRepository
                        .findByWorkspace_IdAndProfile_UserId(workspaceId, userId)
                        .orElseThrow(() -> new AppException(ErrorCode.NO_PERMISSION));

        if (member.getWorkspaceRole().getRoleName() != WorkspaceRoleType.ADMIN) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        workspaceMapper.updateWorkspace(workspace, request);
        return workspaceMapper.toWorkspaceResponse(workspaceRepository.save(workspace));
    }

    @Transactional
    public void inviteMemberToWorkspace(
            String workspaceId,
            WorkspaceAddMemberRequest request) {

        String userId = getCurrentUserId();

        WorkspaceMember admin =
                workspaceMemberRepository
                        .findByWorkspace_IdAndProfile_UserId(workspaceId, userId)
                        .orElseThrow(() -> new AppException(ErrorCode.NO_PERMISSION));

        if (admin.getWorkspaceRole().getRoleName() != WorkspaceRoleType.ADMIN) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        if (invitationRepository.existsByWorkspaceIdAndEmailAndStatus(
                workspaceId,
                request.getEmail(),
                InvitationStatus.PENDING)) {
            throw new AppException(ErrorCode.INVITATION_ALREADY_SENT);
        }

        WorkspaceInvitation invitation = invitationRepository.save(
                WorkspaceInvitation.builder()
                        .workspaceId(workspaceId)
                        .email(request.getEmail())
                        .inviterId(userId)
                        .status(InvitationStatus.PENDING)
                        .expiredAt(Instant.now().plus(3, ChronoUnit.DAYS))
                        .build()
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
                                inviter.getFirstName() + " " + inviter.getLastName(),
                                invitation.getId()
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
                    WorkspaceResponse res = workspaceMapper.toWorkspaceResponse(workspace);

                    res.setRoles(List.of(member.getWorkspaceRole().getRoleName().name()));

                    res.setOwnerId(
                            workspace.getMembers().stream()
                                    .filter(m -> m.getWorkspaceRole().getRoleName() == WorkspaceRoleType.ADMIN)
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

        WorkspaceMember admin =
                workspaceMemberRepository
                        .findByWorkspace_IdAndProfile_UserId(workspaceId, userId)
                        .orElseThrow(() -> new AppException(ErrorCode.NO_PERMISSION));

        if (admin.getWorkspaceRole().getRoleName() != WorkspaceRoleType.ADMIN) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

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
