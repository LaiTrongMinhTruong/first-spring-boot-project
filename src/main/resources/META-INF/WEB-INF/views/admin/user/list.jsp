<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Quản lý Người dùng - Tìm kiếm &amp; Phân trang</title>
</head>
<body>
<div class="panel">
    <div class="panel-header">
        <div>
            <h1>Quản lý Người dùng (User)</h1>
            <p class="subtitle">CRUD, tìm kiếm và phân trang bằng Spring Data JPA (Pageable)</p>
        </div>
        <a class="btn btn-primary btn-inline" href="${pageContext.request.contextPath}/admin/users/add">+ Thêm người dùng</a>
    </div>

    <c:if test="${not empty message}">
        <div class="alert alert-success"><c:out value="${message}"/></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>

    <div class="toolbar">
        <form action="${pageContext.request.contextPath}/admin/users/searchpaginated" method="get" class="search-form">
            <input type="text" name="keyword" id="keyword" value="<c:out value='${keyword}'/>"
                   placeholder="Tìm theo username, họ tên hoặc email..." />
            <input type="hidden" name="size" value="${userPage.size}" />
            <button type="submit" class="btn btn-primary btn-inline">Tìm kiếm</button>
            <c:if test="${not empty keyword}">
                <a class="btn btn-secondary btn-inline"
                   href="${pageContext.request.contextPath}/admin/users/searchpaginated?size=${userPage.size}">Xóa lọc</a>
            </c:if>
        </form>

        <form action="${pageContext.request.contextPath}/admin/users/searchpaginated" method="get" class="size-form">
            <c:if test="${not empty keyword}">
                <input type="hidden" name="keyword" value="<c:out value='${keyword}'/>" />
            </c:if>
            <label for="size">Số dòng/trang:</label>
            <select name="size" id="size" onchange="this.form.submit()">
                <option ${userPage.size == 3 ? 'selected' : ''} value="3">3</option>
                <option ${userPage.size == 5 ? 'selected' : ''} value="5">5</option>
                <option ${userPage.size == 10 ? 'selected' : ''} value="10">10</option>
                <option ${userPage.size == 15 ? 'selected' : ''} value="15">15</option>
                <option ${userPage.size == 20 ? 'selected' : ''} value="20">20</option>
            </select>
        </form>
    </div>

    <c:if test="${!userPage.hasContent()}">
        <div class="empty-state">Không tìm thấy người dùng nào (No User).</div>
    </c:if>

    <c:if test="${userPage.hasContent()}">
        <div class="table-wrapper">
            <table class="data-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên đăng nhập</th>
                    <th>Họ và tên</th>
                    <th>Email</th>
                    <th>Vai trò</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${userPage.content}" var="u" varStatus="STT">
                    <tr>
                        <td>${userPage.number * userPage.size + STT.index + 1}</td>
                        <td><strong><c:out value="${u.username}"/></strong></td>
                        <td><c:out value="${u.fullName}"/></td>
                        <td><c:out value="${u.email}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.role == 'ADMIN'}">
                                    <span class="status-badge" style="background:#e0e7ff;color:#3730a3;">ADMIN</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge" style="background:#f1f5f9;color:#475569;">USER</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${u.status == 1}">
                                    <span class="status-badge status-active">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-inactive">Tạm khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="actions-cell">
                            <a class="link-edit" href="${pageContext.request.contextPath}/admin/users/edit/${u.id}">Sửa</a>
                            <c:if test="${sessionScope.loggedInUser.id != u.id}">
                                <button type="button" class="link-delete btn-link-delete"
                                        data-url="${pageContext.request.contextPath}/admin/users/delete/${u.id}"
                                        data-name="<c:out value='${u.username}'/>"
                                        onclick="openDeleteModal(this)">Xóa</button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="pagination-bar">
            <span class="page-summary">
                Trang <strong>${userPage.number + 1}</strong> / <strong>${userPage.totalPages}</strong>
                (Tổng <strong>${userPage.totalElements}</strong> người dùng)
            </span>

            <c:if test="${userPage.totalPages > 1}">
                <ul class="pagination">
                    <c:forEach items="${pageNumbers}" var="pageNumber">
                        <li class="${pageNumber == userPage.number + 1 ? 'page-item active' : 'page-item'}">
                            <a href="<c:url value='/admin/users/searchpaginated'>
                                <c:if test='${not empty keyword}'><c:param name='keyword' value='${keyword}'/></c:if>
                                <c:param name='size' value='${userPage.size}'/>
                                <c:param name='page' value='${pageNumber}'/>
                            </c:url>">${pageNumber}</a>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>
        </div>
    </c:if>
</div>

<div id="deleteModal" class="modal-overlay" style="display:none;">
    <div class="modal-box">
        <h3>Xác nhận xóa người dùng</h3>
        <p id="deleteModalText">Bạn có chắc chắn muốn xóa người dùng này không?</p>
        <form id="deleteModalForm" method="post" action="">
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary btn-inline" onclick="closeDeleteModal()">Hủy</button>
                <button type="submit" class="btn btn-danger btn-inline">Xóa ngay</button>
            </div>
        </form>
    </div>
</div>
<script>
    function openDeleteModal(btn) {
        var url = btn.getAttribute('data-url');
        var name = btn.getAttribute('data-name') || '';
        document.getElementById('deleteModalForm').action = url;
        document.getElementById('deleteModalText').textContent = 'Bạn có chắc chắn muốn xóa người dùng "' + name + '" không?';
        document.getElementById('deleteModal').style.display = 'flex';
    }
    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
    }
</script>
</body>
</html>
