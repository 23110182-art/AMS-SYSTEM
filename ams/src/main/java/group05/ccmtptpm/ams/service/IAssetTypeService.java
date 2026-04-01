package group05.ccmtptpm.ams.service;


import org.springframework.data.domain.Page;

import group05.ccmtptpm.ams.dto.AssetTypeResponse;


public interface IAssetTypeService {
    AssetTypeResponse createAssetType(String name);

    AssetTypeResponse updateAssetType(Long id, String name);

    boolean deleteAssetType(Long id);

    Page<AssetTypeResponse> getAllAssetTypes(int page, int size);

    AssetTypeResponse getAssetTypeById(Long id);

}
