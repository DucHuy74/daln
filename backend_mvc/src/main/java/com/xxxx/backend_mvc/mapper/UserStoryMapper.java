package com.xxxx.backend_mvc.mapper;

import com.xxxx.backend_mvc.dto.request.UserStoryCreateRequest;
import com.xxxx.backend_mvc.dto.response.UserStoryResponse;
import com.xxxx.backend_mvc.entity.UserStory;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UserStoryMapper {
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "status", constant = "ToDo")
    @Mapping(target = "sprint", ignore = true)
    @Mapping(target = "workspace", ignore = true)
    UserStory toEntity(UserStoryCreateRequest request);

    @Mapping(target = "sprintId", source = "sprint.id")
    @Mapping(target = "workspaceId", source = "workspace.id")
    UserStoryResponse toResponse(UserStory entity);

    List<UserStoryResponse> toResponses(List<UserStory> entities);
}
