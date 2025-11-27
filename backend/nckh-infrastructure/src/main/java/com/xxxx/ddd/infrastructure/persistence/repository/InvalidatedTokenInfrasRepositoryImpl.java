package com.xxxx.ddd.infrastructure.persistence.repository;

import com.xxxx.ddd.domain.model.entity.InvalidatedToken;
import com.xxxx.ddd.domain.repository.InvalidatedTokenRepository;
import com.xxxx.ddd.infrastructure.persistence.mapper.InvalidatedTokenJPAMapper;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Repository
@AllArgsConstructor
public class InvalidatedTokenInfrasRepositoryImpl implements InvalidatedTokenRepository {

    InvalidatedTokenJPAMapper invalidatedTokenJPAMapper;

    @Override
    public Optional<InvalidatedToken> findById(String id) {
        return invalidatedTokenJPAMapper.findById(id);
    }
}
