package com.xxxx.backend_mvc.controller;

import com.xxxx.backend_mvc.service.InvitationService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@Slf4j
@RestController
@RequestMapping("/invitations")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class InvitationController {
    InvitationService invitationService;

    @GetMapping("/accept")
    public ResponseEntity<String> accept(@RequestParam String token) {
        invitationService.accept(token);
        return ResponseEntity.ok("Invitation accepted successfully");
    }

    @GetMapping("/deny")
    public ResponseEntity<String> deny(@RequestParam String token) {
        invitationService.deny(token);
        return ResponseEntity.ok("Invitation denied");
    }
}
