package com.xxxx.backend_mvc.dto.response;

import com.xxxx.backend_mvc.enums.WorkspaceRoleType;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class WorkspaceMemberResponse {
    String userId;
    String email;
    WorkspaceRoleType role;
}
