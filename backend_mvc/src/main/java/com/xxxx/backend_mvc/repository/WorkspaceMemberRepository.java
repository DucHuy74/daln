package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.workspace.WorkspaceMember;
import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WorkspaceMemberRepository extends JpaRepository<WorkspaceMember, String> {
    Optional<WorkspaceMember> findByWorkspaceIdAndUserId(String workspaceId, String userId);

    List<WorkspaceMember> findAllByUserId(String userId);

    List<WorkspaceMember> findAllByWorkspaceId(String workspaceId);

}
