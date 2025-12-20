package com.xxxx.backend_mvc.mapper;

import com.xxxx.backend_mvc.dto.request.RegistrationRequest;
import com.xxxx.backend_mvc.dto.response.ProfileResponse;
import com.xxxx.backend_mvc.entity.Profile;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface ProfileMapper {
    Profile toProfile(RegistrationRequest request);

    ProfileResponse toProfileResponse(Profile profile);
}
