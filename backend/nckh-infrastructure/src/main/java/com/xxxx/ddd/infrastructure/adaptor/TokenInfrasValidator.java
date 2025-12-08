package com.xxxx.ddd.infrastructure.adaptor;

import com.nimbusds.jose.JOSEException;
import com.xxxx.ddd.application.model.dto.request.IntrospectRequest;
import com.xxxx.ddd.application.port.TokenValidator;
import com.xxxx.ddd.application.service.authentication.impl.AuthenticationAppServiceImpl;
import org.springframework.stereotype.Component;

import java.text.ParseException;
@Component
public class TokenInfrasValidator implements TokenValidator {

    private final AuthenticationAppServiceImpl authenticationAppService;

    public TokenInfrasValidator(AuthenticationAppServiceImpl authenticationAppService) {
        this.authenticationAppService = authenticationAppService;
    }

    @Override
    public boolean isValid(String token) throws JOSEException, ParseException {
        var response = authenticationAppService.introspect(IntrospectRequest.builder()
                .token(token)
                .build());
        return response.isValid();
    }
}
