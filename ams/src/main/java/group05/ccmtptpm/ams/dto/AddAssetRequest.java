package group05.ccmtptpm.ams.dto;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class AddAssetRequest {
    @NotBlank(message = "Name is required")
    private String name;

    private String description;

    @NotBlank(message = "Status is required")
    private EnumAssetStatus status;

    @NotBlank(message = "Asset type name is required")
    private String assetTypeName;

    @NotBlank(message = "Quantity is required")
    private Long quantity;
    
}
