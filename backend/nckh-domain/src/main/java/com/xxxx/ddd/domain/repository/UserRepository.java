package com.xxxx.ddd.domain.repository;

import com.xxxx.ddd.domain.model.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserRepository {
    Optional<User> findById(String id);
    boolean existsByUsername(String username);
    Optional<User> findByUsername(String username);
    User save(User user);
    List<User> findAll();
    void deleteById(String id);
    List<User> findAllById(Iterable<String> ids);
}
