package group05.ccmtptpm.ams.service;

import group05.ccmtptpm.ams.dto.LoginRequest;
import group05.ccmtptpm.ams.dto.LoginResponse;
import group05.ccmtptpm.ams.dto.RegisterRequest;
import group05.ccmtptpm.ams.dto.UserResponse;
import group05.ccmtptpm.ams.entity.User;

public interface IUserService {

    User createUser(User user);

    UserResponse register(RegisterRequest request);

    LoginResponse login(LoginRequest request);

    
}