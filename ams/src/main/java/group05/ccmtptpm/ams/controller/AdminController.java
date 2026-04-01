package group05.ccmtptpm.ams.controller;

import group05.ccmtptpm.ams.dto.AddAssetRequest;
import group05.ccmtptpm.ams.dto.ApiResponse;
import group05.ccmtptpm.ams.dto.AssetRequest;
import group05.ccmtptpm.ams.dto.AssetResponse;
import group05.ccmtptpm.ams.dto.AssetTypeRequest;
import group05.ccmtptpm.ams.dto.AssetTypeResponse;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import group05.ccmtptpm.ams.service.IAssetService;
import group05.ccmtptpm.ams.service.IAssetTypeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.Map;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;



@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final IAssetTypeService assetTypeService;
    private final IAssetService assetService;
    

    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<String> adminOnly() {
        return ApiResponse.<String>builder()
                .success(true)
                .message("OK")
                .data("Hello Admin")
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
            @RequestBody @Valid AssetTypeRequest request) {

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

    @PostMapping("/asset/add")
    public ApiResponse<AssetResponse> addAsset(@RequestBody @Valid AddAssetRequest request) {
        List<AssetResponse> assetResponses = assetService.addAsset(request);
        return ApiResponse.<AssetResponse>builder()
                .success(true)
                .message(assetResponses.size() + " assets added successfully")
                .data(assetResponses.get(0)) // Return the first added asset response
                .build();
    }

    @PutMapping("/asset/update/{id}")
    public ApiResponse<AssetResponse> updateAsset(
            @PathVariable Long id,
            @RequestBody AssetRequest request) {

        return ApiResponse.<AssetResponse>builder()
                .success(true)
                .message("Update asset success")
                .data(assetService.updateAsset(id, request))
                .build();
    }

    @DeleteMapping("/asset/delete/{id}")
    public ApiResponse<?> deleteAsset(
            @PathVariable Long id) {

        return ApiResponse.builder()
                .success(true)
                .message("Delete asset success")
                .data(assetService.deleteAsset(id))
                .build();
    }

    // TODO: count assets by status or not
    @GetMapping("/asset/count")
    public ApiResponse<Long> countAssetsByStatusOrAll(@RequestParam(required = false) EnumAssetStatus status) {
        return ApiResponse.<Long>builder()
                .success(true)
                .message("Count assets by status " + status + " success")
                .data(assetService.countAssetsByStatusOrAll(status))
                .build();
    }

    //TODO: count assets by type
    @GetMapping("/asset/countByType")
    public ApiResponse<Long> countAssetsByType(@RequestParam String assetTypeName) {
        return ApiResponse.<Long>builder()
                .success(true)
                .message("Count assets by type " + assetTypeName + " success")
                .data(assetService.countAssetByType(assetTypeName))
                .build();
    }

    //TODO: asset statistic by asset type
    @GetMapping("/asset/statisticByType")
        public ApiResponse<Map<String, Long>> assetStatisticByAssetType() {
                return ApiResponse.<Map<String, Long>>builder()
                        .success(true)
                        .message("Asset statistic by asset type success")
                        .data(assetService.assetStatisticByAssetType())
                        .build();
        }

}