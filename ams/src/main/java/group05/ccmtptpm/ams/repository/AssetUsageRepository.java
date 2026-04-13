package group05.ccmtptpm.ams.repository;

import java.util.Set;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import group05.ccmtptpm.ams.entity.AssetUsage;
import group05.ccmtptpm.ams.enums.EnumAssetUsageType;

public interface AssetUsageRepository extends JpaRepository<AssetUsage, Long> {
    
    //TODO: check if asset is currently in use
    boolean existsByAssetIdAndStatusIn(Long assetId, Set<EnumAssetUsageType> statuses);

    Page<AssetUsage> findByUserUsernameOrderByIdDesc(String username, Pageable pageable);
}
