package com.xxxx.backend_mvc.mapper;

import com.xxxx.backend_mvc.dto.request.SprintCreateRequest;
import com.xxxx.backend_mvc.dto.response.SprintResponse;
import com.xxxx.backend_mvc.entity.Sprint;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface SprintMapper {
    Sprint toEntity(SprintCreateRequest request);

    SprintResponse toResponse(Sprint sprint);

    List<SprintResponse> toResponses(List<Sprint> sprints);
}
