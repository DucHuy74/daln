package com.xxxx.ddd.application.mapper;

import com.xxxx.ddd.application.model.dto.request.PermissionRequest;
import com.xxxx.ddd.application.model.dto.response.PermissionResponse;
import com.xxxx.ddd.domain.model.entity.Permission;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PermissionMapper {
    Permission toPermission(PermissionRequest request);

    PermissionResponse toPermissionResponse(Permission permission);
}
