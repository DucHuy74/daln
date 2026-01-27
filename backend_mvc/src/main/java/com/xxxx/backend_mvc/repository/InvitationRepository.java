package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.workspace.WorkspaceInvitation;
import com.xxxx.backend_mvc.enums.InvitationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface InvitationRepository extends JpaRepository<WorkspaceInvitation, String> {
    boolean existsByWorkspaceIdAndInviteeUserIdAndStatus(
            String workspaceId,
            String inviteeUserId,
            InvitationStatus status
    );

    List<WorkspaceInvitation> findByInviteeUserIdAndStatus(
            String inviteeUserId,
            InvitationStatus status
    );
}
