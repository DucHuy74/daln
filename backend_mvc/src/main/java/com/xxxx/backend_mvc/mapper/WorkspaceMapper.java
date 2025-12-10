package com.xxxx.backend_mvc.mapper;

import com.xxxx.backend_mvc.dto.request.WorkspaceCreateRequest;
import com.xxxx.backend_mvc.dto.request.WorkspaceUpdateRequest;
import com.xxxx.backend_mvc.dto.response.WorkspaceResponse;
import com.xxxx.backend_mvc.entity.workspace.Workspace;
import java.util.stream.Collectors;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface WorkspaceMapper {
    Workspace toWorkspace(WorkspaceCreateRequest request);

    WorkspaceResponse toWorkspaceResponse(Workspace workspace);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "backlogs", ignore = true)
    @Mapping(target = "sprints", ignore = true)
    @Mapping(target = "workspaceRoles", ignore = true)
    void updateWorkspace(@MappingTarget Workspace workspace, WorkspaceUpdateRequest request);
}
