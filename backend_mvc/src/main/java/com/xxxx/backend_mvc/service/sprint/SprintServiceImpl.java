package com.xxxx.backend_mvc.service.sprint;

import com.xxxx.backend_mvc.dto.request.SprintCreateRequest;
import com.xxxx.backend_mvc.dto.response.SprintResponse;
import com.xxxx.backend_mvc.dto.response.UserStoryResponse;
import com.xxxx.backend_mvc.entity.Sprint;
import com.xxxx.backend_mvc.entity.UserStory;
import com.xxxx.backend_mvc.entity.workspace.Workspace;
import com.xxxx.backend_mvc.enums.SprintStatus;
import com.xxxx.backend_mvc.enums.UserStoryStatus;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.graph.listener.UserStoryCreatedEvent;
import com.xxxx.backend_mvc.mapper.SprintMapper;
import com.xxxx.backend_mvc.mapper.UserStoryMapper;
import com.xxxx.backend_mvc.repository.SprintRepository;
import com.xxxx.backend_mvc.repository.UserStoryRepository;
import com.xxxx.backend_mvc.repository.WorkspaceRepository;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.transaction.annotation.Transactional;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class SprintServiceImpl implements SprintService{
    WorkspaceRepository workspaceRepository;
    SprintRepository sprintRepository;
    UserStoryRepository userStoryRepository;
    SprintMapper sprintMapper;
    UserStoryMapper userStoryMapper;

    ApplicationEventPublisher publisher;

    //Create Sprint
    @Override
    @Transactional
    public SprintResponse createSprint(String workspaceId, SprintCreateRequest request) {

        Workspace workspace = workspaceRepository.findById(workspaceId)
                .orElseThrow(() -> new AppException(ErrorCode.WORKSPACE_NOT_FOUND));

        Sprint sprint = sprintMapper.toEntity(request);
        sprint.setWorkspace(workspace);
        sprint.setStatus(SprintStatus.ToDo);

        return sprintMapper.toResponse(sprintRepository.save(sprint));
    }

    //Get all sprints of workspace
    @Override
    @Transactional(readOnly = true)
    public List<SprintResponse> getSprints(String workspaceId) {

        return sprintMapper.toResponses(
                sprintRepository.findByWorkspace_IdOrderByCreatedAtDesc(workspaceId)
        );
    }

    //Start Sprint
    @Override
    @Transactional
    public void startSprint(String sprintId) {

        Sprint sprint = sprintRepository.findById(sprintId)
                .orElseThrow(() -> new AppException(ErrorCode.SPRINT_NOT_FOUND));

        if (sprint.getStatus() != SprintStatus.ToDo) {
            throw new AppException(ErrorCode.SPRINT_INVALID_STATE);
        }

        //1 workspace chỉ có 1 sprint ACTIVE
        boolean existsActiveSprint =
                sprintRepository.existsByWorkspace_IdAndStatus(
                        sprint.getWorkspace().getId(),
                        SprintStatus.InProgress
                );

        if (existsActiveSprint) {
            throw new AppException(ErrorCode.SPRINT_ALREADY_ACTIVE);
        }

        sprint.setStatus(SprintStatus.InProgress);

        List<UserStory> stories = userStoryRepository.findBySprint_Id(sprintId);
        for (UserStory story : stories) {
            publisher.publishEvent(
                    new UserStoryCreatedEvent(
                            story.getId(),
                            story.getStoryText(),
                            sprintId
                    )
            );
        }
    }

    //Complete Sprint
    @Override
    @Transactional
    public void completeSprint(String sprintId) {

        Sprint sprint = sprintRepository.findById(sprintId)
                .orElseThrow(() -> new AppException(ErrorCode.SPRINT_NOT_FOUND));

        if (sprint.getStatus() != SprintStatus.InProgress) {
            throw new AppException(ErrorCode.SPRINT_INVALID_STATE);
        }

        sprint.setStatus(SprintStatus.Done);

        //user story chưa done thì về backlog
        List<UserStory> stories = userStoryRepository.findBySprint_Id(sprintId);

        for (UserStory story : stories) {
            if (story.getStatus() != UserStoryStatus.Done) {
                story.setSprint(null); //về backlog
                story.setStatus(UserStoryStatus.ToDo);
            }
        }
    }

    // Add userstories to sprint
    @Override
    @Transactional
    public void addUserStoryToSprint(String sprintId, String userStoryId) {

        Sprint sprint = sprintRepository.findById(sprintId)
                .orElseThrow(() -> new AppException(ErrorCode.SPRINT_NOT_FOUND));

        UserStory story = userStoryRepository.findById(userStoryId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_STORY_NOT_FOUND));

        if (!story.getWorkspace().getId().equals(sprint.getWorkspace().getId())) {
            throw new AppException(ErrorCode.INVALID_WORKSPACE);
        }

        story.setSprint(sprint);
    }

    //Remove user story khỏi sprint (về backlog)
    @Override
    @Transactional
    public void removeUserStoryFromSprint(String userStoryId) {

        UserStory story = userStoryRepository.findById(userStoryId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_STORY_NOT_FOUND));

        story.setSprint(null);
    }

    //Get backlog (spr_id IS NULL)
    @Override
    @Transactional(readOnly = true)
    public List<UserStoryResponse> getBacklog(String workspaceId) {

        return userStoryMapper.toResponses(
                userStoryRepository.findByWorkspace_IdAndSprintIsNull(workspaceId)
        );
    }

    //Get user stories of sprint
    @Override
    @Transactional(readOnly = true)
    public List<UserStoryResponse> getUserStoriesOfSprint(String sprintId) {

        return userStoryMapper.toResponses(
                userStoryRepository.findBySprint_Id(sprintId)
        );
    }
}
