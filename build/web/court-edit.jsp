<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chỉnh sửa sân</title>
    <link rel="stylesheet" href="vendors/feather/feather.css">
    <link rel="stylesheet" href="vendors/ti-icons/css/themify-icons.css">
    <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
    <link rel="stylesheet" href="css/vertical-layout-light/style.css">
    <link rel="shortcut icon" href="images/favicon.png" />
</head>
<body>
    <div class="container-scroller">
        <jsp:include page="partials/_navbar.html" />
        <div class="container-fluid page-body-wrapper">
            <jsp:include page="partials/_settings-panel.html" />
            <jsp:include page="partials/_sidebar.html" />
            <div class="main-panel">
                <div class="content-wrapper">
                    <div class="row">
                        <div class="col-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Chỉnh sửa sân</h4>
                                    
                                    <c:if test="${not empty court}">
                                        <form action="court-manager" method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="courtId" value="${court.courtId}">
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="courtName">Tên sân *</label>
                                                        <input type="text" class="form-control" id="courtName" name="courtName" 
                                                               value="${court.courtName}" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="courtType">Loại sân *</label>
                                                        <select class="form-control" id="courtType" name="courtType" required>
                                                            <option value="">Chọn loại sân</option>
                                                            <option value="VIP" ${court.courtType == 'VIP' ? 'selected' : ''}>VIP</option>
                                                            <option value="Double" ${court.courtType == 'Double' ? 'selected' : ''}>Double</option>
                                                            <option value="Single" ${court.courtType == 'Single' ? 'selected' : ''}>Single</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="form-group">
                                                <label for="description">Mô tả</label>
                                                <textarea class="form-control" id="description" name="description" rows="3">${court.description}</textarea>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="status">Trạng thái</label>
                                                        <select class="form-control" id="status" name="status">
                                                            <option value="Active" ${court.status == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                                            <option value="Inactive" ${court.status == 'Inactive' ? 'selected' : ''}>Không hoạt động</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group">
                                                        <label for="courtImage">Hình ảnh</label>
                                                        <input type="text" class="form-control" id="courtImage" name="courtImage" 
                                                               value="${court.courtImage}" placeholder="URL hình ảnh">
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label>Người tạo</label>
                                                        <input type="text" class="form-control" value="${court.createdBy}" readonly>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label>Ngày tạo</label>
                                                        <input type="text" class="form-control" value="${court.createdAt}" readonly>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label>Ngày cập nhật cuối</label>
                                                        <input type="text" class="form-control" value="${court.updatedAt}" readonly>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <button type="submit" class="btn btn-primary mr-2">Cập nhật</button>
                                            <a href="court-manager" class="btn btn-light">Hủy</a>
                                        </form>
                                    </c:if>
                                    
                                    <c:if test="${empty court}">
                                        <div class="alert alert-danger">
                                            Không tìm thấy thông tin sân.
                                        </div>
                                        <a href="court-manager" class="btn btn-primary">Quay lại</a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="partials/_footer.html" />
            </div>
        </div>
    </div>
    
    <script src="vendors/js/vendor.bundle.base.js"></script>
    <script src="js/off-canvas.js"></script>
    <script src="js/hoverable-collapse.js"></script>
    <script src="js/template.js"></script>
    <script src="js/settings.js"></script>
    <script src="js/todolist.js"></script>
</body>
</html> 