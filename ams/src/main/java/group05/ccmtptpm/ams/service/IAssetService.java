package group05.ccmtptpm.ams.service;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;

import group05.ccmtptpm.ams.dto.AddAssetRequest;
import group05.ccmtptpm.ams.dto.AssetRequest;
import group05.ccmtptpm.ams.dto.AssetResponse;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;

public interface IAssetService {

    Page<AssetResponse> getAllAssets(int page, int size);

    AssetResponse getAssetById(Long id);
    
    List<AssetResponse> addAsset(AddAssetRequest request);

    AssetResponse updateAsset(Long id, AssetRequest request);

    boolean deleteAsset(Long id);

    Long countAssetsByStatusOrAll(EnumAssetStatus status);

    Long countAssetByType(String assetTypeName);

    Map<String, Long> assetStatisticByAssetType();
}
