package com.xxxx.backend_mvc.dto.request;

import com.xxxx.backend_mvc.enums.WorkspaceAccess;
import com.xxxx.backend_mvc.enums.WorkspaceType;
import lombok.Data;

@Data
public class WorkspaceCreateRequest {
    private String name;
    private WorkspaceType type;
    private WorkspaceAccess access;
}