package group05.ccmtptpm.ams.repository;

import org.springframework.stereotype.Repository;
import group05.ccmtptpm.ams.entity.AssetType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


@Repository
public interface AssetTypeRepository extends JpaRepository<AssetType, Long> {
    Optional<AssetType> findByName(String name);

    boolean existsByName(String name);
}
