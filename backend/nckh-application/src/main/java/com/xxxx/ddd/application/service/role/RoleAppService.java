package com.xxxx.ddd.application.service.role;

import com.xxxx.ddd.application.model.dto.request.RoleRequest;
import com.xxxx.ddd.application.model.dto.response.RoleResponse;

import java.util.List;

public interface RoleAppService {
    RoleResponse create(RoleRequest request);

    List<RoleResponse> getAll();

    void delete(String roleName);
}
