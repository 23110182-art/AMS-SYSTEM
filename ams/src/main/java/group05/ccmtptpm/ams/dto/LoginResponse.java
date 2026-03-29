package group05.ccmtptpm.ams.dto;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class LoginResponse {

    private String token;
    private UserResponse user;
}