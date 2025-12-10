package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.Backlog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BacklogRepository extends JpaRepository<Backlog, String> {
}
