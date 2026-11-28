package com.example.auth.config;

import com.example.auth.entity.Category;
import com.example.auth.repository.CategoryRepository;
import com.example.auth.repository.UserRepository;
import com.example.auth.service.UserService;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner seedData(CategoryRepository categoryRepository,
                                      UserRepository userRepository,
                                      UserService userService) {
        return args -> {
            if (categoryRepository.count() == 0) {
                categoryRepository.saveAll(List.of(
                        new Category("Điện thoại", "phone.png", 1),
                        new Category("Laptop", "laptop.png", 1),
                        new Category("Máy tính bảng", "tablet.png", 1),
                        new Category("Tai nghe", "headphone.png", 1),
                        new Category("Đồng hồ thông minh", "smartwatch.png", 1),
                        new Category("Phụ kiện sạc", "charger.png", 1),
                        new Category("Bàn phím cơ", "keyboard.png", 1),
                        new Category("Chuột gaming", "mouse.png", 1),
                        new Category("Màn hình máy tính", "monitor.png", 0),
                        new Category("Loa Bluetooth", "speaker.png", 1)
                ));
            }

            if (!userRepository.existsByUsername("admin")) {
                userService.createByAdmin("admin", "admin123", "Quản trị viên", "admin@example.com", "ADMIN", 1);
            }
            if (userRepository.count() < 5) {
                seedUserIfMissing(userRepository, userService, "nguyenvana", "123456", "Nguyễn Văn A", "nguyenvana@example.com", "USER", 1);
                seedUserIfMissing(userRepository, userService, "tranthib", "123456", "Trần Thị B", "tranthib@example.com", "USER", 1);
                seedUserIfMissing(userRepository, userService, "levanc", "123456", "Lê Văn C", "levanc@example.com", "USER", 1);
                seedUserIfMissing(userRepository, userService, "phamthid", "123456", "Phạm Thị D", "phamthid@example.com", "USER", 0);
            }
        };
    }

    private void seedUserIfMissing(UserRepository repo, UserService userService,
                                   String username, String password, String fullName,
                                   String email, String role, Integer status) {
        if (!repo.existsByUsername(username) && !repo.existsByEmail(email)) {
            userService.createByAdmin(username, password, fullName, email, role, status);
        }
    }
}
