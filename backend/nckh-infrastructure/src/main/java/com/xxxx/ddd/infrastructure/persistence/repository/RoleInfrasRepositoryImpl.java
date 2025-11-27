package com.xxxx.ddd.infrastructure.persistence.repository;

import com.xxxx.ddd.domain.model.entity.Role;
import com.xxxx.ddd.domain.repository.RoleRepository;
import com.xxxx.ddd.infrastructure.persistence.mapper.RoleJPAMapper;
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
public class RoleInfrasRepositoryImpl implements RoleRepository {

    private final RoleJPAMapper jpa;

    @Override
    public Optional<Role> findById(String id) {
        return jpa.findById(id);
    }

    @Override
    public Optional<Role> findByName(String name) {
        return jpa.findByName(name);
    }

    @Override
    public List<Role> findAllById(Set<String> ids) {
        return jpa.findAllById(ids);
    }

    @Override
    public List<Role> findAll() {
        return jpa.findAll();
    }

    @Override
    public Role save(Role role) {
        return jpa.save(role);
    }

    @Override
    public void deleteById(String id) {
        jpa.deleteById(id);
    }

}
