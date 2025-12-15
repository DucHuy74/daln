package com.xxxx.backend_mvc.dto.response;

import com.xxxx.backend_mvc.enums.NotificationType;
import lombok.Builder;
import lombok.Getter;

import java.time.Instant;

@Getter
@Builder
public class NotificationResponse {
    private String id;
    private String title;
    private String content;
    private NotificationType type;
    private String referenceId;
    private Instant createdAt;
    private boolean read;
}

