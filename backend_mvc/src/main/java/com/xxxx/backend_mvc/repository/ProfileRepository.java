package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.Profile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProfileRepository extends JpaRepository<Profile, String> {
    Optional<Profile> findByUserId(String userId);
    Optional<Profile> findByEmail(String email);
}
