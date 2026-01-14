package com.xxxx.backend_mvc.service.userstory;

import com.xxxx.backend_mvc.dto.request.UserStoryCreateRequest;
import com.xxxx.backend_mvc.dto.request.UserStoryStatusUpdateRequest;
import com.xxxx.backend_mvc.dto.response.UserStoryResponse;

import java.util.List;

public interface UserStoryService {
    UserStoryResponse create(String workspaceId, UserStoryCreateRequest request);

    List<UserStoryResponse> getBacklog(String workspaceId);

    List<UserStoryResponse> getBySprint(String sprintId);

    UserStoryResponse updateStatus(String userStoryId, UserStoryStatusUpdateRequest request);

    void delete(String userStoryId);
}
