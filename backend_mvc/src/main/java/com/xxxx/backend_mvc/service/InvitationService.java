package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.dto.response.InvitationResponse;
import com.xxxx.backend_mvc.entity.Profile;
import com.xxxx.backend_mvc.entity.workspace.*;
import com.xxxx.backend_mvc.enums.InvitationStatus;
import com.xxxx.backend_mvc.enums.NotificationType;
import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.repository.*;
import org.springframework.transaction.annotation.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class InvitationService {

    InvitationRepository invitationRepository;
    WorkspaceRepository workspaceRepository;
    WorkspaceMemberRepository workspaceMemberRepository;
    WorkspaceRoleRepository workspaceRoleRepository;
    ProfileRepository profileRepository;
    NotificationService notificationService;


    @Transactional
    public String accept(String invitationId, String userId) {

        WorkspaceInvitation invitation = invitationRepository.findById(invitationId)
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_INVITE));

        if (invitation.getStatus() != InvitationStatus.PENDING)
            throw new AppException(ErrorCode.INVITE_USED);

        if (invitation.getExpiredAt().isBefore(Instant.now()))
            throw new AppException(ErrorCode.INVITE_EXPIRED);

        //Check đúng người được mời
        if (!invitation.getInviteeUserId().equals(userId)) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        Profile profile = profileRepository.findByUserId(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        Workspace workspace = workspaceRepository.findById(invitation.getWorkspaceId())
                .orElseThrow(() -> new AppException(ErrorCode.WORKSPACE_NOT_FOUND));

        if (workspaceMemberRepository
                .findByWorkspace_IdAndProfile_UserId(workspace.getId(), userId)
                .isPresent()) {
            throw new AppException(ErrorCode.MEMBER_EXISTED);
        }

        WorkspaceRole memberRole = workspaceRoleRepository
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
                        .profile(profile)
                        .workspaceRole(memberRole)
                        .build()
        );

        invitation.setStatus(InvitationStatus.ACCEPTED);
        invitationRepository.save(invitation);

        notificationService.notifyUser(
                invitation.getInviterId(),
                "Invitation accepted",
                profile.getEmail() + " accepted your invitation",
                NotificationType.INVITATION_ACCEPTED,
                workspace.getId()
        );

        return workspace.getId();
    }


    @Transactional
    public void deny(String invitationId, String userId) {

        WorkspaceInvitation invitation = invitationRepository.findById(invitationId)
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_INVITE));

        if (invitation.getStatus() != InvitationStatus.PENDING)
            throw new AppException(ErrorCode.INVITE_USED);

        if (!invitation.getInviteeUserId().equals(userId)) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        invitation.setStatus(InvitationStatus.REJECTED);
        invitationRepository.save(invitation);

        notificationService.notifyUser(
                invitation.getInviterId(),
                "Invitation denied",
                "Invitation was denied",
                NotificationType.INVITATION_DENIED,
                invitation.getWorkspaceId()
        );
    }

    @Transactional(readOnly = true)
    public List<InvitationResponse> getMyPendingInvitations(String userId) {

        return invitationRepository
                .findByInviteeUserIdAndStatus(userId, InvitationStatus.PENDING)
                .stream()
                .map(inv -> InvitationResponse.builder()
                        .id(inv.getId())
                        .workspaceId(inv.getWorkspaceId())
                        .inviterId(inv.getInviterId())
                        .expiredAt(inv.getExpiredAt())
                        .build()
                )
                .toList();
    }

}
