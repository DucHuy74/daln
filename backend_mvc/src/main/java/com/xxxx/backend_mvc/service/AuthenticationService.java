package com.xxxx.backend_mvc.service;

import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import com.xxxx.backend_mvc.dto.request.AuthenticationRequest;
import com.xxxx.backend_mvc.dto.request.IntrospectRequest;
import com.xxxx.backend_mvc.dto.request.LogoutRequest;
import com.xxxx.backend_mvc.dto.request.RefreshRequest;
import com.xxxx.backend_mvc.dto.response.AuthenticationResponse;
import com.xxxx.backend_mvc.dto.response.IntrospectResponse;
import com.xxxx.backend_mvc.entity.InvalidatedToken;
import com.xxxx.backend_mvc.entity.User;
import com.xxxx.backend_mvc.exception.AppException;
import com.xxxx.backend_mvc.exception.ErrorCode;
import com.xxxx.backend_mvc.repository.InvalidatedTokenRepository;
import com.xxxx.backend_mvc.repository.UserRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.text.ParseException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.StringJoiner;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Slf4j
@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AuthenticationService {
    UserRepository userRepository;
    InvalidatedTokenRepository invalidatedTokenRepository;
    RedisTemplate<String, Object> redisTemplate;

    @NonFinal
    @Value("${jwt.signerKey}")
    protected String SIGNER_KEY;

    @NonFinal
    @Value("${jwt.valid-duration}")
    protected long VALID_DURATION;

    @NonFinal
    @Value("${jwt.refreshable-duration}")
    protected long REFRESHABLE_DURATION;

    //introspect parse token = SignedJWT.parse(token), verify token = MACVerifier,
    public IntrospectResponse introspect(IntrospectRequest request)
            throws JOSEException, ParseException {
        var token = request.getToken();
        boolean isValid = true;

        try {
            verifyToken(token, false);
        } catch (AppException e) {
            isValid = false;
        }

        return IntrospectResponse.builder().valid(isValid).build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest request){
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        var user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_EXISTED));


        boolean authenticated =  passwordEncoder.matches(request.getPassword(),
                user.getPassword());
        if(!authenticated){
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }
        var token = generateToken(user);

        return AuthenticationResponse.builder()
                .token(token)
                .authenticated(true)
                .build();
    }

    public void logout(LogoutRequest request) throws ParseException, JOSEException {
        var signToken = verifyToken(request.getToken(), false);

        String jit = signToken.getJWTClaimsSet().getJWTID();
        Date expiryTime = signToken.getJWTClaimsSet().getExpirationTime();

        // Tính TTL để Redis tự xoá key khi token hết hạn
        long ttl = expiryTime.getTime() - System.currentTimeMillis();
        if (ttl < 0) ttl = 0;

        //jit: id token, redis giu key dung ttl = time token con han, khi ttl het-> redis xoa
        //opsForValuer: lưu hoặc đọc dữ liệu kiểu String trong Redis.
        //Luu vao black list
        redisTemplate.opsForValue().set(jit, "logout", ttl, TimeUnit.MILLISECONDS);

//        InvalidatedToken invalidatedToken = InvalidatedToken.builder()
//                .id(jit)
//                .expiryTime(expiryTime)
//                .build();
//
//        invalidatedTokenRepository.save(invalidatedToken);
    }

    public AuthenticationResponse refreshToken(RefreshRequest request)
            throws ParseException, JOSEException {
        var signedJWT = verifyToken(request.getToken(), true);

        var jit = signedJWT.getJWTClaimsSet().getJWTID();
        var expiryTime = signedJWT.getJWTClaimsSet().getExpirationTime();
        //token cũ bị revoke, token mới phát ra, tất cả token bị revoke lưu trong Redis.
        long ttl = expiryTime.getTime() - System.currentTimeMillis();
        redisTemplate.opsForValue().set(jit, "invalid", ttl, TimeUnit.MILLISECONDS);


//        InvalidatedToken invalidatedToken = InvalidatedToken.builder()
//                .id(jit)
//                .expiryTime(expiryTime)
//                .build();
//
//        invalidatedTokenRepository.save(invalidatedToken);

        String userId = signedJWT.getJWTClaimsSet().getSubject();

        var user = userRepository.findById(userId).orElseThrow(
                () -> new AppException(ErrorCode.UNAUTHENTICATED)
        );

        var token = generateToken(user);

        return AuthenticationResponse.builder()
                .token(token)
                .authenticated(true)
                .build();
    }

    //tao token = lib nimbus
    // header & payload
    String generateToken(User user){
        // dung thuat toan HS512 (HMAC with SHA-512)
        //JWT chia lam 3 phan: Header, Payload, Signature
        // Signature = HMAC-SHA512(header + "." + payload, secret key)
        JWSHeader header = new JWSHeader(JWSAlgorithm.HS512);

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .subject(user.getId())
                .claim("username", user.getUsername())
                .issuer("duchuy")// xac dinh token dc issue tu ai
                .issueTime(new Date())
                .expirationTime(new Date(
                        Instant.now().plus(1, ChronoUnit.HOURS).toEpochMilli() //het han sau 1h
                ))//xac dinh thoi han
                .jwtID(UUID.randomUUID().toString())
                .claim("scope", buildScope(user))
                .build();

        Payload payload = new Payload(jwtClaimsSet.toJSONObject());

        JWSObject  jwsObject = new JWSObject(header,payload);

        //ky token
        //MACSigner can 1 cai secretkey (1 chuoi 32bytes)
        // co the len https://generate-random.org/encryption-key-generator de gen ra
        try {
            jwsObject.sign(new MACSigner(SIGNER_KEY.getBytes()));
            return jwsObject.serialize();
        } catch (JOSEException e) {
            log.error("cannot create token", e);
            throw new RuntimeException(e);
        }
    }

    private SignedJWT verifyToken(String token, boolean isRefresh) throws JOSEException, ParseException {
        JWSVerifier verifier = new MACVerifier(SIGNER_KEY.getBytes());

        SignedJWT signedJWT = SignedJWT.parse(token);

        Date expiryTime = (isRefresh)
                ? new Date(signedJWT
                .getJWTClaimsSet()
                .getIssueTime()
                .toInstant()
                .plus(REFRESHABLE_DURATION, ChronoUnit.SECONDS)
                .toEpochMilli())
                : signedJWT.getJWTClaimsSet().getExpirationTime();

        var verified = signedJWT.verify(verifier);

        if (!(verified && expiryTime.after(new Date())))
            throw new AppException(ErrorCode.UNAUTHENTICATED);

//        if (invalidatedTokenRepository
//                .existsById(signedJWT.getJWTClaimsSet().getJWTID()))
//            throw new AppException(ErrorCode.UNAUTHENTICATED);

        //Nếu logout rồi → token dù còn hạn cũng không dùng được
        String jit = signedJWT.getJWTClaimsSet().getJWTID();
        Object redisValue = redisTemplate.opsForValue().get(jit);
        if (redisValue != null) {
            throw new AppException(ErrorCode.UNAUTHENTICATED);
        }

        return signedJWT;
    }

    String buildScope(User user){
        StringJoiner stringJoiner = new StringJoiner(" ");

        if (!CollectionUtils.isEmpty(user.getRoles()))
            user.getRoles().forEach(role -> {
                stringJoiner.add("ROLE_" + role.getName());
                if(!CollectionUtils.isEmpty(role.getPermissions())){
                    role.getPermissions()
                            .forEach(permission -> stringJoiner.add(permission.getName()));
                }

            });

        return stringJoiner.toString();
    }
}