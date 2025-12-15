package com.xxxx.backend_mvc.controller;

import com.xxxx.backend_mvc.dto.request.ApiResponse;
import com.xxxx.backend_mvc.dto.response.NotificationResponse;
import com.xxxx.backend_mvc.entity.Notification;
import com.xxxx.backend_mvc.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/notifications")
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping("/unread")
    public ApiResponse<List<NotificationResponse>> getUnread() {

        String userId = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        return ApiResponse.<List<NotificationResponse>>builder()
                .result(notificationService.getUnread(userId))
                .build();
    }

    @PatchMapping("/{id}/read")
    public ApiResponse<Void> markAsRead(@PathVariable String id) {

        String userId = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        notificationService.markAsRead(id, userId);

        return ApiResponse.<Void>builder()
                .message("Marked as read")
                .build();
    }

}
