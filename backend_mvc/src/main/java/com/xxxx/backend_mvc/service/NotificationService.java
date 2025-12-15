package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.dto.response.NotificationResponse;
import com.xxxx.backend_mvc.entity.Notification;
import com.xxxx.backend_mvc.enums.NotificationType;
import com.xxxx.backend_mvc.repository.NotificationRepository;
import com.xxxx.backend_mvc.service.ws.SocketService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final SocketService socketService;

    public void notifyUser(
            String userId,
            String title,
            String content,
            NotificationType type,
            String refId
    ) {
        Notification notification = notificationRepository.save(
                Notification.builder()
                        .userId(userId)
                        .title(title)
                        .content(content)
                        .type(type)
                        .referenceId(refId)
                        .read(false)
                        .createdAt(Instant.now())
                        .build()
        );

        // Nếu user online → gửi realtime
        if (socketService.isOnline(userId)) {
            socketService.send(userId, notification);
        }
    }

    public List<NotificationResponse> getUnread(String userId) {
        return notificationRepository
                .findByUserIdAndReadFalseOrderByCreatedAtDesc(userId)
                .stream()
                .map(n -> NotificationResponse.builder()
                        .id(n.getId())
                        .title(n.getTitle())
                        .content(n.getContent())
                        .type(n.getType())
                        .referenceId(n.getReferenceId())
                        .createdAt(n.getCreatedAt())
                        .read(n.isRead())
                        .build()
                )
                .toList();
    }


    public void markAsRead(String notificationId, String userId) {
        Notification noti = notificationRepository.findById(notificationId)
                .orElseThrow();

        if (!noti.getUserId().equals(userId)) {
            throw new RuntimeException("No permission");
        }

        noti.setRead(true);
        notificationRepository.save(noti);
    }

}