package com.xxxx.ddd.application.port;

import com.nimbusds.jose.JOSEException;

import java.text.ParseException;

public interface  TokenValidator {
    boolean isValid(String token) throws JOSEException, ParseException;
}
