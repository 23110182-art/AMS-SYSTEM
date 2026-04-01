package group05.ccmtptpm.ams.dto;

import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import lombok.*;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class AssetRequest {
    
    private String name;
    private String description;
    private EnumAssetStatus status;
    private String assetTypeName;
}
