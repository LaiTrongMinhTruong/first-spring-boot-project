package com.example.auth.service;

import com.example.auth.entity.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface CategoryService {

    Page<Category> findByNameContaining(String keyword, Pageable page);

    Page<Category> findAll(Pageable page);

    long count();

    Optional<Category> findById(Long id);

    Category save(Category category);

    void deleteById(Long id);
}
