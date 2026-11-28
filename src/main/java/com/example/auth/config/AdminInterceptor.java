package com.example.auth.config;

import com.example.auth.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminInterceptor implements HandlerInterceptor {

    public static final String SESSION_USER_KEY = "loggedInUser";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute(SESSION_USER_KEY) : null;

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth");
            return false;
        }

        if (!"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home?error=forbidden");
            return false;
        }

        return true;
    }
}
