package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.InvalidatedToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InvalidatedTokenRepository extends JpaRepository<InvalidatedToken, String> {
}
