package com.xxxx.backend_mvc.service.sprint;

import com.xxxx.backend_mvc.dto.request.SprintCreateRequest;
import com.xxxx.backend_mvc.dto.response.SprintResponse;
import com.xxxx.backend_mvc.dto.response.UserStoryResponse;
import com.xxxx.backend_mvc.entity.UserStory;
import com.xxxx.backend_mvc.mapper.SprintMapper;
import com.xxxx.backend_mvc.repository.SprintRepository;
import com.xxxx.backend_mvc.repository.WorkspaceRepository;

import java.util.List;

public interface SprintService {

    SprintResponse createSprint(String workspaceId, SprintCreateRequest request);

    List<SprintResponse> getSprints(String workspaceId);

    void startSprint(String sprintId);

    void completeSprint(String sprintId);

    void addUserStoryToSprint(String sprintId, String userStoryId);

    void removeUserStoryFromSprint(String userStoryId);

    List<UserStoryResponse> getBacklog(String workspaceId);

    List<UserStoryResponse> getUserStoriesOfSprint(String sprintId);
}

