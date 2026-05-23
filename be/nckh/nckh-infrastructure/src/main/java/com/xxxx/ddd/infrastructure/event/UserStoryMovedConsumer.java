package com.xxxx.ddd.infrastructure.event;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.xxxx.ddd.infrastructure.config.rmq.RabbitConfig;
import com.xxxx.ddd.infrastructure.graphql.messaging.UserStoryGraphMoveService;
import com.xxxx.dddd.domain.event.BaseEventMessage;
import com.xxxx.dddd.domain.event.UserStoryMovedMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class UserStoryMovedConsumer {

    private final ObjectMapper objectMapper;
    private final UserStoryGraphMoveService graphMoveService;

    @RabbitListener(queues = RabbitConfig.MOVED_QUEUE)
    public void handle(BaseEventMessage<?> message) {

        if (message == null || message.getPayload() == null) {
            log.warn("Received empty USER_STORY_MOVED message");
            return;
        }

        UserStoryMovedMessage payload = objectMapper.convertValue(
                message.getPayload(),
                UserStoryMovedMessage.class
        );

        graphMoveService.applyMove(payload);
    }
}
