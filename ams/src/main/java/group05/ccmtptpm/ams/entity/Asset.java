package group05.ccmtptpm.ams.entity;

import group05.ccmtptpm.ams.enums.EnumAssetStatus;
import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "assets")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Asset {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    private String description;

    @Enumerated(EnumType.STRING)
    private EnumAssetStatus status;

    @ManyToOne
    @JoinColumn(name = "type_id")
    private AssetType assetType;
}
