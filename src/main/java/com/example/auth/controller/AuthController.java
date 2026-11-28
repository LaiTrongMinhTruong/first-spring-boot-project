package com.example.auth.controller;

import com.example.auth.entity.User;
import com.example.auth.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;
import java.util.regex.Pattern;

@Controller
public class AuthController {

    private static final String SESSION_USER_KEY = "loggedInUser";
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/")
    public String index(HttpSession session) {
        User user = (User) session.getAttribute(SESSION_USER_KEY);
        if (user != null) {
            return "ADMIN".equalsIgnoreCase(user.getRole()) ? "redirect:/admin/home" : "redirect:/home";
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String showLoginPage(
            @RequestParam(name = "error", required = false) String errorCode,
            HttpSession session,
            Model model) {
        if (session.getAttribute(SESSION_USER_KEY) != null) {
            return "redirect:/home";
        }
        if ("auth".equals(errorCode)) {
            model.addAttribute("error", "Vui lòng đăng nhập bằng tài khoản ADMIN để truy cập trang quản trị.");
        }
        return "login";
    }

    @PostMapping("/login")
    public String handleLogin(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {

        if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
            model.addAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.");
            model.addAttribute("username", username);
            return "login";
        }

        Optional<User> authenticated = userService.authenticate(username, password);
        if (authenticated.isEmpty()) {
            model.addAttribute("error", "Tên đăng nhập/mật khẩu không chính xác hoặc tài khoản đã bị khóa.");
            model.addAttribute("username", username);
            return "login";
        }

        User user = authenticated.get();
        session.setAttribute(SESSION_USER_KEY, user);
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            return "redirect:/admin/home";
        }
        return "redirect:/home";
    }

    @GetMapping("/register")
    public String showRegisterPage(HttpSession session) {
        if (session.getAttribute(SESSION_USER_KEY) != null) {
            return "redirect:/home";
        }
        return "register";
    }

    @PostMapping("/register")
    public String handleRegister(
            @RequestParam("username") String username,
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            Model model,
            RedirectAttributes redirectAttributes) {

        model.addAttribute("username", username);
        model.addAttribute("fullName", fullName);
        model.addAttribute("email", email);

        if (username == null || username.trim().length() < 3) {
            model.addAttribute("error", "Tên đăng nhập phải có ít nhất 3 ký tự.");
            return "register";
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            model.addAttribute("error", "Vui lòng nhập họ và tên.");
            return "register";
        }
        if (email == null || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            model.addAttribute("error", "Địa chỉ email không hợp lệ.");
            return "register";
        }
        if (password == null || password.length() < 6) {
            model.addAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            return "register";
        }
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Mật khẩu xác nhận không khớp.");
            return "register";
        }

        try {
            userService.register(username, password, fullName, email);
            redirectAttributes.addFlashAttribute("success", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            return "redirect:/login";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("error", ex.getMessage());
            return "register";
        }
    }

    @GetMapping("/home")
    public String showHomePage(
            @RequestParam(name = "error", required = false) String errorCode,
            HttpSession session,
            Model model) {
        User loggedInUser = (User) session.getAttribute(SESSION_USER_KEY);
        if (loggedInUser == null) {
            return "redirect:/login";
        }
        if ("forbidden".equals(errorCode)) {
            model.addAttribute("error", "Bạn không có quyền truy cập trang quản trị (yêu cầu quyền ADMIN).");
        }
        model.addAttribute("user", loggedInUser);
        return "web/home";
    }

    @GetMapping("/admin/home")
    public String showAdminHomePage(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute(SESSION_USER_KEY);
        model.addAttribute("user", loggedInUser);
        return "admin/home";
    }

    @PostMapping("/logout")
    public String handleLogoutPost(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("success", "Bạn đã đăng xuất thành công.");
        return "redirect:/login";
    }

    @GetMapping("/logout")
    public String handleLogoutGet(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("success", "Bạn đã đăng xuất thành công.");
        return "redirect:/login";
    }
}
