package group05.ccmtptpm.ams.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import group05.ccmtptpm.ams.dto.AddAssetRequest;
import group05.ccmtptpm.ams.dto.AssetRequest;
import group05.ccmtptpm.ams.dto.AssetResponse;
import group05.ccmtptpm.ams.entity.Asset;
import group05.ccmtptpm.ams.entity.AssetType;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import group05.ccmtptpm.ams.exception.CustomException;
import group05.ccmtptpm.ams.repository.AssetRepository;
import group05.ccmtptpm.ams.repository.AssetTypeRepository;
import group05.ccmtptpm.ams.service.IAssetService;
import lombok.RequiredArgsConstructor;


@Service
@RequiredArgsConstructor
public class AssetServiceImpl implements IAssetService {
    
    private final AssetRepository assetRepository;
    private final AssetTypeRepository assetTypeRepository;

    @Override
    public Page<AssetResponse> getAllAssets(int page, int size) {
    
        Page<Asset> assets = assetRepository.findAll(PageRequest.of(page, size));
        return assets.map(asset -> AssetResponse.builder()
                .id(asset.getId())
                .name(asset.getName())
                .status(asset.getStatus())
                .assetTypeName(asset.getAssetType().getName())
                .build());
    }


    @Override
    public List<AssetResponse> addAsset(AddAssetRequest request) {

        AssetType assetType = assetTypeRepository.findByName(request.getAssetTypeName())
                .orElseThrow(() -> new CustomException("Asset type not found with name: " + request.getAssetTypeName()));
        
        List<String> existingNames = assetRepository.findNamesByBaseName(request.getName());
        int maxSuffix = 0;
        for (String existingName : existingNames) {
            String suffix = existingName.substring(request.getName().length()).trim();
            if (suffix.matches("\\d+")) {
                int suffixNumber = Integer.parseInt(suffix);
                if (suffixNumber > maxSuffix) {
                    maxSuffix = suffixNumber;
                }
            }
        }

        List<AssetResponse> responses = new ArrayList<>();
        for (int i = 1; i <= request.getQuantity(); i++) {
            String assetName = request.getName();
            if (maxSuffix > 0 || request.getQuantity() > 1) {
                assetName += " " + (maxSuffix + i);
            }
            // Create and save the asset with assetName
            Asset asset = Asset.builder()
                    .name(assetName)
                    .description(request.getDescription())
                    .status(request.getStatus())
                    .assetType(assetType)
                    .build();
            assetRepository.save(asset);
            // Create AssetResponse and add to responses list
            AssetResponse response = AssetResponse.builder()
                    .id(asset.getId())
                    .name(asset.getName())
                    .status(asset.getStatus())
                    .assetTypeName(asset.getAssetType().getName())
                    .build();
            responses.add(response);
        }

        return responses;
    }

    @Override
    public AssetResponse updateAsset(Long id, AssetRequest request) {
        
        // check if asset exists
        Asset asset = assetRepository.findById(id)
                .orElseThrow(() -> new CustomException("Asset not found with id: " + id));
        // update asset properties
        asset.setName(request.getName());
        asset.setDescription(request.getDescription());
        asset.setStatus(request.getStatus());

        // save updated asset
        Asset updatedAsset = assetRepository.save(asset);
        // return response
        return AssetResponse.builder()
                .id(updatedAsset.getId())
                .name(updatedAsset.getName())
                .status(updatedAsset.getStatus())
                .assetTypeName(updatedAsset.getAssetType().getName())
                .build();
    }
        

    @Override
    public boolean deleteAsset(Long id) {
       
        if (!assetRepository.existsById(id)) {
            throw new CustomException("Asset not found with id: " + id);
        }
        assetRepository.deleteById(id);
        return true;
    }

    @Override
    public AssetResponse getAssetById(Long id) {
        Asset asset = assetRepository.findById(id)
                .orElseThrow(() -> new CustomException("Asset not found with id: " + id));
        return AssetResponse.builder()
                .id(asset.getId())
                .name(asset.getName())
                .status(asset.getStatus())
                .assetTypeName(asset.getAssetType().getName())
                .build();
    }

    @Override
    public Long countAssetsByStatusOrAll(EnumAssetStatus status) {
        return assetRepository.countByStatusOrAll(status);
    }

    @Override
    public Long countAssetByType(String assetTypeName) {
        return assetRepository.countByAssetTypeName(assetTypeName);
    }

    @Override
    public Map<String, Long> assetStatisticByAssetType() {
        List<Object[]> results = assetRepository.assetStatisticByAssetType();
        Map<String, Long> statistic = new java.util.HashMap<>();
        for (Object[] result : results) {
            String typeName = (String) result[0];
            Long count = (Long) result[1];
            statistic.put(typeName, count);
        }
        return statistic;
    }
}
