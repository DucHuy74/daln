package com.xxxx.ddd.application.service.authentication;

import com.nimbusds.jose.JOSEException;
import com.xxxx.ddd.application.model.dto.request.AuthenticationRequest;
import com.xxxx.ddd.application.model.dto.request.IntrospectRequest;
import com.xxxx.ddd.application.model.dto.request.LogoutRequest;
import com.xxxx.ddd.application.model.dto.request.RefreshRequest;
import com.xxxx.ddd.application.model.dto.response.AuthenticationResponse;
import com.xxxx.ddd.application.model.dto.response.IntrospectResponse;

import java.text.ParseException;

public interface AuthenticationAppService {
    IntrospectResponse introspect(IntrospectRequest request) throws JOSEException, ParseException;

    AuthenticationResponse authenticate(AuthenticationRequest request);

    void logout(LogoutRequest request) throws ParseException, JOSEException;

    AuthenticationResponse refreshToken(RefreshRequest request) throws ParseException, JOSEException;
}
