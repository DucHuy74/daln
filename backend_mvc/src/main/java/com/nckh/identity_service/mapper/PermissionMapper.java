package com.nckh.identity_service.mapper;

import org.mapstruct.Mapper;
import com.nckh.identity_service.dto.request.PermissionRequest;
import com.nckh.identity_service.dto.response.PermissionResponse;
import com.nckh.identity_service.entity.Permission;

@Mapper(componentModel = "spring")
public interface PermissionMapper {
    Permission toPermission(PermissionRequest request);

    PermissionResponse toPermissionResponse(Permission permission);
}