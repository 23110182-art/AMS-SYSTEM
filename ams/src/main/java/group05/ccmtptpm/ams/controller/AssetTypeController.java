package group05.ccmtptpm.ams.controller;

import group05.ccmtptpm.ams.dto.ApiResponse;
import group05.ccmtptpm.ams.dto.AssetTypeResponse;
import group05.ccmtptpm.ams.service.IAssetTypeService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/assetType")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('USER', 'ADMIN')")
public class AssetTypeController {

    private final IAssetTypeService assetTypeService;

    @GetMapping("/getAll")
    public ApiResponse<Page<AssetTypeResponse>> getAllAssetTypes(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        return ApiResponse.<Page<AssetTypeResponse>>builder()
                .success(true)
                .message("Get all asset types success")
                .data(assetTypeService.getAllAssetTypes(page, size))
                .build();
    }

    @GetMapping("/get/{id}")
    public ApiResponse<AssetTypeResponse> getAssetTypeById(@PathVariable Long id) {
        return ApiResponse.<AssetTypeResponse>builder()
                .success(true)
                .message("Get asset type by id success")
                .data(assetTypeService.getAssetTypeById(id))
                .build();
    }
}
