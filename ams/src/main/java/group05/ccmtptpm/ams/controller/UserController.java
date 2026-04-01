package group05.ccmtptpm.ams.controller;

import group05.ccmtptpm.ams.dto.ApiResponse;
import group05.ccmtptpm.ams.entity.User;
import group05.ccmtptpm.ams.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final IUserService userService;

    @PostMapping
    public ApiResponse<User> createUser(@RequestBody User user) {
        User savedUser = userService.createUser(user);

        return ApiResponse.<User>builder()
                .success(true)
                .message("User created")
                .data(savedUser)
                .build();
    }
    
}