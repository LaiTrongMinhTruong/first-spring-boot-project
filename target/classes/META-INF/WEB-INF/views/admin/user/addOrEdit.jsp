<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${isEdit ? 'Cập nhật Người dùng' : 'Thêm Người dùng mới'}</title>
</head>
<body>
<div class="card card-wide centered-card">
    <div class="card-header">
        <h1>${isEdit ? 'Cập nhật Người dùng' : 'Thêm Người dùng mới'}</h1>
        <p>Nhập thông tin tài khoản người dùng bên dưới</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error"><c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/users/saveOrUpdate" method="post">
        <c:if test="${userForm.id != null}">
            <input type="hidden" name="id" value="${userForm.id}" />
        </c:if>

        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username" value="<c:out value='${userForm.username}'/>"
                   placeholder="Ít nhất 3 ký tự" minlength="3" maxlength="50" required />
        </div>

        <div class="form-group">
            <label for="fullName">Họ và tên</label>
            <input type="text" id="fullName" name="fullName" value="<c:out value='${userForm.fullName}'/>"
                   placeholder="Nguyễn Văn A" maxlength="100" required />
        </div>

        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="<c:out value='${userForm.email}'/>"
                   placeholder="example@gmail.com" maxlength="100" required />
        </div>

        <div class="form-group">
            <label for="password">
                Mật khẩu
                <c:if test="${isEdit}"><small style="font-weight:400;color:#64748b;">(Để trống nếu giữ nguyên mật khẩu cũ)</small></c:if>
            </label>
            <input type="password" id="password" name="password"
                   placeholder="${isEdit ? 'Nhập mật khẩu mới nếu muốn đổi' : 'Ít nhất 6 ký tự'}"
                   ${isEdit ? '' : 'required minlength="6"'} />
        </div>

        <div class="form-group">
            <label for="role">Vai trò (Role)</label>
            <select id="role" name="role" class="form-select">
                <option value="USER" ${userForm.role == 'USER' || empty userForm.role ? 'selected' : ''}>USER (Người dùng)</option>
                <option value="ADMIN" ${userForm.role == 'ADMIN' ? 'selected' : ''}>ADMIN (Quản trị viên)</option>
            </select>
        </div>

        <div class="form-group">
            <label for="status">Trạng thái</label>
            <select id="status" name="status" class="form-select">
                <option value="1" ${userForm.status == 1 || userForm.status == null ? 'selected' : ''}>Hoạt động (1)</option>
                <option value="0" ${userForm.status == 0 ? 'selected' : ''}>Tạm khóa (0)</option>
            </select>
        </div>

        <button type="submit" class="btn btn-primary">${isEdit ? 'Lưu thay đổi' : 'Thêm mới'}</button>
        <a href="${pageContext.request.contextPath}/admin/users/searchpaginated" class="btn btn-secondary" style="margin-top: 10px;">
            Quay lại danh sách
        </a>
    </form>
</div>
</body>
</html>
