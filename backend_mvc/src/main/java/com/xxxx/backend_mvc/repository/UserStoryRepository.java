package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.UserStory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserStoryRepository extends JpaRepository<UserStory, String> {
    List<UserStory> findByWorkspace_IdAndSprintIsNull(String workspaceId);

    List<UserStory> findBySprint_Id(String sprintId);
}
