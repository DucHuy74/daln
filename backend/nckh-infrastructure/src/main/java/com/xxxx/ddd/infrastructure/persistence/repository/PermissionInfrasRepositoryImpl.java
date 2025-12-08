package com.xxxx.ddd.infrastructure.persistence.repository;

import com.xxxx.ddd.domain.model.entity.Permission;
import com.xxxx.ddd.domain.repository.PermissionRepository;
import com.xxxx.ddd.infrastructure.persistence.mapper.PermissionJPAMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
@RequiredArgsConstructor
public class PermissionInfrasRepositoryImpl implements PermissionRepository {

    private final PermissionJPAMapper jpa;

    @Override
    public Optional<Permission> findByName(String name) {
        return jpa.findByName(name);
    }

    @Override
    public List<Permission> findAllByNameIn(Set<String> names) {
        return jpa.findAllByNameIn(names);
    }

    @Override
    public Permission save(Permission permission) {
        return jpa.save(permission);
    }

    @Override
    public List<Permission> findAll() {
        return jpa.findAll();
    }

    @Override
    public void deleteByName(String name) {
        jpa.deleteById(name); // name là @Id
    }
}
