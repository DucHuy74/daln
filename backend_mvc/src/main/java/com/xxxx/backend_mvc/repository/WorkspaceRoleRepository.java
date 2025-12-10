package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.workspace.Workspace;
import com.xxxx.backend_mvc.entity.workspace.WorkspaceRole;
import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface WorkspaceRoleRepository extends JpaRepository<WorkspaceRole, String> {
    Optional<WorkspaceRole> findByWorkspaceAndRoleName(Workspace workspace, WorkspaceRoleType roleName);
}
