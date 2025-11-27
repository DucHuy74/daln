package com.xxxx.ddd.domain.service;

import com.xxxx.ddd.domain.model.entity.InvalidatedToken;

public interface InvalidatedTokenDomainService {
    InvalidatedToken getInvalidatedTokenById(String id);
}
