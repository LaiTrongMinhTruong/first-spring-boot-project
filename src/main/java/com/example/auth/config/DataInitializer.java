package com.example.auth.config;

import com.example.auth.entity.Category;
import com.example.auth.repository.CategoryRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner seedCategories(CategoryRepository categoryRepository) {
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
        };
    }
}
