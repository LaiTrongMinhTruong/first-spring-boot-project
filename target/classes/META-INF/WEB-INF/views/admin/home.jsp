<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang Quản trị - Admin Home</title>
</head>
<body>
<div class="card card-wide centered-card">
    <div class="card-header">
        <span class="badge">Role ADMIN — Spring Boot 4</span>
        <h1>Bảng điều khiển Quản trị</h1>
        <p>Xin chào <c:out value="${user.fullName}"/> — chọn phân hệ quản lý bên dưới</p>
    </div>

    <div class="action-row">
        <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="btn btn-primary">
            Quản lý Category (CRUD, Tìm kiếm &amp; Phân trang)
        </a>
        <a href="${pageContext.request.contextPath}/admin/users/searchpaginated" class="btn btn-primary" style="margin-top: 10px;">
            Quản lý User (CRUD, Tìm kiếm &amp; Phân trang)
        </a>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary" style="margin-top: 10px;">
            Xem thông tin tài khoản
        </a>
    </div>
</div>
</body>
</html>
