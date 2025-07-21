<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Service Manager</title>
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
                        <!-- Service Table -->
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Quản lý Service</h4>

                                    <!-- Success/Error Messages -->
                                    <c:if test="${not empty successMessage}">
                                        <div class="alert alert-success">${successMessage}</div>
                                    </c:if>
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger">${errorMessage}</div>
                                    </c:if>

                                    <!-- Filter and Search Section -->
                                    <form method="get" action="service-manager" class="row mb-3">
                                        <div class="col-md-4">
                                            <input type="text" class="form-control" name="search" placeholder="Tìm kiếm tên,loại..." value="${param.search}">
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                                            <a href="service-manager" class="btn btn-secondary">Làm mới</a>
                                        </div>
                                        <div class="col-md-6 text-end">
                                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addServiceModal">Thêm Service</button>
                                        </div>
                                    </form>

                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>STT</th>
                                                    <th>Service Name</th>
                                                    <th>Service Type</th>
                                                    <th>Description</th>
                                                    <th>Unit</th>
                                                    <th>Price</th>
                                                    <th>Status</th>

                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="s" items="${serviceList}">
                                                    <tr>
                                                        <td>${s.serviceID}</td>
                                                        <td>${s.serviceName}</td>
                                                        <td>${s.serviceType}</td>
                                                        <td>${s.description}</td>
                                                        <td>${s.unit}</td>
                                                        <td>
                                                            <c:if test="${not empty s.price}">
                                                                ${s.price}
                                                            </c:if>
                                                        </td>

                                                        <td>${s.status}</td>

                                                        <td>
                                                            <form method="get" action="service-manager" style="display:inline">
                                                                <input type="hidden" name="action" value="edit">
                                                                <input type="hidden" name="id" value="${s.serviceID}">
                                                                <button type="submit" class="btn btn-warning btn-sm">Sửa</button>
                                                            </form>
                                                            <form method="get" action="service-manager" style="display:inline">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="id" value="${s.serviceID}">
                                                                <button type="submit" class="btn btn-${s.status == 'Active' ? 'secondary' : 'success'} btn-sm">
                                                                    ${s.status == 'Active' ? 'Vô hiệu hóa' : 'Kích hoạt'}
                                                                </button>
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

        <!-- Add Service Modal -->
        <div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form method="post" action="service-manager">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-header">
                            <h5 class="modal-title" id="addServiceModalLabel">Thêm Service</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label>Service Name</label>
                                <input type="text" name="servicename" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Service Type</label>
                                <input type="text" name="servicetype" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Description</label>
                                <input type="text" name="description" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label>Unit</label>
                                <input type="text" name="unit" class="form-control">
                            </div>
                            <div class="mb-3">
                                <label>Price</label>
                                <input type="number" step="1000" min="1000" name="price" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
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


        <!-- Edit Service Modal -->
<c:if test="${not empty editUser}">
    <div class="modal fade show" id="editServiceModal" tabindex="-1" aria-labelledby="editServiceModalLabel" aria-modal="true" style="display:block; background:rgba(0,0,0,0.5);">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="service-manager">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${editUser.serviceID}">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editServiceModalLabel">Sửa Service</h5>
                        <a href="service-manager" class="btn-close" aria-label="Close"></a>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label>Service Name</label>
                            <input type="text" name="servicename" class="form-control" value="${editUser.serviceName}" required>
                        </div>
                        <div class="mb-3">
                            <label>Service Type</label>
                            <input type="text" name="servicetype" class="form-control" value="${editUser.serviceType}" required>
                        </div>
                        <div class="mb-3">
                            <label>Description</label>
                            <input type="text" name="description" class="form-control" value="${editUser.description}">
                        </div>
                        <div class="mb-3">
                            <label>Unit</label>
                            <input type="text" name="unit" class="form-control" value="${editUser.unit}">
                        </div>
                        <div class="mb-3">
                            <label>Price</label>
                            <input type="number" step="0.01" min="0" name="price" class="form-control" value="${editUser.price}" required>
                        </div>
                        <div class="mb-3">
                            <label>Status</label>
                            <select name="status" class="form-control">
                                <option value="Active" ${editUser.status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${editUser.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="service-manager" class="btn btn-secondary">Đóng</a>
                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
            <script>
                // Tự động mở modal khi có editUser
                document.addEventListener('DOMContentLoaded', function () {
                    var modal = document.getElementById('editServiceModal');
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
                $(document).ready(function () {
                    setTimeout(function () {
                        $('.alert').fadeOut('slow');
                    }, 5000);
                });
</script>
</body>
</html>