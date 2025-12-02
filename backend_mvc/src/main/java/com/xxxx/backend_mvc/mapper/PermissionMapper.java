package com.xxxx.backend_mvc.mapper;

import com.xxxx.backend_mvc.dto.request.PermissionRequest;
import com.xxxx.backend_mvc.dto.response.PermissionResponse;
import com.xxxx.backend_mvc.entity.Permission;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface PermissionMapper {
    Permission toPermission(PermissionRequest request);

    PermissionResponse toPermissionResponse(Permission permission);

}