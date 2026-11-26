<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Danh mục - Tìm kiếm &amp; Phân trang</title>
</head>
<body>
<div class="panel">
    <div class="panel-header">
        <div>
            <h1>Quản lý Danh mục</h1>
            <p class="subtitle">Tìm kiếm và phân trang bằng Spring Data JPA (Pageable)</p>
        </div>
        <a class="btn btn-primary btn-inline" href="${pageContext.request.contextPath}/admin/categories/add">+ Thêm danh mục</a>
    </div>

    <c:if test="${message != null}">
        <div class="alert alert-success"><c:out value="${message}"/></div>
    </c:if>

    <div class="toolbar">
        <form action="${pageContext.request.contextPath}/admin/categories/searchpaginated" method="get" class="search-form">
            <input type="text" name="name" id="name" value="<c:out value='${name}'/>" placeholder="Nhập từ khóa để tìm..." />
            <input type="hidden" name="size" value="${categoryPage.size}" />
            <button type="submit" class="btn btn-primary btn-inline">Tìm kiếm</button>
            <c:if test="${not empty name}">
                <a class="btn btn-secondary btn-inline" href="${pageContext.request.contextPath}/admin/categories/searchpaginated?size=${categoryPage.size}">Xóa lọc</a>
            </c:if>
        </form>

        <form action="${pageContext.request.contextPath}/admin/categories/searchpaginated" method="get" class="size-form">
            <c:if test="${not empty name}">
                <input type="hidden" name="name" value="<c:out value='${name}'/>" />
            </c:if>
            <label for="size">Số dòng/trang:</label>
            <select name="size" id="size" onchange="this.form.submit()">
                <option ${categoryPage.size == 3 ? 'selected' : ''} value="3">3</option>
                <option ${categoryPage.size == 5 ? 'selected' : ''} value="5">5</option>
                <option ${categoryPage.size == 10 ? 'selected' : ''} value="10">10</option>
                <option ${categoryPage.size == 15 ? 'selected' : ''} value="15">15</option>
                <option ${categoryPage.size == 20 ? 'selected' : ''} value="20">20</option>
            </select>
        </form>
    </div>

    <c:if test="${!categoryPage.hasContent()}">
        <div class="empty-state">Không tìm thấy danh mục nào (No Category).</div>
    </c:if>

    <c:if test="${categoryPage.hasContent()}">
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Hình ảnh</th>
                    <th>Tên danh mục</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${categoryPage.content}" var="cate" varStatus="STT">
                    <tr>
                        <td>${categoryPage.number * categoryPage.size + STT.index + 1}</td>
                        <td><c:out value="${cate.images}"/></td>
                        <td><strong><c:out value="${cate.name}"/></strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${cate.status == 1}">
                                    <span class="status-badge status-active">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-inactive">Tạm khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions-cell">
                            <a class="link-edit" href="${pageContext.request.contextPath}/admin/categories/edit/${cate.id}">Sửa</a>
                            <a class="link-delete" href="${pageContext.request.contextPath}/admin/categories/delete/${cate.id}"
                               onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="pagination-bar">
            <span class="page-summary">
                Trang <strong>${categoryPage.number + 1}</strong> / <strong>${categoryPage.totalPages}</strong>
                (Tổng <strong>${categoryPage.totalElements}</strong> danh mục)
            </span>

            <c:if test="${categoryPage.totalPages > 1}">
                <ul class="pagination">
                    <c:forEach items="${pageNumbers}" var="pageNumber">
                        <li class="${pageNumber == categoryPage.number + 1 ? 'page-item active' : 'page-item'}">
                            <a href="<c:url value='/admin/categories/searchpaginated'>
                                <c:if test='${not empty name}'><c:param name='name' value='${name}'/></c:if>
                                <c:param name='size' value='${categoryPage.size}'/>
                                <c:param name='page' value='${pageNumber}'/>
                            </c:url>">${pageNumber}</a>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>
        </div>
    </c:if>
</div>
</body>
</html>
