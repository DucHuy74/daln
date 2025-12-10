package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.Sprint;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SprintRepository extends JpaRepository<Sprint, String> {
}
