package group05.ccmtptpm.ams.controller;

// import group05.ccmtptpm.ams.dto.AddAssetRequest;
import group05.ccmtptpm.ams.dto.ApiResponse;
// import group05.ccmtptpm.ams.dto.AssetRequest;
// import group05.ccmtptpm.ams.dto.AssetResponse;
import group05.ccmtptpm.ams.dto.AssetTypeRequest;
import group05.ccmtptpm.ams.dto.AssetTypeResponse;
// import group05.ccmtptpm.ams.service.IAssetService;
import group05.ccmtptpm.ams.service.IAssetTypeService;

import lombok.RequiredArgsConstructor;

// import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;


@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final IAssetTypeService assetTypeService;
//     private final IAssetService assetService;
    

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<String> adminOnly() {
        return ApiResponse.<String>builder()
                .success(true)
                .message("OK")
                .data("Hello Admin")
                .build();
    }

    @GetMapping("/assetType/getAll")
    public ApiResponse<?> getAllAssetTypes(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        return ApiResponse.builder()
                .success(true)
                .message("Get all asset types success")
                .data(assetTypeService.getAllAssetTypes(page, size))
                .build();
    }

    @GetMapping("/assetType/get/{id}")
    public ApiResponse<AssetTypeResponse> getAssetTypeById(
            @PathVariable Long id) {

        return ApiResponse.<AssetTypeResponse>builder()
                .success(true)
                .message("Get asset type by id success")
                .data(assetTypeService.getAssetTypeById(id))
                .build();
    }
    
    @PostMapping("/assetType/add")
    public ApiResponse<AssetTypeResponse> addAssetType(
            @RequestBody AssetTypeRequest request) {

        AssetTypeResponse assetTypeResponse = assetTypeService.createAssetType(request.getName());

        return ApiResponse.<AssetTypeResponse>builder()
                .success(true)
                .message("Add asset type success")
                .data(assetTypeResponse)
                .build();
    }

    @PutMapping("/assetType/update/{id}")
    public ApiResponse<AssetTypeResponse> updateAssetType(
            @PathVariable Long id,
            @RequestBody AssetTypeRequest request) {

        return ApiResponse.<AssetTypeResponse>builder()
                .success(true)
                .message("Update asset type success")
                .data(assetTypeService.updateAssetType(id, request.getName()))
                .build();
    }

    @DeleteMapping("/assetType/delete/{id}")
    public ApiResponse<?> deleteAssetType(
            @PathVariable Long id) {

        return ApiResponse.builder()
                .success(true)
                .message("Delete asset type success")
                .data(assetTypeService.deleteAssetType(id))
                .build();
    }


    // asset management
//     @GetMapping("/asset/getAll")
//     public ApiResponse<?> getAllAssets(
//             @RequestParam(defaultValue = "0") int page,
//             @RequestParam(defaultValue = "10") int size) {

//         return ApiResponse.builder()
//                 .success(true)
//                 .message("Get all assets success")
//                 .data(assetService.getAllAssets(page, size))
//                 .build();
//     }

//     @GetMapping("/asset/get/{id}")
//     public ApiResponse<AssetResponse> getAssetById(@PathVariable Long id) {
//         return ApiResponse.<AssetResponse>builder()
//                 .success(true)
//                 .message("Get asset by id success")
//                 .data(assetService.getAssetById(id))
//                 .build();
//     }
    

//     @PostMapping("/asset/add")
//     public ApiResponse<AssetResponse> addAsset(@RequestBody AddAssetRequest request) {
//         List<AssetResponse> assetResponses = assetService.addAsset(request);
//         return ApiResponse.<AssetResponse>builder()
//                 .success(true)
//                 .message(assetResponses.size() + " assets added successfully")
//                 .data(assetResponses.get(0)) // Return the first added asset response
//                 .build();
//     }

//     @PutMapping("/asset/update/{id}")
//     public ApiResponse<AssetResponse> updateAsset(
//             @PathVariable Long id,
//             @RequestBody AssetRequest request) {

//         return ApiResponse.<AssetResponse>builder()
//                 .success(true)
//                 .message("Update asset success")
//                 .data(assetService.updateAsset(id, request))
//                 .build();
//     }

//     @DeleteMapping("/asset/delete/{id}")
//     public ApiResponse<?> deleteAsset(
//             @PathVariable Long id) {

//         return ApiResponse.builder()
//                 .success(true)
//                 .message("Delete asset success")
//                 .data(assetService.deleteAsset(id))
//                 .build();
//     }

}