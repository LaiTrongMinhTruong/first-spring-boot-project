<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - Spring Boot Auth</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body class="auth-page">
<div class="card">
    <div class="card-header">
        <h1>Đăng ký tài khoản</h1>
        <p>Tạo tài khoản mới để sử dụng hệ thống</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username"
                   value="<c:out value='${username}'/>"
                   placeholder="Ít nhất 3 ký tự" minlength="3" maxlength="50" required autofocus>
        </div>

        <div class="form-group">
            <label for="fullName">Họ và tên</label>
            <input type="text" id="fullName" name="fullName"
                   value="<c:out value='${fullName}'/>"
                   placeholder="Nguyễn Văn A" maxlength="100" required>
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email"
                   value="<c:out value='${email}'/>"
                   placeholder="example@gmail.com" maxlength="100" required>
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password"
                   placeholder="Ít nhất 6 ký tự" minlength="6" required>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Xác nhận mật khẩu</label>
            <input type="password" id="confirmPassword" name="confirmPassword"
                   placeholder="Nhập lại mật khẩu" minlength="6" required>
        </div>

        <button type="submit" class="btn btn-primary">Đăng ký</button>
    </form>

    <div class="footer-link">
        Đã có tài khoản?
        <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
    </div>
</div>
</body>
</html>
