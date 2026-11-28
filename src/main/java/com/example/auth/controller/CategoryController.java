package com.example.auth.controller;

import com.example.auth.entity.Category;
import com.example.auth.service.CategoryService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/admin/categories")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("")
    public String listRedirect() {
        return "redirect:/admin/categories/searchpaginated";
    }

    @RequestMapping("/searchpaginated")
    public String search(
            ModelMap model,
            @RequestParam(name = "name", required = false) String name,
            @RequestParam("page") Optional<Integer> page,
            @RequestParam("size") Optional<Integer> size) {

        int count = (int) categoryService.count();
        int currentPage = Math.max(1, page.orElse(1));
        int pageSize = Math.max(1, size.orElse(3));

        Pageable pageable = PageRequest.of(currentPage - 1, pageSize, Sort.by("name"));
        Page<Category> resultPage;

        if (StringUtils.hasText(name)) {
            resultPage = categoryService.findByNameContaining(name.trim(), pageable);
            model.addAttribute("name", name.trim());
        } else {
            resultPage = categoryService.findAll(pageable);
        }

        int totalPages = resultPage.getTotalPages();
        if (totalPages > 0) {
            int start = Math.max(1, currentPage - 2);
            int end = Math.min(currentPage + 2, totalPages);
            if (totalPages > count) {
                if (end == totalPages) {
                    start = Math.max(1, end - count);
                } else if (start == 1) {
                    end = Math.min(totalPages, start + count);
                }
            }
            List<Integer> pageNumbers = IntStream.rangeClosed(start, end)
                    .boxed()
                    .collect(Collectors.toList());
            model.addAttribute("pageNumbers", pageNumbers);
        }

        model.addAttribute("categoryPage", resultPage);
        return "admin/category/list";
    }

    @GetMapping("/add")
    public String add(ModelMap model) {
        model.addAttribute("category", new Category());
        model.addAttribute("isEdit", false);
        return "admin/category/addOrEdit";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap model, RedirectAttributes redirectAttributes) {
        Optional<Category> optCategory = categoryService.findById(id);
        if (optCategory.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Không tìm thấy danh mục cần sửa.");
            return "redirect:/admin/categories/searchpaginated";
        }
        model.addAttribute("category", optCategory.get());
        model.addAttribute("isEdit", true);
        return "admin/category/addOrEdit";
    }

    @PostMapping("/saveOrUpdate")
    public String saveOrUpdate(@ModelAttribute("category") Category category, RedirectAttributes redirectAttributes) {
        if (!StringUtils.hasText(category.getName())) {
            redirectAttributes.addFlashAttribute("message", "Tên danh mục không được để trống.");
            return "redirect:/admin/categories/add";
        }
        if (category.getStatus() == null) {
            category.setStatus(1);
        }
        boolean isUpdate = category.getId() != null;
        categoryService.save(category);
        redirectAttributes.addFlashAttribute("message",
                isUpdate ? "Cập nhật danh mục thành công!" : "Thêm mới danh mục thành công!");
        return "redirect:/admin/categories/searchpaginated";
    }

    @RequestMapping(value = "/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String delete(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        if (categoryService.findById(id).isPresent()) {
            categoryService.deleteById(id);
            redirectAttributes.addFlashAttribute("message", "Đã xóa danh mục thành công!");
        } else {
            redirectAttributes.addFlashAttribute("message", "Không tìm thấy danh mục để xóa.");
        }
        return "redirect:/admin/categories/searchpaginated";
    }
}
