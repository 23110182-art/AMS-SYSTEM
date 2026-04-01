package group05.ccmtptpm.ams.service.impl;

import java.util.Set;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import group05.ccmtptpm.ams.dto.AssetUsageRequest;
import group05.ccmtptpm.ams.dto.AssetUsageResponse;
import group05.ccmtptpm.ams.entity.Asset;
import group05.ccmtptpm.ams.entity.AssetUsage;
import group05.ccmtptpm.ams.entity.User;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import group05.ccmtptpm.ams.enums.EnumAssetUsageType;
import group05.ccmtptpm.ams.exception.CustomException;
import group05.ccmtptpm.ams.repository.AssetRepository;
import group05.ccmtptpm.ams.repository.AssetUsageRepository;
import group05.ccmtptpm.ams.repository.UserRepository;
import group05.ccmtptpm.ams.service.IAssetUsageService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AssetUsageServiceImpl implements IAssetUsageService {
    
    private final AssetRepository assetRepository;
    private final AssetUsageRepository assetUsageRepository;
    private final UserRepository userRepository;

    @Override
    public AssetUsageResponse requestAssetUsage(AssetUsageRequest request) {

        Asset asset = assetRepository.findById(request.getAssetId())
                .orElseThrow(() -> new CustomException("Asset not found"));
        // Check if asset is available
        if (asset.getStatus() != EnumAssetStatus.AVAILABLE) {
            throw new CustomException("Asset is not available");
        }
        // Check if asset is currently in use
        if (assetUsageRepository.existsByAssetIdAndStatusIn(request.getAssetId(), Set.of(EnumAssetUsageType.APPROVED, EnumAssetUsageType.PENDING))) {
            throw new CustomException("Asset is currently in use");
        }

        User user = getCurrentUser();

        AssetUsage usage = AssetUsage.builder()
            .asset(asset)
            .user(user)
            .startDate(request.getStartDate())
            .endDate(request.getEndDate())
            .status(EnumAssetUsageType.PENDING)
            .build();
        assetUsageRepository.save(usage);

        return AssetUsageResponse.builder()
            .id(usage.getId())
            .userId(user.getId())
            .userName(user.getUsername())
            .assetId(asset.getId())
            .assetName(asset.getName())
            .startDate(request.getStartDate())
            .endDate(request.getEndDate())
            .status(EnumAssetUsageType.PENDING)
            .build();
    }

    // Helper method to get current user from security context
    public User getCurrentUser() {
        Authentication authentication = SecurityContextHolder
                .getContext()
                .getAuthentication();

        String username = authentication.getName();

        return userRepository.findByUsername(username)
                .orElseThrow(() -> new CustomException("User not found"));
    }


    public void approve(Long id) {
        AssetUsage usage = assetUsageRepository.findById(id)
                .orElseThrow(() -> new CustomException("Asset usage request not found"));

        usage.setStatus(EnumAssetUsageType.APPROVED);

        // cập nhật asset
        Asset asset = usage.getAsset();
        asset.setStatus(EnumAssetStatus.IN_USE);

        assetRepository.save(asset);
        assetUsageRepository.save(usage);
    }

    public void reject(Long id) {
        AssetUsage usage = assetUsageRepository.findById(id)
                .orElseThrow(() -> new CustomException("Asset usage request not found"));

        usage.setStatus(EnumAssetUsageType.REJECTED);

        // cập nhật asset
        Asset asset = usage.getAsset();
        asset.setStatus(EnumAssetStatus.AVAILABLE);

        assetRepository.save(asset);
        assetUsageRepository.save(usage);
    }

    @Override
    public void returnAsset(Long id) {
        AssetUsage usage = assetUsageRepository.findById(id)
                .orElseThrow(() -> new CustomException("Asset usage request not found"));

        usage.setStatus(EnumAssetUsageType.RETURNED);

        Asset asset = usage.getAsset();
        asset.setStatus(EnumAssetStatus.AVAILABLE);

        assetRepository.save(asset);
        assetUsageRepository.save(usage);
    }

    @Override
    public Page<AssetUsageResponse> getAllAssetUsages(int page, int size) {
        return assetUsageRepository.findAll(PageRequest.of(page, size))
                .map(usage -> AssetUsageResponse.builder()
                        .id(usage.getId())
                        .userId(usage.getUser().getId())
                        .userName(usage.getUser().getUsername())
                        .assetId(usage.getAsset().getId())
                        .assetName(usage.getAsset().getName())
                        .startDate(usage.getStartDate())
                        .endDate(usage.getEndDate())
                        .status(usage.getStatus())
                        .build());
    }
}
