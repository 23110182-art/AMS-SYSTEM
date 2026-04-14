package group05.ccmtptpm.ams.entity;

import group05.ccmtptpm.ams.enums.EnumAssetUsageType;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;


@Entity
@Table(name = "asset_usages")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AssetUsage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Người dùng
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    // Tài sản
    @ManyToOne
    @JoinColumn(name = "asset_id")
    private Asset asset;

    private LocalDate startDate;
    private LocalDate endDate;

    @Enumerated(EnumType.STRING)
    private EnumAssetUsageType status;
}
