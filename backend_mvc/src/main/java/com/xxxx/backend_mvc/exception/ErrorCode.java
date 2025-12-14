package com.xxxx.backend_mvc.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;

@Getter
public enum ErrorCode {
    UNCATEGORIZED_EXCEPTION(9999, "Uncategorized error", HttpStatus.INTERNAL_SERVER_ERROR),
    INVALID_KEY(1001, "Uncategorized error", HttpStatus.BAD_REQUEST),
    USER_EXISTED(1002, "User existed", HttpStatus.BAD_REQUEST),
    USERNAME_INVALID(1003, "Username must be at least {min} characters", HttpStatus.BAD_REQUEST),
    INVALID_PASSWORD(1004, "Password must be at least {min} characters", HttpStatus.BAD_REQUEST),
    USER_NOT_EXISTED(1005, "User not existed", HttpStatus.NOT_FOUND),
    UNAUTHENTICATED(1006, "Unauthenticated", HttpStatus.UNAUTHORIZED),
    UNAUTHORIZED(1007, "You do not have permission", HttpStatus.FORBIDDEN),
    INVALID_DOB(1008, "Your age must be at least {min}", HttpStatus.BAD_REQUEST),
    WORKSPACE_NOT_FOUND(1009, "Workspace not found", HttpStatus.NOT_FOUND),
    NOT_ADMIN_OF_WORKSPACE(1010, "You are not admin of this workspace", HttpStatus.FORBIDDEN),
    NO_PERMISSION(1011, "You do not have permission", HttpStatus.FORBIDDEN),
    MEMBER_EXISTED(1012, "Member existed", HttpStatus.BAD_REQUEST),
    INVALID_INVITE(1013, "Invalid invite code", HttpStatus.BAD_REQUEST),
    INVITE_USED(1014, "Invite code has been used", HttpStatus.BAD_REQUEST),
    INVITE_EXPIRED(1015, "Invite code has expired", HttpStatus.BAD_REQUEST),
    INVITATION_ALREADY_SENT(1016, "Invitation already sent", HttpStatus.BAD_REQUEST)
    ;

    ErrorCode(int code, String message, HttpStatusCode statusCode) {
        this.code = code;
        this.message = message;
        this.statusCode = statusCode;
    }

    private int code;
    private String message;
    private HttpStatusCode statusCode;
}
