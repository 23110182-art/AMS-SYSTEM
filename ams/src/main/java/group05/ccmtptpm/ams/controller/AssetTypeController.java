package group05.ccmtptpm.ams.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import group05.ccmtptpm.ams.dto.ApiResponse;
import group05.ccmtptpm.ams.service.IAssetTypeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/assetType")
@RequiredArgsConstructor
public class AssetTypeController {

    private final IAssetTypeService assetTypeService;

    @GetMapping("/getAll")
    public ApiResponse<?> getAllAssetTypes(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        return ApiResponse.builder()
                .success(true)
                .message("Get all asset types success")
                .data(assetTypeService.getAllAssetTypes(page, size))
                .build();
    }
    
}
