package com.xxxx.backend_mvc.mapper;

import com.xxxx.backend_mvc.dto.request.RoleRequest;
import com.xxxx.backend_mvc.dto.response.RoleResponse;
import com.xxxx.backend_mvc.entity.Role;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface RoleMapper {
    @Mapping(target = "permissions", ignore = true)
    Role toRole(RoleRequest request);

    RoleResponse toRoleResponse(Role role);

}