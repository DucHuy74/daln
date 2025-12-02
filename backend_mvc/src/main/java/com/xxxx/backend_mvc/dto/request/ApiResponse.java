package com.xxxx.backend_mvc.dto.request;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
@JsonInclude(JsonInclude.Include.NON_NULL) //khai bao cho json khi -> api, field nao null se ko kem vao trong json
public class ApiResponse <T> {
    @Builder.Default
    private int code = 1000;
    private String message;
    private T result;
}