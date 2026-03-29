package group05.ccmtptpm.ams.service.impl;

import group05.ccmtptpm.ams.dto.LoginRequest;
import group05.ccmtptpm.ams.dto.LoginResponse;
import group05.ccmtptpm.ams.dto.RegisterRequest;
import group05.ccmtptpm.ams.dto.UserResponse;
import group05.ccmtptpm.ams.entity.User;
import group05.ccmtptpm.ams.exception.CustomException;
import group05.ccmtptpm.ams.repository.UserRepository;
import group05.ccmtptpm.ams.security.JwtUtil;
import group05.ccmtptpm.ams.service.IUserService;
import lombok.RequiredArgsConstructor;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    @Override
    public User createUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    @Override
    public UserResponse register(RegisterRequest request) {

        if (userRepository.existsByUsername(request.getUsername())) {
            throw new CustomException("Username already exists");
        }

        User user = User.builder()
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(request.getRole())
                .build();

        User savedUser = userRepository.save(user);

        return UserResponse.builder()
                .id(savedUser.getId())
                .username(savedUser.getUsername())
                .role(savedUser.getRole())
                .build();
    }

    @Override
    public LoginResponse login(LoginRequest request) {

        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new CustomException("User not found"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new CustomException("Invalid password");
        }

        String token = jwtUtil.generateToken(user.getUsername(), user.getRole());

        return LoginResponse.builder()
                .token(token)
                .user(UserResponse.builder()
                        .id(user.getId())
                        .username(user.getUsername())
                        .role(user.getRole())
                        .build())
                .build();
    }
}