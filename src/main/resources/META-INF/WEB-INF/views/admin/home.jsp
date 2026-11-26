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
        <span class="badge">Admin Decorator (SiteMesh 3)</span>
        <h1>Bảng điều khiển Quản trị</h1>
        <p>Xin chào <c:out value="${user.fullName}"/> — chọn chức năng quản lý bên dưới</p>
    </div>

    <div class="action-row">
        <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="btn btn-primary">
            Danh sách Danh mục (Tìm kiếm &amp; Phân trang)
        </a>
        <a href="${pageContext.request.contextPath}/admin/categories/add" class="btn btn-secondary" style="margin-top: 10px;">
            + Thêm danh mục mới
        </a>
    </div>
</div>
</body>
</html>
