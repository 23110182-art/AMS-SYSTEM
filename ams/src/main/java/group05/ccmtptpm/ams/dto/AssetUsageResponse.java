package group05.ccmtptpm.ams.dto;

import java.time.LocalDate;
import group05.ccmtptpm.ams.enums.EnumAssetUsageType;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class AssetUsageResponse {
    private Long id;
    private Long userId;
    private String userName;
    private Long assetId;
    private String assetName;
    private LocalDate startDate;
    private LocalDate endDate;
    private EnumAssetUsageType status;
}
