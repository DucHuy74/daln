package com.xxxx.ddd.application.service.permission;

import com.xxxx.ddd.application.model.dto.request.PermissionRequest;
import com.xxxx.ddd.application.model.dto.response.PermissionResponse;

import java.util.List;

public interface PermissionAppService {
    PermissionResponse create(PermissionRequest request);

    List<PermissionResponse> getAll();

    void delete(String permissionName);
}
