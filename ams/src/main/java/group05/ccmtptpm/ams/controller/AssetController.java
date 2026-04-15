package group05.ccmtptpm.ams.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import group05.ccmtptpm.ams.dto.ApiResponse;
import group05.ccmtptpm.ams.dto.AssetResponse;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import group05.ccmtptpm.ams.service.IAssetService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;


@RestController
@RequestMapping("/api/asset")
@RequiredArgsConstructor
//@PreAuthorize("hasAnyRole('USER', 'ADMIN')")
public class AssetController {

    private final IAssetService assetService;

    @GetMapping("/getAll")
    public ApiResponse<?> getAllAssets(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String assetTypeName,
            @RequestParam(required = false) EnumAssetStatus status) {

        return ApiResponse.builder()
                .success(true)
                .message("Get all assets success")
                .data(assetService.getAllAssets(page, size, keyword, assetTypeName, status))
                .build();
    }

    @GetMapping("/get/{id}")
    public ApiResponse<AssetResponse> getAssetById(@PathVariable Long id) {
        return ApiResponse.<AssetResponse>builder()
                .success(true)
                .message("Get asset by id success")
                .data(assetService.getAssetById(id))
                .build();
    }
}
