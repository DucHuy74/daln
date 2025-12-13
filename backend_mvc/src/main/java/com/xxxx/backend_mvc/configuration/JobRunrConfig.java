package com.xxxx.backend_mvc.configuration;

import lombok.RequiredArgsConstructor;
import org.jobrunr.configuration.JobRunr;
import org.jobrunr.scheduling.JobScheduler;
import org.jobrunr.server.JobActivator;
import org.jobrunr.storage.StorageProvider;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

@Configuration
@RequiredArgsConstructor
public class JobRunrConfig {

    private final ApplicationContext applicationContext;

    // Storage cho JobRunr
    @Bean
    public StorageProvider storageProvider(DataSource dataSource) {
        return new org.jobrunr.storage.sql.mysql.MySqlStorageProvider(dataSource);
    }

    // JobActivator dùng Spring ApplicationContext để inject Bean
    @Bean
    public JobActivator jobActivator() {
        return applicationContext::getBean;
    }

    // Scheduler chính
    @Bean
    public JobScheduler jobScheduler(StorageProvider storageProvider, JobActivator jobActivator) {
        return JobRunr.configure()
                .useStorageProvider(storageProvider)
                .useJobActivator(jobActivator)
                .useBackgroundJobServer()       // Bật BackgroundJobServer
                .useDashboard(8000)            // Dashboard: http://localhost:8000
                .initialize()
                .getJobScheduler();
    }
}
