package group05.ccmtptpm.ams.dto;
import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class AddAssetRequest {
    @NotBlank(message = "Name is required")
    private String name;

    private String description;

    @NotNull(message = "Status is required")
    private EnumAssetStatus status;

    @NotBlank(message = "Asset type name is required")
    private String assetTypeName;

    @NotNull(message = "Quantity is required")
    @Min(value = 1, message = "Quantity must be greater than 0")
    private Long quantity;
    
}
