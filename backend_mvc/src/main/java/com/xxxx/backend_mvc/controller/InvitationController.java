package com.xxxx.backend_mvc.controller;

import com.xxxx.backend_mvc.dto.response.InvitationResponse;
import com.xxxx.backend_mvc.service.InvitationService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/invitations")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class InvitationController {

    InvitationService invitationService;

    @PostMapping("/{invitationId}/accept")
    public ResponseEntity<Void> accept(@PathVariable String invitationId) {

        String userId = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        invitationService.accept(invitationId, userId);

        return ResponseEntity.ok().build();
    }

    @PostMapping("/{invitationId}/deny")
    public ResponseEntity<Void> deny(@PathVariable String invitationId) {

        String userId = SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getName();

        invitationService.deny(invitationId, userId);

        return ResponseEntity.ok().build();
    }

    @GetMapping("/pending")
    public ResponseEntity<List<InvitationResponse>> myPendingInvitations() {

        var auth = SecurityContextHolder.getContext().getAuthentication();
        String userId = ((JwtAuthenticationToken) auth).getToken().getSubject();

        return ResponseEntity.ok(
                invitationService.getMyPendingInvitations(userId)
        );
    }

}
