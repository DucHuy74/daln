package com.xxxx.backend_mvc.service;


import com.xxxx.backend_mvc.dto.request.WorkspaceAddMemberRequest;
import com.xxxx.backend_mvc.dto.request.WorkspaceCreateRequest;
import com.xxxx.backend_mvc.dto.request.WorkspaceUpdateRequest;
import com.xxxx.backend_mvc.dto.response.WorkspaceMemberResponse;
import com.xxxx.backend_mvc.dto.response.WorkspaceResponse;
import com.xxxx.backend_mvc.entity.User;
import com.xxxx.backend_mvc.entity.workspace.Workspace;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceInvitation;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceMember;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceRole;
import com.xxxx.backend_mvc.enums.InvitationStatus;
import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.mapper.WorkspaceMapper;
import com.xxxx.backend_mvc.repository.*;
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class WorkspaceService {

    WorkspaceRepository workspaceRepository;
    WorkspaceRoleRepository workspaceRoleRepository;
    WorkspaceMemberRepository workspaceMemberRepository;
    InvitationRepository invitationRepository;
    UserRepository userRepository;
    WorkspaceMapper workspaceMapper;

    BackgroundJobService backgroundJobService;

    @Transactional
    public WorkspaceResponse createWorkspace(WorkspaceCreateRequest request) {

        String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        Workspace workspace = Workspace.builder()
                .name(request.getName())
                .type(request.getType())
                .access(request.getAccess())
                .build();

        workspace = workspaceRepository.save(workspace);

        // Tạo role ADMIN của workspace
        WorkspaceRole adminRole = WorkspaceRole.builder()
                .workspace(workspace)
                .roleName(WorkspaceRoleType.ADMIN)
                .build();

        adminRole = workspaceRoleRepository.save(adminRole);

        // Tạo membership cho user tạo workspace
        WorkspaceMember member = WorkspaceMember.builder()
                .workspace(workspace)
                .user(user)
                .workspaceRole(adminRole)
                .build();

        workspaceMemberRepository.save(member);

        return workspaceMapper.toWorkspaceResponse(workspace);
    }

    @Transactional
    public WorkspaceResponse updateWorkspace(String workspaceId, WorkspaceUpdateRequest request) {

        String userId = SecurityContextHolder.getContext().getAuthentication().getName();

        Workspace workspace = workspaceRepository.findById(workspaceId)
                .orElseThrow(()->new AppException(ErrorCode.WORKSPACE_NOT_FOUND));

        WorkspaceMember member = workspaceMemberRepository
                .findByWorkspaceIdAndUserId(workspaceId, userId)
                .orElseThrow(()->new AppException(ErrorCode.NOT_ADMIN_OF_WORKSPACE));

        if (member.getWorkspaceRole() == null ||
                member.getWorkspaceRole().getRoleName() != WorkspaceRoleType.ADMIN) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        workspaceMapper.updateWorkspace(workspace, request);
        workspaceRepository.save(workspace);

        return workspaceMapper.toWorkspaceResponse(workspace);
    }

    @Transactional
    public void inviteMemberToWorkspace(
            String workspaceId,
            WorkspaceAddMemberRequest request) {

        String currentUserId = SecurityContextHolder.getContext()
                .getAuthentication().getName();

        Workspace workspace = workspaceRepository.findById(workspaceId)
                .orElseThrow(() -> new AppException(ErrorCode.WORKSPACE_NOT_FOUND));

        WorkspaceMember currentMember = workspaceMemberRepository
                .findByWorkspaceIdAndUserId(workspaceId, currentUserId)
                .orElseThrow(() -> new AppException(ErrorCode.NOT_ADMIN_OF_WORKSPACE));

        if (currentMember.getWorkspaceRole().getRoleName() != WorkspaceRoleType.ADMIN) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        // Không cho gửi invite trùng
        if (invitationRepository.existsByWorkspaceIdAndEmailAndStatus(
                workspaceId,
                request.getEmail(),
                InvitationStatus.PENDING
        )) {
            throw new AppException(ErrorCode.INVITATION_ALREADY_SENT);
        }

        //Tạo invitation
        WorkspaceInvitation invitation = invitationRepository.save(
                WorkspaceInvitation.builder()
                        .email(request.getEmail())
                        .workspaceId(workspaceId)
                        .inviterId(currentUserId)
                        .status(InvitationStatus.PENDING)
                        .expiredAt(Instant.now().plus(3, ChronoUnit.DAYS))
                        .build()
        );

        User inviter = userRepository.findById(currentUserId).orElseThrow();

        //Gửi mail sau commit
        TransactionSynchronizationManager.registerSynchronization(
                new TransactionSynchronization() {
                    @Override
                    public void afterCommit() {
                        backgroundJobService.sendInviteEmailAsync(
                                request.getEmail(),
                                workspace.getName(),
                                inviter.getFirstName() + " " + inviter.getLastName(),
                                invitation.getId()
                        );
                    }
                }
        );
    }


    @Transactional
    public List<WorkspaceResponse> getAllWorkspaces(){
        String userId = SecurityContextHolder.getContext().getAuthentication().getName();

        List<WorkspaceMember> members = workspaceMemberRepository.findAllByUserId(userId);

        return members.stream()
                .map(member -> {
                    Workspace workspace = member.getWorkspace();

                    WorkspaceResponse response = workspaceMapper.toWorkspaceResponse(workspace);

                    response.setRoles(List.of(member.getWorkspaceRole().getRoleName().name()));

                    response.setOwnerId(
                            workspace.getMembers().stream()
                                    .filter(m -> m.getWorkspaceRole().getRoleName() == WorkspaceRoleType.ADMIN)
                                    .map(m -> m.getUser().getId())
                                    .findFirst()
                                    .orElse(null)
                    );

                    return response;
                })
                .toList();
    }

    @Transactional
    public void deleteWorkspace(String workspaceId){
        String currentUserId = SecurityContextHolder.getContext().getAuthentication().getName();

        Workspace workspace = workspaceRepository.findById(workspaceId)
                .orElseThrow(() -> new AppException(ErrorCode.WORKSPACE_NOT_FOUND));

        WorkspaceMember currentMember = workspaceMemberRepository
                .findByWorkspaceIdAndUserId(workspaceId, currentUserId)
                .orElseThrow(() -> new AppException(ErrorCode.NOT_ADMIN_OF_WORKSPACE));

        if(currentMember.getWorkspaceRole() == null ||
                currentMember.getWorkspaceRole().getRoleName() != WorkspaceRoleType.ADMIN){
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        workspaceRepository.delete(workspace);
    }


    @Transactional
    public List<WorkspaceMemberResponse> getMembers(String workspaceId) {

        String currentUserId = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        WorkspaceMember currentMember = workspaceMemberRepository
                .findByWorkspaceIdAndUserId(workspaceId, currentUserId)
                .orElseThrow(() -> new AppException(ErrorCode.NO_PERMISSION));

        // chỉ member mới xem được
        List<WorkspaceMember> members =
                workspaceMemberRepository.findAllByWorkspaceId(workspaceId);

        return members.stream()
                .map(member -> WorkspaceMemberResponse.builder()
                        .userId(member.getUser().getId())
                        .email(member.getUser().getEmail())
                        .role(member.getWorkspaceRole().getRoleName())
                        .build()
                )
                .toList();
    }


}
