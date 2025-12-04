package com.xxxx.backend_mvc.configuration;

import com.xxxx.backend_mvc.entity.ApiKey;
import com.xxxx.backend_mvc.repository.ApiKeyRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;


@Component
public class ApiKeyInitializer implements CommandLineRunner {
    private final ApiKeyRepository apiKeyRepository;

    public ApiKeyInitializer(ApiKeyRepository apiKeyRepository) {
        this.apiKeyRepository = apiKeyRepository;
    }

    @Override
    public void run(String... args){
        if(apiKeyRepository.count() == 0){
            ApiKey key = ApiKey.builder()
                    .status(true)
                    .expiryDate(null)
                    .build();

            ApiKey savedKey = apiKeyRepository.save(key);
            System.out.println("Api key: " + savedKey.getApiKey());
        }
    }
}
