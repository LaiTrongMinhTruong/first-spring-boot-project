<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Trang chủ - Spring Boot 4 Auth</title>
</head>
<body>
<div class="card card-wide centered-card">
    <div class="card-header">
        <span class="badge">Đang đăng nhập (${user.role})</span>
        <h1>Xin chào, <c:out value="${user.fullName}"/>!</h1>
        <p>Bạn đã đăng nhập thành công vào hệ thống</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>

    <div class="profile-box">
        <div class="profile-row">
            <span class="profile-label">ID tài khoản</span>
            <span class="profile-value">#<c:out value="${user.id}"/></span>
        </div>
        <div class="profile-row">
            <span class="profile-label">Tên đăng nhập</span>
            <span class="profile-value"><c:out value="${user.username}"/></span>
        </div>
        <div class="profile-row">
            <span class="profile-label">Họ và tên</span>
            <span class="profile-value"><c:out value="${user.fullName}"/></span>
        </div>
        <div class="profile-row">
            <span class="profile-label">Email</span>
            <span class="profile-value"><c:out value="${user.email}"/></span>
        </div>
        <div class="profile-row">
            <span class="profile-label">Vai trò</span>
            <span class="profile-value"><c:out value="${user.role}"/></span>
        </div>
    </div>

    <div class="action-row">
        <c:if test="${user.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/home" class="btn btn-primary">
                Vào trang Quản trị (Admin)
            </a>
        </c:if>
        <form action="${pageContext.request.contextPath}/logout" method="post" style="margin-top: 10px;">
            <button type="submit" class="btn btn-danger">Đăng xuất</button>
        </form>
    </div>
</div>
</body>
</html>
