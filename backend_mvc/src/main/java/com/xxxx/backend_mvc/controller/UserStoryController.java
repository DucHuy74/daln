package com.xxxx.backend_mvc.controller;

import com.xxxx.backend_mvc.dto.ApiResponse;
import com.xxxx.backend_mvc.dto.request.UserStoryCreateRequest;
import com.xxxx.backend_mvc.dto.request.UserStoryStatusUpdateRequest;
import com.xxxx.backend_mvc.dto.response.UserStoryResponse;
import com.xxxx.backend_mvc.service.userstory.UserStoryService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@RequestMapping("/user-stories")
public class UserStoryController {

    UserStoryService userStoryService;

    // Create user story
    @PostMapping("/workspace/{workspaceId}")
    public ResponseEntity<ApiResponse<UserStoryResponse>> createUserStory(
            @PathVariable String workspaceId,
            @RequestBody UserStoryCreateRequest request
    ) {
        return ResponseEntity.ok(
                ApiResponse.<UserStoryResponse>builder()
                        .message("User story created successfully")
                        .result(userStoryService.create(workspaceId, request))
                        .build()
        );
    }

    // Get backlog of workspace
    @GetMapping("/workspace/{workspaceId}/backlog")
    public ResponseEntity<ApiResponse<List<UserStoryResponse>>> getBacklog(
            @PathVariable String workspaceId
    ) {
        return ResponseEntity.ok(
                ApiResponse.<List<UserStoryResponse>>builder()
                        .message("Get backlog user stories successfully")
                        .result(userStoryService.getBacklog(workspaceId))
                        .build()
        );
    }

    // Update status
    @PutMapping("/{userStoryId}/status")
    public ResponseEntity<ApiResponse<UserStoryResponse>> updateStatus(
            @PathVariable String userStoryId,
            @RequestBody UserStoryStatusUpdateRequest request
    ) {
        return ResponseEntity.ok(
                ApiResponse.<UserStoryResponse>builder()
                        .message("User story status updated")
                        .result(userStoryService.updateStatus(userStoryId, request))
                        .build()
        );
    }

    // Delete user story
    @DeleteMapping("/{userStoryId}")
    public ResponseEntity<ApiResponse<Void>> delete(
            @PathVariable String userStoryId
    ) {
        userStoryService.delete(userStoryId);
        return ResponseEntity.ok(
                ApiResponse.<Void>builder()
                        .message("User story deleted")
                        .build()
        );
    }
}
