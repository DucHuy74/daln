package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.entity.User;
import com.xxxx.backend_mvc.entity.workspace.Workspace;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceInvitation;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceMember;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceRole;
import com.xxxx.backend_mvc.enums.InvitationStatus;
import com.xxxx.backend_mvc.enums.NotificationType;
import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.repository.*;
import jakarta.transaction.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class InvitationService {
    InvitationRepository invitationRepository;
    WorkspaceMemberRepository workspaceMemberRepository;
    WorkspaceRepository workspaceRepository;
    UserRepository userRepository;
    WorkspaceRoleRepository workspaceRoleRepository;
    NotificationService notificationService;

    @Transactional
    public String accept(String token) {

        WorkspaceInvitation invitation = invitationRepository.findById(token)
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_INVITE));

        if (invitation.getStatus() != InvitationStatus.PENDING)
            throw new AppException(ErrorCode.INVITE_USED);

        if (invitation.getExpiredAt().isBefore(Instant.now()))
            throw new AppException(ErrorCode.INVITE_EXPIRED);

        User user = userRepository.findByEmail(invitation.getEmail())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        Workspace workspace = workspaceRepository
                .findById(invitation.getWorkspaceId())
                .orElseThrow();

        if (workspaceMemberRepository
                .findByWorkspaceIdAndUserId(workspace.getId(), user.getId())
                .isPresent()) {
            throw new AppException(ErrorCode.MEMBER_EXISTED);
        }

        WorkspaceRole role = workspaceRoleRepository
                .findByWorkspaceAndRoleName(workspace, WorkspaceRoleType.MEMBER)
                .orElseGet(() -> workspaceRoleRepository.save(
                        WorkspaceRole.builder()
                                .workspace(workspace)
                                .roleName(WorkspaceRoleType.MEMBER)
                                .build()
                ));


        workspaceMemberRepository.save(
                WorkspaceMember.builder()
                        .workspace(workspace)
                        .user(user)
                        .workspaceRole(role)
                        .build()
        );

        invitation.setStatus(InvitationStatus.ACCEPTED);
        invitationRepository.save(invitation);

        notificationService.notifyUser(
                invitation.getInviterId(),
                "Invitation accepted",
                user.getEmail() + " accepted your invitation",
                NotificationType.INVITATION_ACCEPTED,
                workspace.getId()
        );

        return workspace.getId();
    }

    public void deny(String token) {

        WorkspaceInvitation invitation = invitationRepository.findById(token)
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_INVITE));

        if (invitation.getStatus() != InvitationStatus.PENDING) {
            throw new AppException(ErrorCode.INVITE_USED);
        }

        User user = userRepository.findByEmail(invitation.getEmail())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        invitation.setStatus(InvitationStatus.REJECTED);
        invitationRepository.save(invitation);

        notificationService.notifyUser(
                invitation.getInviterId(),
                "Invitation denied",
                user.getEmail() + " denied your invitation",
                NotificationType.INVITATION_DENIED,
                invitation.getWorkspaceId()
        );
    }

}
