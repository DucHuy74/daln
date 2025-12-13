package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.entity.User;
import com.xxxx.backend_mvc.entity.workspace.Workspace;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceInvitation;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceMember;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceRole;
import com.xxxx.backend_mvc.enums.InvitationStatus;
import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import com.xxxx.backend_mvc.repository.*;
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

    public String accept(String token) {

        WorkspaceInvitation invitation = invitationRepository.findById(token)
                .orElseThrow(() -> new RuntimeException("Invalid invitation"));

        if (invitation.getStatus() != InvitationStatus.PENDING) {
            throw new RuntimeException("Invitation already processed");
        }

        if (invitation.getExpiredAt().isBefore(Instant.now())) {
            throw new RuntimeException("Invitation expired");
        }

        User user = userRepository.findByEmail(invitation.getEmail())
                .orElseThrow(() -> new RuntimeException("User not registered"));

        Workspace workspace = workspaceRepository.findById(invitation.getWorkspaceId())
                .orElseThrow(() -> new RuntimeException("Workspace not found"));

        // check member existed (idempotent)
        if (workspaceMemberRepository
                .findByWorkspaceIdAndUserId(workspace.getId(), user.getId())
                .isEmpty()) {

            WorkspaceRole memberRole = workspaceRoleRepository
                    .findByWorkspaceAndRoleName(workspace, WorkspaceRoleType.MEMBER)
                    .orElseThrow();

            workspaceMemberRepository.save(
                    WorkspaceMember.builder()
                            .workspace(workspace)
                            .user(user)
                            .workspaceRole(memberRole)
                            .build()
            );
        }

        invitation.setStatus(InvitationStatus.ACCEPTED);
        invitationRepository.save(invitation);

        return workspace.getId();
    }

    public void deny(String token) {

        WorkspaceInvitation invitation = invitationRepository.findById(token)
                .orElseThrow(() -> new RuntimeException("Invalid invitation"));

        if (invitation.getStatus() != InvitationStatus.PENDING) {
            throw new RuntimeException("Invitation already processed");
        }

        invitation.setStatus(InvitationStatus.REJECTED);
        invitationRepository.save(invitation);
    }
}
