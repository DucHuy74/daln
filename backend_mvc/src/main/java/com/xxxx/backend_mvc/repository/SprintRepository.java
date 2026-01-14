package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.Sprint;
import com.xxxx.backend_mvc.enums.SprintStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SprintRepository extends JpaRepository<Sprint, String> {
    List<Sprint> findByWorkspace_IdOrderByCreatedAtDesc(String workspaceId);

    boolean existsByWorkspace_IdAndStatus(String workspaceId, SprintStatus status);
}
