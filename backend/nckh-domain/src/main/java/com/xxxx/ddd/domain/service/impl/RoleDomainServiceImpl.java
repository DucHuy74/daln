package com.xxxx.ddd.domain.service.impl;

import com.xxxx.ddd.domain.model.entity.Role;
import com.xxxx.ddd.domain.repository.RoleRepository;
import com.xxxx.ddd.domain.service.RoleDomainService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class RoleDomainServiceImpl implements RoleDomainService {
    @Autowired
    private RoleRepository roleRepository;

    @Override
    public Role getRoleByName(String name) {
        return roleRepository.findByName(name).orElse(null);
    }
}
