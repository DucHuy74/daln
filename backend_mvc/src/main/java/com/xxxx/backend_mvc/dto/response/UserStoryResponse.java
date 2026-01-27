package com.xxxx.backend_mvc.dto.response;

import com.xxxx.backend_mvc.enums.UserStoryStatus;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserStoryResponse {
    String id;
    String storyText;
    UserStoryStatus status;

    String sprintId;    // null = backlog
    String workspaceId;

    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}
