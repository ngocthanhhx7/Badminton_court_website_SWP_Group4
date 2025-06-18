<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Quản lý Sân</title>
        <!-- base:css -->
        <link rel="stylesheet" href="vendors/typicons.font/font/typicons.css">
        <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
        <!-- endinject --> 
        <!-- plugin css for this page -->
        <!-- End plugin css for this page -->
        <!-- inject:css -->
        <link rel="stylesheet" href="css/vertical-layout-light/style.css">
        <!-- endinject -->
        <link rel="shortcut icon" href="img/favicon.png" />
        <style>
            .image-preview {
                max-width: 200px;
                max-height: 150px;
                margin-top: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .file-input-wrapper {
                position: relative;
                display: inline-block;
                cursor: pointer;
            }
            .file-input-wrapper input[type=file] {
                position: absolute;
                left: -9999px;
            }
            .file-input-wrapper .btn {
                margin-right: 10px;
            }
            .filter-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            .sort-header {
                cursor: pointer;
                user-select: none;
            }
            .sort-header:hover {
                background-color: #f8f9fa;
            }
            .sort-icon {
                margin-left: 5px;
                font-size: 12px;
            }
            .pagination-info {
                margin: 10px 0;
                color: #6c757d;
            }
            .search-box {
                max-width: 300px;
            }
        </style>
    </head>
    <body>
        <div class="container-scroller">
            <jsp:include page="header-manager.jsp" />
            <!-- partial -->
            <div class="main-panel">
                <div class="content-wrapper">
                    <div class="row">
                        <!-- User Table -->
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Quản lý Sân</h4>
                                    
                                    <!-- Success/Error Messages -->
                                    <c:if test="${not empty successMessage}">
                                        <div class="alert alert-success">${successMessage}</div>
                                    </c:if>
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger">${errorMessage}</div>
                                    </c:if>
                                    
                                    <!-- Filter and Search Section -->
                                    <form method="get" action="court-manager" class="row mb-3">
                                        <div class="col-md-4">
                                            <input type="text" class="form-control" name="search" placeholder="Tìm kiếm tên, loại, trạng thái..." value="${param.search}">
                                        </div>
                                        <div class="col-md-2">
                                            <select class="form-control" name="courtType">
                                                <option value="">Tất cả loại sân</option>
                                                <option value="VIP" ${courtType == 'VIP' ? 'selected' : ''}>VIP</option>
                                                <option value="Double" ${courtType == 'Double' ? 'selected' : ''}>Double</option>
                                                <option value="Single" ${courtType == 'Single' ? 'selected' : ''}>Single</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                                            <a href="court-manager" class="btn btn-secondary">Làm mới</a>
                                        </div>
                                        <div class="col-md-6 text-end">
                                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCourtModal">Thêm Sân</button>
                                        </div>
                                    </form>
                                    
                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Tên sân</th>
                                                    <th>Mô tả</th>
                                                    <th>Loại sân</th>
                                                    <th>Trạng thái</th>
                                                    <th>Hình ảnh</th>
                                                    <th>Người tạo</th>
                                                    <th>Ngày tạo</th>
                                                    <th>Ngày cập nhật</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="c" items="${courtList}">
                                                    <tr>
                                                        <td>${c.courtId}</td>
                                                        <td>${c.courtName}</td>
                                                        <td>${c.description}</td>
                                                        <td>${c.courtType}</td>
                                                        <td>
                                                            <form method="get" action="court-manager" style="display:inline">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="id" value="${c.courtId}">
                                                                <button type="submit" class="btn btn-link p-0 m-0 align-baseline" style="color: ${c.status == 'Active' ? '#28a745' : '#dc3545'}; text-decoration: underline;">
                                                                    ${c.status}
                                                                </button>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty c.courtImage}">
                                                                <img src="${c.courtImage}" alt="court image" style="max-width:80px;max-height:60px;">
                                                            </c:if>
                                                        </td>
                                                        <td>${c.createdBy}</td>
                                                        <td>
                                                            <c:if test="${not empty c.createdAt}">
                                                                ${c.createdAt}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty c.updatedAt}">
                                                                ${c.updatedAt}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <form method="get" action="court-manager" style="display:inline">
                                                                <input type="hidden" name="action" value="edit">
                                                                <input type="hidden" name="id" value="${c.courtId}">
                                                                <button type="submit" class="btn btn-warning btn-sm">Sửa</button>
                                                            </form>
                                                            <form method="get" action="court-manager" style="display:inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa sân này?');">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="id" value="${c.courtId}">
                                                                <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add User Modal -->
        <div class="modal fade" id="addCourtModal" tabindex="-1" aria-labelledby="addCourtModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form method="post" action="court-manager">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addCourtModalLabel">Thêm Sân</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label>Tên sân</label>
                                <input type="text" name="courtName" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Mô tả</label>
                                <input type="text" name="description" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="courtType">Loại sân *</label>
                                <select class="form-control" id="courtType" name="courtType" required>
                                    <option value="">Chọn loại sân</option>
                                    <option value="VIP">VIP</option>
                                    <option value="Double">Double</option>
                                    <option value="Single">Single</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label>Trạng thái</label>
                                <select name="status" class="form-control">
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label>Hình ảnh (URL)</label>
                                <input type="text" name="courtImage" class="form-control">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Thêm</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Edit User Modal -->
        <c:if test="${not empty editCourt}">
            <div class="modal fade show" id="editCourtModal" tabindex="-1" aria-labelledby="editCourtModalLabel" aria-modal="true" style="display:block; background:rgba(0,0,0,0.5);">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form method="post" action="court-manager">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${editCourt.courtId}">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editCourtModalLabel">Sửa Sân</h5>
                                <a href="court-manager" class="btn-close" aria-label="Close"></a>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label>Tên sân</label>
                                    <input type="text" name="courtName" class="form-control" value="${editCourt.courtName}" required>
                                </div>
                                <div class="mb-3">
                                    <label>Mô tả</label>
                                    <input type="text" name="description" class="form-control" value="${editCourt.description}">
                                </div>
                                <div class="mb-3">
                                    <label>Loại sân</label>
                                    <select name="courtType" class="form-control">
                                        <option value="">Chọn loại sân</option>
                                        <option value="VIP" ${editCourt.courtType == 'VIP' ? 'selected' : ''}>VIP</option>
                                        <option value="Double" ${editCourt.courtType == 'Double' ? 'selected' : ''}>Double</option>
                                        <option value="Single" ${editCourt.courtType == 'Single' ? 'selected' : ''}>Single</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label>Trạng thái</label>
                                    <select name="status" class="form-control">
                                        <option value="Active" ${editCourt.status == 'Active' ? 'selected' : ''}>Active</option>
                                        <option value="Inactive" ${editCourt.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label>Hình ảnh (URL)</label>
                                    <input type="text" name="courtImage" class="form-control" value="${editCourt.courtImage}">
                                </div>
                            </div>
                            <div class="modal-footer">
                                <a href="court-manager" class="btn btn-secondary">Đóng</a>
                                <button type="submit" class="btn btn-primary">Cập nhật</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <script>
                // Tự động mở modal khi có editUser
                document.addEventListener('DOMContentLoaded', function() {
                    var modal = document.getElementById('editCourtModal');
                    if (modal) {
                        modal.classList.add('show');
                        modal.style.display = 'block';
                    }
                });
            </script>
        </c:if>
        
        <!-- content-wrapper ends -->
    </div>
    <!-- main-panel ends -->
</div>
<!-- base:js -->
<script src="vendors/js/vendor.bundle.base.js"></script>
<!-- endinject -->
<!-- Plugin js for this page-->
<!-- End plugin js for this page-->
<!-- inject:js -->
<script src="js/off-canvas.js"></script>
<script src="js/hoverable-collapse.js"></script>
<script src="js/template.js"></script>
<script src="js/settings.js"></script>
<script src="js/todolist.js"></script>
<!-- endinject -->
<!-- plugin js for this page -->
<script src="vendors/progressbar.js/progressbar.min.js"></script>
<script src="vendors/chart.js/Chart.min.js"></script>
<!-- End plugin js for this page -->
<!-- Custom js for this page-->
<script src="js/dashboard.js"></script>
<!-- End custom js for this page-->

<script>
// Auto-hide alerts after 5 seconds
$(document).ready(function() {
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
});
</script>
</body>
</html>