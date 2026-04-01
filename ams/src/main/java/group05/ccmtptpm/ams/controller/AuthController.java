package group05.ccmtptpm.ams.controller;

import group05.ccmtptpm.ams.dto.*;
import group05.ccmtptpm.ams.service.IUserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final IUserService userService;

    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(
            @RequestBody @Valid LoginRequest request) {

        LoginResponse response = userService.login(request);

        return ApiResponse.<LoginResponse>builder()
                .success(true)
                .message("Login success")
                .data(response)
                .build();
    }

    @PostMapping("/register")
    public ApiResponse<UserResponse> register(
            @RequestBody @Valid RegisterRequest request) {

        UserResponse response = userService.register(request);

        return ApiResponse.<UserResponse>builder()
                .success(true)
                .message("Register success")
                .data(response)
                .build();
    }
}