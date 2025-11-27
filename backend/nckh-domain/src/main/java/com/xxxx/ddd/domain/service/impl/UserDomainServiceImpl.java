package com.xxxx.ddd.domain.service.impl;

import com.xxxx.ddd.domain.model.entity.User;
import com.xxxx.ddd.domain.repository.UserRepository;
import com.xxxx.ddd.domain.service.UserDomainService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class UserDomainServiceImpl implements UserDomainService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public User getUserById(String userId) {
        return userRepository.findById(userId).orElse(null);
    }
}
