package com.xxxx.ddd.infrastructure.graphql.messaging;

import com.xxxx.dddd.domain.event.UserStoryMovedMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.neo4j.core.Neo4jClient;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class UserStoryGraphMoveService {

    private final Neo4jClient neo4jClient;

    public void applyMove(UserStoryMovedMessage message) {

        log.info(
                "Updating graph scope for story {} (sprint={}, backlog={})",
                message.getId(),
                message.getSprintId(),
                message.getBacklogId()
        );

        neo4jClient.query("""
                MATCH ()-[r:PERFORM|TARGET]->()
                WHERE r.story_id = $storyId
                SET r.sprint_id = $sprintId,
                    r.backlog_id = $backlogId
                """)
                .bindAll(Map.of(
                        "storyId", message.getId(),
                        "sprintId", message.getSprintId(),
                        "backlogId", message.getBacklogId()
                ))
                .run();
    }
}
