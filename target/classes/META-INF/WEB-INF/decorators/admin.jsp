<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title" /></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <sitemesh:write property="head" />
</head>
<body class="layout-page">
    <%@ include file="/commons/admin/header.jsp" %>
    <main class="main-container">
        <sitemesh:write property="body" />
    </main>
    <%@ include file="/commons/admin/footer.jsp" %>
</body>
</html>
