package com.xxxx.ddd.application.service.permission.impl;

import com.xxxx.ddd.application.mapper.PermissionMapper;
import com.xxxx.ddd.application.model.dto.request.PermissionRequest;
import com.xxxx.ddd.application.model.dto.response.PermissionResponse;
import com.xxxx.ddd.application.service.permission.PermissionAppService;
import com.xxxx.ddd.domain.model.entity.Permission;
import com.xxxx.ddd.domain.repository.PermissionRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class PermissionAppServiceImpl implements PermissionAppService {
    PermissionRepository permissionRepository;
    PermissionMapper permissionMapper;

    @Override
    public PermissionResponse create(PermissionRequest request) {
        Permission permission = permissionMapper.toPermission(request);
        Permission savedPermission = permissionRepository.save(permission);
        return permissionMapper.toPermissionResponse(savedPermission);
    }

    @Override
    public List<PermissionResponse> getAll() {
        return permissionRepository.findAll()
                .stream()
                .map(permissionMapper::toPermissionResponse)
                .toList();
    }

    @Override
    public void delete(String permissionName) {
        permissionRepository.deleteByName(permissionName);
    }
}
