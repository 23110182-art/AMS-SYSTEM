package group05.ccmtptpm.ams.controller;

import group05.ccmtptpm.ams.dto.ApiResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<String> adminOnly() {
        return ApiResponse.<String>builder()
                .success(true)
                .message("OK")
                .data("Hello Admin")
                .build();
    }
}