package com.xxxx.backend_mvc.service;

import com.xxxx.backend_mvc.dto.request.UserCreationRequest;
import com.xxxx.backend_mvc.dto.request.UserUpdateRequest;
import com.xxxx.backend_mvc.dto.response.UserResponse;
import com.xxxx.backend_mvc.entity.User;
import com.xxxx.backend_mvc.enums.Role;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.mapper.UserMapper;
import com.xxxx.backend_mvc.repository.RoleRepository;
import com.xxxx.backend_mvc.repository.UserRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;

@Service
@RequiredArgsConstructor //define cac cai bien la final
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true) // bat cu field nao duoi day neu ko khai bao j het-> tu dong dua vao field private final
@Slf4j
public class UserService {
    UserRepository userRepository;
    RoleRepository roleRepository;
    UserMapper userMapper;
    PasswordEncoder passwordEncoder;

    public UserResponse createUser(UserCreationRequest request){
        if (userRepository.existsByUsername(request.getUsername()))
            throw new AppException(ErrorCode.USER_EXISTED);

        User user = userMapper.toUser(request);
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        HashSet<String> roles = new HashSet<>();
        roles.add(Role.USER.name());

        // user.setRoles(roles);

        return userMapper.toUserResponse(userRepository.save(user));
    }


    public UserResponse getMyInfo(){
        var context = SecurityContextHolder.getContext();
        String name = context.getAuthentication().getName();

        User user = userRepository.findByUsername(name).orElseThrow(
                () -> new AppException(ErrorCode.USER_NOT_EXISTED));

        return userMapper.toUserResponse(user);
    }

    public UserResponse updateUser(String userId, UserUpdateRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));

        userMapper.updateUser(user, request);
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        var roles = roleRepository.findAllById(request.getRoles());
        user.setRoles(new HashSet<>(roles));

        return userMapper.toUserResponse(userRepository.save(user));
    }


    public void deleteUser(String userId){
        userRepository.deleteById(userId);
    }

    //@PreAuthorize("hasRole('ADMIN')") //kiem tra trc khi vao method
    @PreAuthorize("hasRole('ADMIN')")
    public List<UserResponse> getUsers(){
        log.info("In method get Users");
        return userRepository.findAll().stream()
                .map(userMapper::toUserResponse).toList();
    }

    @PostAuthorize("returnObject.username == authentication.name") //kiem tra sau khi method thuc hien xong
    public UserResponse getUser(String id){
        log.info("In method get user by Id");
        return userMapper.toUserResponse(userRepository.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED)));
    }
}