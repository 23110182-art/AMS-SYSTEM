package group05.ccmtptpm.ams.repository;

import org.springframework.stereotype.Repository;
import group05.ccmtptpm.ams.entity.Asset;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

@Repository
public interface AssetRepository extends JpaRepository<Asset, Long> {

    @Query("SELECT a.name FROM Asset a WHERE a.name LIKE CONCAT(:baseName, ' %')")
    List<String> findNamesByBaseName(String baseName);
}
