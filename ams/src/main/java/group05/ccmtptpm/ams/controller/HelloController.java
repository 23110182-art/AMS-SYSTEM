package group05.ccmtptpm.ams.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import group05.ccmtptpm.ams.dto.ApiResponse;

@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public ApiResponse<String> hello() {
        return ApiResponse.<String>builder()
                .success(true)
                .message("OK")
                .data("Hello Protected AMS")
                .build();
    }
}