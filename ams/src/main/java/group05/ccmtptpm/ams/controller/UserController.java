package group05.ccmtptpm.ams.controller;

import group05.ccmtptpm.ams.dto.ApiResponse;
import group05.ccmtptpm.ams.dto.AssetUsageRequest;
import group05.ccmtptpm.ams.dto.AssetUsageResponse;
import group05.ccmtptpm.ams.entity.User;
import group05.ccmtptpm.ams.service.IAssetUsageService;
import group05.ccmtptpm.ams.service.IUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;




@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final IUserService userService;
    private final IAssetUsageService assetUsageService;

    @PostMapping
    public ApiResponse<User> createUser(@RequestBody User user) {
        User savedUser = userService.createUser(user);

        return ApiResponse.<User>builder()
                .success(true)
                .message("User created")
                .data(savedUser)
                .build();
    }

    // TODO: register to use asset request system
    @PostMapping("/asset-usage")
    public ApiResponse<AssetUsageResponse> createAssetUsage(@RequestBody AssetUsageRequest request) {
        // TODO: Implement asset usage creation logic
        AssetUsageResponse response = assetUsageService.requestAssetUsage(request);
        return ApiResponse.<AssetUsageResponse>builder()
                .success(true)
                .message("Asset usage created")
                .data(response)
                .build();
    }
    //TODO: return asset usage
    @PutMapping("/asset-usage/{id}/return")
    public ApiResponse<AssetUsageResponse> returnAsset(@PathVariable Long id) {
        assetUsageService.returnAsset(id);
        return ApiResponse.<AssetUsageResponse>builder()
                .success(true)
                .message("Asset returned")
                .build();
    }
}