package com.example.auth.service;

import com.example.auth.entity.User;
import com.example.auth.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    @Transactional
    public User register(String username, String password, String fullName, String email) {
        return createByAdmin(username, password, fullName, email, "USER", 1);
    }

    @Transactional(readOnly = true)
    public Optional<User> authenticate(String username, String rawPassword) {
        if (username == null || rawPassword == null) {
            return Optional.empty();
        }
        return userRepository.findByUsername(username.trim())
                .filter(user -> user.getStatus() == null || user.getStatus() == 1)
                .filter(user -> passwordEncoder.matches(rawPassword, user.getPassword()));
    }

    @Transactional(readOnly = true)
    public Page<User> findAll(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Page<User> search(String keyword, Pageable pageable) {
        String trimmed = keyword.trim();
        return userRepository.findByUsernameContainingIgnoreCaseOrFullNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                trimmed, trimmed, trimmed, pageable);
    }

    @Transactional(readOnly = true)
    public long count() {
        return userRepository.count();
    }

    @Transactional(readOnly = true)
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Transactional
    public User createByAdmin(String username, String password, String fullName, String email, String role, Integer status) {
        String normalizedUsername = username.trim();
        String normalizedEmail = email.trim().toLowerCase();
        String normalizedFullName = fullName.trim();
        String normalizedRole = normalizeRole(role);
        Integer normalizedStatus = (status != null && status == 0) ? 0 : 1;

        if (userRepository.existsByUsername(normalizedUsername)) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
        }
        if (userRepository.existsByEmail(normalizedEmail)) {
            throw new IllegalArgumentException("Email đã được sử dụng. Vui lòng dùng email khác.");
        }

        String encodedPassword = passwordEncoder.encode(password);
        User user = new User(normalizedUsername, encodedPassword, normalizedFullName, normalizedEmail, normalizedRole, normalizedStatus);
        return userRepository.save(user);
    }

    @Transactional
    public User updateByAdmin(Long id, String username, String newPassword, String fullName, String email, String role, Integer status) {
        User existing = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy người dùng cần cập nhật."));

        String normalizedUsername = username.trim();
        String normalizedEmail = email.trim().toLowerCase();
        String normalizedFullName = fullName.trim();
        String normalizedRole = normalizeRole(role);
        Integer normalizedStatus = (status != null && status == 0) ? 0 : 1;

        if (userRepository.existsByUsernameAndIdNot(normalizedUsername, id)) {
            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại ở tài khoản khác.");
        }
        if (userRepository.existsByEmailAndIdNot(normalizedEmail, id)) {
            throw new IllegalArgumentException("Email đã được sử dụng ở tài khoản khác.");
        }

        existing.setUsername(normalizedUsername);
        existing.setFullName(normalizedFullName);
        existing.setEmail(normalizedEmail);
        existing.setRole(normalizedRole);
        existing.setStatus(normalizedStatus);

        if (StringUtils.hasText(newPassword)) {
            if (newPassword.length() < 6) {
                throw new IllegalArgumentException("Mật khẩu mới phải có ít nhất 6 ký tự.");
            }
            existing.setPassword(passwordEncoder.encode(newPassword));
        }

        return userRepository.save(existing);
    }

    @Transactional
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }

    private String normalizeRole(String role) {
        return "ADMIN".equalsIgnoreCase(role) ? "ADMIN" : "USER";
    }
}
