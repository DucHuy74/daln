package com.xxxx.ddd.application.service.user;

import com.xxxx.ddd.application.model.dto.request.UserCreationRequest;
import com.xxxx.ddd.application.model.dto.request.UserUpdateRequest;
import com.xxxx.ddd.application.model.dto.response.UserResponse;

import java.util.List;

public interface UserAppService {

    UserResponse createUser(UserCreationRequest request);

    UserResponse getMyInfo();

    UserResponse updateUser(String userId, UserUpdateRequest request);

    void deleteUser(String userId);

    List<UserResponse> getUsers();

    UserResponse getUser(String id);
}
