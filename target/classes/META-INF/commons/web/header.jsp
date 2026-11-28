<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="navbar">
    <div class="navbar-inner">
        <a class="brand" href="${pageContext.request.contextPath}/home">SpringBoot 4 Auth &amp; JSP</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <c:if test="${sessionScope.loggedInUser.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/home">Trang quản trị</a>
                <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated">QL Category</a>
                <a href="${pageContext.request.contextPath}/admin/users/searchpaginated">QL User</a>
            </c:if>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <a class="nav-logout" href="${pageContext.request.contextPath}/logout">Đăng xuất (<c:out value="${sessionScope.loggedInUser.username}"/>)</a>
            </c:if>
        </nav>
    </div>
</header>
