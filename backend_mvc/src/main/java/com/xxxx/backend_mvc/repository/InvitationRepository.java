package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.workspace.WorkspaceInvitation;
import com.xxxx.backend_mvc.enums.InvitationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InvitationRepository extends JpaRepository<WorkspaceInvitation, String> {
    boolean existsByWorkspaceIdAndEmailAndStatus(
            String workspaceId,
            String email,
            InvitationStatus status
    );
}
