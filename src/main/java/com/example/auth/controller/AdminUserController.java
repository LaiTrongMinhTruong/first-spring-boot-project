package com.example.auth.controller;

import com.example.auth.config.AdminInterceptor;
import com.example.auth.entity.User;
import com.example.auth.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private final UserService userService;

    public AdminUserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("")
    public String listRedirect() {
        return "redirect:/admin/users/searchpaginated";
    }

    @RequestMapping("/searchpaginated")
    public String search(
            ModelMap model,
            @RequestParam(name = "keyword", required = false) String keyword,
            @RequestParam("page") Optional<Integer> page,
            @RequestParam("size") Optional<Integer> size) {

        int count = (int) userService.count();
        int currentPage = Math.max(1, page.orElse(1));
        int pageSize = Math.max(1, size.orElse(3));

        Pageable pageable = PageRequest.of(currentPage - 1, pageSize, Sort.by("username"));
        Page<User> resultPage;

        if (StringUtils.hasText(keyword)) {
            resultPage = userService.search(keyword.trim(), pageable);
            model.addAttribute("keyword", keyword.trim());
        } else {
            resultPage = userService.findAll(pageable);
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

        model.addAttribute("userPage", resultPage);
        return "admin/user/list";
    }

    @GetMapping("/add")
    public String add(ModelMap model) {
        model.addAttribute("userForm", new User());
        model.addAttribute("isEdit", false);
        return "admin/user/addOrEdit";
    }

    @GetMapping("/edit/{id}")
    public String edit(@PathVariable("id") Long id, ModelMap model, RedirectAttributes redirectAttributes) {
        Optional<User> optUser = userService.findById(id);
        if (optUser.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng cần sửa.");
            return "redirect:/admin/users/searchpaginated";
        }
        model.addAttribute("userForm", optUser.get());
        model.addAttribute("isEdit", true);
        return "admin/user/addOrEdit";
    }

    @PostMapping("/saveOrUpdate")
    public String saveOrUpdate(
            @RequestParam(name = "id", required = false) Long id,
            @RequestParam("username") String username,
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam(name = "password", required = false) String password,
            @RequestParam(name = "role", defaultValue = "USER") String role,
            @RequestParam(name = "status", defaultValue = "1") Integer status,
            ModelMap model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        boolean isEdit = id != null;
        User formState = new User(username, "", fullName, email, role, status);
        formState.setId(id);

        if (!StringUtils.hasText(username) || username.trim().length() < 3) {
            model.addAttribute("error", "Tên đăng nhập phải có ít nhất 3 ký tự.");
            model.addAttribute("userForm", formState);
            model.addAttribute("isEdit", isEdit);
            return "admin/user/addOrEdit";
        }
        if (!StringUtils.hasText(fullName)) {
            model.addAttribute("error", "Vui lòng nhập họ và tên.");
            model.addAttribute("userForm", formState);
            model.addAttribute("isEdit", isEdit);
            return "admin/user/addOrEdit";
        }
        if (!StringUtils.hasText(email) || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            model.addAttribute("error", "Địa chỉ email không hợp lệ.");
            model.addAttribute("userForm", formState);
            model.addAttribute("isEdit", isEdit);
            return "admin/user/addOrEdit";
        }
        if (!isEdit && (!StringUtils.hasText(password) || password.length() < 6)) {
            model.addAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự khi tạo tài khoản mới.");
            model.addAttribute("userForm", formState);
            model.addAttribute("isEdit", false);
            return "admin/user/addOrEdit";
        }

        try {
            if (isEdit) {
                User updated = userService.updateByAdmin(id, username, password, fullName, email, role, status);
                User current = (User) session.getAttribute(AdminInterceptor.SESSION_USER_KEY);
                if (current != null && current.getId().equals(updated.getId())) {
                    session.setAttribute(AdminInterceptor.SESSION_USER_KEY, updated);
                }
                redirectAttributes.addFlashAttribute("message", "Cập nhật người dùng thành công!");
            } else {
                userService.createByAdmin(username, password, fullName, email, role, status);
                redirectAttributes.addFlashAttribute("message", "Thêm mới người dùng thành công!");
            }
            return "redirect:/admin/users/searchpaginated";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("userForm", formState);
            model.addAttribute("isEdit", isEdit);
            return "admin/user/addOrEdit";
        }
    }

    @RequestMapping(value = "/delete/{id}", method = {RequestMethod.GET, RequestMethod.POST})
    public String delete(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User current = (User) session.getAttribute(AdminInterceptor.SESSION_USER_KEY);
        if (current != null && current.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("error", "Không thể tự xóa tài khoản quản trị đang đăng nhập.");
            return "redirect:/admin/users/searchpaginated";
        }

        if (userService.findById(id).isPresent()) {
            userService.deleteById(id);
            redirectAttributes.addFlashAttribute("message", "Đã xóa người dùng thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng để xóa.");
        }
        return "redirect:/admin/users/searchpaginated";
    }
}
