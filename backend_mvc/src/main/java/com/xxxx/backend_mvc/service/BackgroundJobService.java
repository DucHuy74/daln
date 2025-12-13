package com.xxxx.backend_mvc.service;

import lombok.RequiredArgsConstructor;
import org.jobrunr.scheduling.JobScheduler;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class BackgroundJobService {

    private final JobScheduler jobScheduler;
    private final EmailService emailService;

    public void sendInviteEmailAsync(
            String to,
            String workspaceName,
            String inviterName,
            String invitationId
    ) {
        jobScheduler.enqueue(() ->
                emailService.sendInviteEmail(to, workspaceName, inviterName, invitationId)
        );
    }
}
