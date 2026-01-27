package com.xxxx.backend_mvc.graph.listener;

public record UserStoryCreatedEvent(
        String id,
        String storyText,
        String sprintId
) {}
