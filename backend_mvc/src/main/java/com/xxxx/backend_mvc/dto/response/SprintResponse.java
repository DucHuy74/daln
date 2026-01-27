package com.xxxx.backend_mvc.dto.response;

import com.xxxx.backend_mvc.enums.SprintStatus;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SprintResponse {
    String id;
    String name;
    SprintStatus status;
    LocalDateTime createdAt;
}
