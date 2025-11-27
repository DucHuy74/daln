package com.xxxx.ddd.infrastructure.persistence.repository;

import com.xxxx.ddd.domain.model.entity.User;
import com.xxxx.ddd.domain.repository.UserRepository;
import com.xxxx.ddd.infrastructure.persistence.mapper.UserJPAMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class UserInfrasRepositoryImpl implements UserRepository {

    private final UserJPAMapper jpa;

    @Override
    public Optional<User> findById(String id){
        return jpa.findById(id);
    }

    @Override
    public boolean existsByUsername(String username) {
        return jpa.existsByUsername(username);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return jpa.findByUsername(username);
    }

    @Override
    public User save(User user) {
        return jpa.save(user);
    }

    @Override
    public List<User> findAll() {
        return jpa.findAll();
    }

    @Override
    public void deleteById(String id) {
        jpa.deleteById(id);
    }

    @Override
    public List<User> findAllById(Iterable<String> ids) {
        return jpa.findAllById(ids);
    }
}