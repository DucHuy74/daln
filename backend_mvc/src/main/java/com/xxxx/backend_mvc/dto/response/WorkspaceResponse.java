package com.xxxx.backend_mvc.dto.response;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.xxxx.backend_mvc.enums.WorkspaceAccess;
import com.xxxx.backend_mvc.enums.WorkspaceType;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class WorkspaceResponse {
    String id;
    String name;
    WorkspaceType type;
    WorkspaceAccess access;

    LocalDate createdAt;
    LocalDate updatedAt;

    Integer totalBacklogs;
    Integer totalSprints;

    List<String> roles;

    String ownerId;
}
