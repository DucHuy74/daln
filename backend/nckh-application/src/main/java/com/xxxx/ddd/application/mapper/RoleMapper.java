package com.xxxx.ddd.application.mapper;

import com.xxxx.ddd.application.model.dto.request.RoleRequest;
import com.xxxx.ddd.application.model.dto.response.RoleResponse;
import com.xxxx.ddd.domain.model.entity.Role;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface RoleMapper {
    @Mapping(target = "permissions", ignore = true)
    Role toRole(RoleRequest request);

    RoleResponse toRoleResponse(Role role);
}
