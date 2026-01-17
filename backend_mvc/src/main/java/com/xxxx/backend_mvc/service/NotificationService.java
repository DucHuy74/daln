package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.dto.response.NotificationResponse;
import com.xxxx.backend_mvc.entity.Notification;
import com.xxxx.backend_mvc.enums.NotificationType;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.repository.NotificationRepository;
import com.xxxx.backend_mvc.service.ws.SocketService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class NotificationService {

    NotificationRepository notificationRepository;
    SocketService socketService;

    /**
     * Tạo notification + gửi realtime nếu user online
     */
    @Transactional
    public Notification notifyUser(
            String userId,
            String title,
            String content,
            NotificationType type,
            String refId
    ) {
        Notification notification = Notification.builder()
                .userId(userId)
                .title(title)
                .content(content)
                .type(type)
                .referenceId(refId)
                .read(false)
                .createdAt(Instant.now())
                .build();

        notificationRepository.save(notification);

        if (socketService.isOnline(userId)) {
            socketService.send(userId, notification);
        }

        return notification;
    }

    @Transactional(readOnly = true)
    public List<NotificationResponse> getUnread(String userId) {
        return notificationRepository
                .findByUserIdAndReadFalseOrderByCreatedAtDesc(userId)
                .stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional
    public void markAsRead(String notificationId, String userId) {

        Notification notification = notificationRepository.findById(notificationId)
                .orElseThrow(() ->
                        new AppException(ErrorCode.NOTIFICATION_NOT_FOUND));

        if (!notification.getUserId().equals(userId)) {
            throw new AppException(ErrorCode.NO_PERMISSION);
        }

        notification.setRead(true);
    }


    @Transactional
    public void markAllAsRead(String userId) {
        notificationRepository.markAllAsReadByUserId(userId);
    }

    private NotificationResponse toResponse(Notification n) {
        return NotificationResponse.builder()
                .id(n.getId())
                .title(n.getTitle())
                .content(n.getContent())
                .type(n.getType())
                .referenceId(n.getReferenceId())
                .createdAt(n.getCreatedAt())
                .read(n.isRead())
                .build();
    }
}
