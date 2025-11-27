package com.xxxx.ddd.domain.service.impl;

import com.xxxx.ddd.domain.model.entity.InvalidatedToken;
import com.xxxx.ddd.domain.repository.InvalidatedTokenRepository;
import com.xxxx.ddd.domain.service.InvalidatedTokenDomainService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class InvalidatedTokenDomainServiceImpl implements InvalidatedTokenDomainService {

    @Autowired
    private InvalidatedTokenRepository invalidatedTokenRepository;

    @Override
    public InvalidatedToken getInvalidatedTokenById(String id) {
        return invalidatedTokenRepository.findById(id).orElse(null);
    }
}
