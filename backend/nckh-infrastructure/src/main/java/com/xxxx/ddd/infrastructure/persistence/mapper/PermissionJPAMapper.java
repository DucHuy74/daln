package com.xxxx.ddd.infrastructure.persistence.mapper;

import com.xxxx.ddd.domain.model.entity.Permission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Repository
public interface PermissionJPAMapper extends JpaRepository<Permission, String> {
    Optional<Permission> findById(String id);
    Optional<Permission> findByName(String name);
    List<Permission> findAllById(Set<String> ids);
    Permission save(Permission permission);
    List<Permission> findAll();
    void deleteById(String id);
}
