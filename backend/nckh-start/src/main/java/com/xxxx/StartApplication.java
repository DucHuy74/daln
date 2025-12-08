package com.xxxx;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
// Scan toàn bộ beans (Service, Controller, Repository thường, v.v.) dưới com.xxxx.*
@ComponentScan(basePackages = "com.xxxx")
// Scan Spring Data JPA repositories (UserJPAMapper, InvalidatedTokenJPAMapper, ...)
@EnableJpaRepositories(basePackages = "com.xxxx.ddd.infrastructure.persistence.mapper")
// Scan JPA entities
@EntityScan(basePackages = "com.xxxx.ddd.domain.model.entity")
public class StartApplication {
    public static void main(String[] args) {
        SpringApplication.run(StartApplication.class, args);
    }

    @Bean
    public RestTemplate restTemplate(){
        return new RestTemplate();
    }
}