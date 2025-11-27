package com.xxxx.ddd.domain.repository;

import com.xxxx.ddd.domain.model.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface RoleRepository{
    Optional<Role> findById(String id);

    Optional<Role> findByName(String name);

    List<Role> findAllById(Set<String> ids);

    List<Role> findAll();

    Role save(Role role);

    void deleteById(String id);
}
