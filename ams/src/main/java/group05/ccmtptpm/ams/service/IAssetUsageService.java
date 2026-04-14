package group05.ccmtptpm.ams.service;



import org.springframework.data.domain.Page;

import group05.ccmtptpm.ams.dto.AssetUsageRequest;
import group05.ccmtptpm.ams.dto.AssetUsageResponse;


public interface IAssetUsageService {
    AssetUsageResponse requestAssetUsage(AssetUsageRequest request);
    void approve(Long id);
    void reject(Long id);
    void returnAsset(Long id);

    Page<AssetUsageResponse> getAllAssetUsages(int page, int size);
    Page<AssetUsageResponse> getCurrentUserAssetUsages(int page, int size);
}
