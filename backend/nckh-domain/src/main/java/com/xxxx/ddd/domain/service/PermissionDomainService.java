package com.xxxx.ddd.domain.service;

import com.xxxx.ddd.domain.model.entity.Permission;

public interface PermissionDomainService {
    Permission getPermissionByName(String name);
}
