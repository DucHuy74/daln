package com.xxxx.ddd.domain.service.impl;

import com.xxxx.ddd.domain.model.entity.Permission;
import com.xxxx.ddd.domain.repository.PermissionRepository;
import com.xxxx.ddd.domain.service.PermissionDomainService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class PermissionDomainServiceImpl implements PermissionDomainService {

    @Autowired
    private PermissionRepository permissionRepository;

    @Override
    public Permission getPermissionByName(String name) {
        return permissionRepository.findByName(name).orElse(null);
    }
}
