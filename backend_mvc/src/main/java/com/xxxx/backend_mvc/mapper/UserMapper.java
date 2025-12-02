package com.xxxx.backend_mvc.mapper;

import com.xxxx.backend_mvc.dto.request.UserCreationRequest;
import com.xxxx.backend_mvc.dto.request.UserUpdateRequest;
import com.xxxx.backend_mvc.dto.response.UserResponse;
import com.xxxx.backend_mvc.entity.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

@Mapper(componentModel = "spring")
public interface UserMapper {
    User toUser(UserCreationRequest request);

    UserResponse toUserResponse(User user);

    @Mapping(target = "roles", ignore = true)
    void updateUser(@MappingTarget User user, UserUpdateRequest request);
}