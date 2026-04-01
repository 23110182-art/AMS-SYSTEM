package group05.ccmtptpm.ams.service.impl;

import group05.ccmtptpm.ams.dto.AssetTypeResponse;
import group05.ccmtptpm.ams.entity.AssetType;
import group05.ccmtptpm.ams.exception.CustomException;
import group05.ccmtptpm.ams.repository.AssetTypeRepository;
import group05.ccmtptpm.ams.service.IAssetTypeService;
import lombok.RequiredArgsConstructor;


import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AssetTypeServiceImpl implements IAssetTypeService {

    private final AssetTypeRepository assetTypeRepository;

    @Override
    public AssetTypeResponse createAssetType(String name) {
        // Implementation for creating asset type
        if (assetTypeRepository.existsByName(name)) {
            throw new CustomException("Asset type with name '" + name + "' already exists.");
        }
        AssetType assetType = AssetType.builder()
                .name(name)
                .build();
        
        AssetType savedAssetType = assetTypeRepository.save(assetType);

        return AssetTypeResponse.builder()
                .id(savedAssetType.getId())
                .name(savedAssetType.getName())
                .build();

    }

    @Override
    public AssetTypeResponse updateAssetType(Long id, String name) {
        // Implementation for updating asset type
         AssetType assetType = assetTypeRepository.findById(id)
                .orElseThrow(() -> new CustomException("Asset type not found with id: " + id));

        assetType.setName(name);
        AssetType updatedAssetType = assetTypeRepository.save(assetType);

        return AssetTypeResponse.builder()
                .id(updatedAssetType.getId())
                .name(updatedAssetType.getName())
                .build();
    }

    @Override
    public boolean deleteAssetType(Long id) {
        // Implementation for deleting asset type
        if (!assetTypeRepository.existsById(id)) {
            throw new CustomException("Asset type not found with id: " + id);
        }
        assetTypeRepository.deleteById(id);
        return true;
    }

    @Override
    public Page<AssetTypeResponse> getAllAssetTypes(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);

        return assetTypeRepository.findAll(pageable)
                .map(assetType -> AssetTypeResponse.builder()
                        .id(assetType.getId())
                        .name(assetType.getName())
                        .build());
    }

    @Override
    public AssetTypeResponse getAssetTypeById(Long id) {
        AssetType assetType = assetTypeRepository.findById(id)
                .orElseThrow(() -> new CustomException("Asset type not found with id: " + id));

        return AssetTypeResponse.builder()
                .id(assetType.getId())
                .name(assetType.getName())
                .build();
    }
}
