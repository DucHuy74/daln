package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.entity.Profile;
import com.xxxx.backend_mvc.entity.workspace.*;
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
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Service;

import java.time.Instant;

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

    private Profile getCurrentProfile() {
        var authentication = SecurityContextHolder.getContext().getAuthentication();

        if (!(authentication instanceof JwtAuthenticationToken jwtAuth)) {
            throw new AppException(ErrorCode.UNAUTHORIZED);
        }

        String userId = jwtAuth.getToken().getSubject(); // sub từ Keycloak

        return profileRepository.findByUserId(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));
    }

    @Transactional
    public String accept(String token) {

        WorkspaceInvitation invitation = invitationRepository.findById(token)
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_INVITE));

        if (invitation.getStatus() != InvitationStatus.PENDING)
            throw new AppException(ErrorCode.INVITE_USED);

        if (invitation.getExpiredAt().isBefore(Instant.now()))
            throw new AppException(ErrorCode.INVITE_EXPIRED);

        Profile profile = profileRepository
                .findByEmail(invitation.getEmail())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));


        //Email trong invite phải trùng email user login
        if (!profile.getEmail().equalsIgnoreCase(invitation.getEmail())) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        Workspace workspace = workspaceRepository
                .findById(invitation.getWorkspaceId())
                .orElseThrow(() -> new AppException(ErrorCode.WORKSPACE_NOT_FOUND));

        if (workspaceMemberRepository
                .findByWorkspace_IdAndProfile_UserId(
                        workspace.getId(),
                        profile.getUserId())
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
    public void deny(String token) {

        WorkspaceInvitation invitation = invitationRepository.findById(token)
                .orElseThrow(() -> new AppException(ErrorCode.INVALID_INVITE));

        if (invitation.getStatus() != InvitationStatus.PENDING)
            throw new AppException(ErrorCode.INVITE_USED);

        Profile profile = profileRepository
                .findByEmail(invitation.getEmail())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));


        if (!profile.getEmail().equalsIgnoreCase(invitation.getEmail())) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        invitation.setStatus(InvitationStatus.REJECTED);
        invitationRepository.save(invitation);

        notificationService.notifyUser(
                invitation.getInviterId(),
                "Invitation denied",
                profile.getEmail() + " denied your invitation",
                NotificationType.INVITATION_DENIED,
                invitation.getWorkspaceId()
        );
    }
}
