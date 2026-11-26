<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Spring Boot Auth</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body class="auth-page">
<div class="card">
    <div class="card-header">
        <h1>Đăng nhập</h1>
        <p>Nhập thông tin tài khoản của bạn để tiếp tục</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success"><c:out value="${success}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username"
                   value="<c:out value='${username}'/>"
                   placeholder="Nhập tên đăng nhập" required autofocus>
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password"
                   placeholder="Nhập mật khẩu" required>
        </div>

        <button type="submit" class="btn btn-primary">Đăng nhập</button>
    </form>

    <div class="footer-link">
        Chưa có tài khoản?
        <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
    </div>
</div>
</body>
</html>
