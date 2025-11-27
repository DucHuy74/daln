package com.xxxx.ddd.application.service.role.impl;

import com.xxxx.ddd.application.mapper.RoleMapper;
import com.xxxx.ddd.application.model.dto.request.RoleRequest;
import com.xxxx.ddd.application.model.dto.response.RoleResponse;
import com.xxxx.ddd.application.service.role.RoleAppService;
import com.xxxx.ddd.domain.model.entity.Role;
import com.xxxx.ddd.domain.repository.PermissionRepository;
import com.xxxx.ddd.domain.repository.RoleRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class RoleAppServiceImpl implements RoleAppService {

    RoleRepository roleRepository;
    PermissionRepository permissionRepository;
    RoleMapper roleMapper;

    @Override
    public RoleResponse create(RoleRequest request) {
        Role role = roleMapper.toRole(request);

        var permissions = permissionRepository.findAllById(request.getPermissions());
        role.setPermissions(new HashSet<>(permissions));

        Role savedRole = roleRepository.save(role);
        return roleMapper.toRoleResponse(savedRole);
    }

    @Override
    public List<RoleResponse> getAll() {
        return roleRepository.findAll()
                .stream()
                .map(roleMapper::toRoleResponse)
                .toList();
    }

    @Override
    public void delete(String roleName) {
        roleRepository.deleteById(roleName);
    }
}