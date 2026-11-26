<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="navbar navbar-admin">
    <div class="navbar-inner">
        <a class="brand" href="${pageContext.request.contextPath}/admin/home">Admin Portal</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Trang Web</a>
            <a href="${pageContext.request.contextPath}/admin/home">Admin Home</a>
            <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated">Quản lý Danh mục</a>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <a class="nav-logout" href="${pageContext.request.contextPath}/logout">Đăng xuất (<c:out value="${sessionScope.loggedInUser.username}"/>)</a>
            </c:if>
            <c:if test="${empty sessionScope.loggedInUser}">
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </c:if>
        </nav>
    </div>
</header>
