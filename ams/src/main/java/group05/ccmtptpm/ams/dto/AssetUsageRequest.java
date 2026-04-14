package group05.ccmtptpm.ams.dto;

import java.time.LocalDate;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssetUsageRequest {
    private Long assetId;
    private LocalDate startDate;
    private LocalDate endDate;
}
