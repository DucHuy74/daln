package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.workspace.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WorkspaceRepository extends JpaRepository<Workspace, String> {
}
