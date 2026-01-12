package com.xxxx.backend_mvc.dto.request;

import com.xxxx.backend_mvc.enums.UserStoryStatus;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserStoryStatusUpdateRequest {
    UserStoryStatus status;
}