<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Cập nhật Danh mục' : 'Thêm Danh mục mới'}</title>
</head>
<body>
<div class="card card-wide centered-card">
    <div class="card-header">
        <h1>${isEdit ? 'Cập nhật Danh mục' : 'Thêm Danh mục mới'}</h1>
        <p>Nhập thông tin danh mục bên dưới</p>
    </div>

    <form action="${pageContext.request.contextPath}/admin/categories/saveOrUpdate" method="post">
        <c:if test="${category.id != null}">
            <input type="hidden" name="id" value="${category.id}" />
        </c:if>

        <div class="form-group">
            <label for="name">Tên danh mục</label>
            <input type="text" id="name" name="name" value="<c:out value='${category.name}'/>"
                   placeholder="Ví dụ: Điện thoại" required />
        </div>

        <div class="form-group">
            <label for="images">Hình ảnh (tên file hoặc URL)</label>
            <input type="text" id="images" name="images" value="<c:out value='${category.images}'/>"
                   placeholder="Ví dụ: phone.png" />
        </div>

        <div class="form-group">
            <label for="status">Trạng thái</label>
            <select id="status" name="status" class="form-select">
                <option value="1" ${category.status == 1 || category.status == null ? 'selected' : ''}>Hoạt động (1)</option>
                <option value="0" ${category.status == 0 ? 'selected' : ''}>Tạm khóa (0)</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">${isEdit ? 'Lưu thay đổi' : 'Thêm mới'}</button>
        <a href="${pageContext.request.contextPath}/admin/categories/searchpaginated" class="btn btn-secondary" style="margin-top: 10px;">
            Quay lại danh sách
        </a>
    </form>
</div>
</body>
</html>
