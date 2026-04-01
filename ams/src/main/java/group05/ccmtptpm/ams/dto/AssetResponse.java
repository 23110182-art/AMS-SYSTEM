package group05.ccmtptpm.ams.dto;

import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class AssetResponse {
    
    private Long id;
    private String name;
    private EnumAssetStatus status;
    private String assetTypeName;

}
