package com.xxxx.backend_mvc.repository;

import com.xxxx.backend_mvc.entity.Notification;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, String> {
    List<Notification> findByUserIdAndReadFalseOrderByCreatedAtDesc(String userId);

    @Transactional
    @Modifying
    @Query("""
        update Notification n
        set n.read = true
        where n.userId = :userId
          and n.read = false
    """)
    int markAllAsReadByUserId(@Param("userId") String userId);
}
