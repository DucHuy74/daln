package com.xxxx.ddd.controller.http;

import com.xxxx.ddd.application.model.dto.request.RoleRequest;
import com.xxxx.ddd.application.model.dto.response.RoleResponse;
import com.xxxx.ddd.application.service.role.impl.RoleAppServiceImpl;
import com.xxxx.ddd.common.dto.ApiResponse;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/roles")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class RoleController {
    RoleAppServiceImpl roleAppService;

    @PostMapping
    ApiResponse<RoleResponse> create(@RequestBody RoleRequest request){
        return ApiResponse.<RoleResponse>builder()
                .result(roleAppService.create(request))
                .build();
    }

    @GetMapping
    ApiResponse<List<RoleResponse>> getAll(){
        return ApiResponse.<List<RoleResponse>>builder()
                .result(roleAppService.getAll())
                .build();
    }

    @DeleteMapping("/{role}")
    ApiResponse<Void> delete(@PathVariable String role){
        roleAppService.delete(role);
        return ApiResponse.<Void>builder().build();
    }

}