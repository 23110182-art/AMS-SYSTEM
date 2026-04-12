package group05.ccmtptpm.ams.repository;

import org.springframework.stereotype.Repository;
import group05.ccmtptpm.ams.entity.Asset;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

@Repository
public interface AssetRepository extends JpaRepository<Asset, Long> {

    @Query("SELECT a.name FROM Asset a WHERE a.name LIKE CONCAT(:baseName, ' %')")
    List<String> findNamesByBaseName(String baseName);


    @Query("SELECT COUNT(a) FROM Asset a WHERE a.status = :status OR :status IS NULL")
    Long countByStatusOrAll(EnumAssetStatus status);

   
    @Query("SELECT COUNT(a) FROM Asset a WHERE a.assetType.name = :assetTypeName")
    Long countByAssetTypeName(String assetTypeName);

   
    @Query("SELECT a.assetType.name AS typeName, COUNT(a) AS count FROM Asset a GROUP BY a.assetType.name")
    List<Object[]> assetStatisticByAssetType();
}
