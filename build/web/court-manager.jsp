<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Court Manager</title>
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
            .court-image {
                max-width: 80px;
                max-height: 60px;
                border-radius: 4px;
            }
            .description-cell {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .description-cell:hover {
                white-space: normal;
                word-wrap: break-word;
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
                        <!-- Court Table -->
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Quản lý Sân</h4>
                                    
                                    <!-- Success/Error Messages -->
                                    <c:if test="${not empty successMessage}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            ${successMessage}
                                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            ${errorMessage}
                                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Filter and Search Section -->
                                    <div class="filter-section">
                                        <form method="get" action="court-manager" class="row">
                                            <div class="col-md-3">
                                                <label for="searchName">Tìm kiếm theo tên:</label>
                                                <input type="text" class="form-control search-box" id="searchName" name="searchName" 
                                                       value="${searchName}" placeholder="Nhập tên sân...">
                                            </div>
                                            <div class="col-md-2">
                                                <label for="statusFilter">Lọc theo trạng thái:</label>
                                                <select class="form-control" id="statusFilter" name="statusFilter">
                                                    <option value="">Tất cả</option>
                                                    <option value="Available" ${statusFilter == 'Available' ? 'selected' : ''}>Hoạt động</option>
                                                    <option value="Unavailable" ${statusFilter == 'Unavailable' ? 'selected' : ''}>Không hoạt động</option>
                                                    <option value="Maintenance" ${statusFilter == 'Maintenance' ? 'selected' : ''}>Bảo trì</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <label for="courtTypeFilter">Lọc theo loại sân:</label>
                                                <select class="form-control" id="courtTypeFilter" name="courtTypeFilter">
                                                    <option value="">Tất cả</option>
                                                    <option value="VIP" ${courtTypeFilter == 'VIP' ? 'selected' : ''}>VIP</option>
                                                    <option value="Double" ${courtTypeFilter == 'Double' ? 'selected' : ''}>Double</option>
                                                    <option value="Single" ${courtTypeFilter == 'Single' ? 'selected' : ''}>Single</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <label for="pageSize">Số lượng hiển thị:</label>
                                                <select class="form-control" id="pageSize" name="pageSize">
                                                    <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                                    <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                                    <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label>&nbsp;</label>
                                                <div>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="typcn typcn-zoom"></i> Tìm kiếm
                                                    </button>
                                                    <a href="court-manager" class="btn btn-secondary">
                                                        <i class="typcn typcn-refresh"></i> Làm mới
                                                    </a>
                                                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addCourtModal">
                                                        <i class="typcn typcn-plus"></i> Thêm sân
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <!-- Pagination Info -->
                                    <div class="pagination-info">
                                        Hiển thị ${startRecord} - ${endRecord} của ${totalCourts} sân
                                        <c:if test="${not empty searchName or not empty statusFilter or not empty courtTypeFilter}">
                                            (đã lọc)
                                        </c:if>
                                    </div>
                                    
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th class="sort-header" onclick="sortTable('CourtID')">
                                                        ID
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'CourtID' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'CourtID' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th class="sort-header" onclick="sortTable('CourtName')">
                                                        Tên sân
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'CourtName' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'CourtName' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th class="sort-header" onclick="sortTable('CourtType')">
                                                        Loại sân
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'CourtType' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'CourtType' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th>Mô tả</th>
                                                    <th>Hình ảnh</th>
                                                    <th class="sort-header" onclick="sortTable('Status')">
                                                        Trạng thái
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'Status' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'Status' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th>Người tạo</th>
                                                    <th class="sort-header" onclick="sortTable('CreatedAt')">
                                                        Ngày tạo
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'CreatedAt' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'CreatedAt' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="court" items="${courts}">
                                                    <tr>
                                                        <td>${court.courtId}</td>
                                                        <td>${court.courtName}</td>
                                                        <td>
                                                            <span class="badge badge-${court.courtType == 'VIP' ? 'danger' : court.courtType == 'Double' ? 'warning' : 'info'}">
                                                                ${court.courtType}
                                                            </span>
                                                        </td>
                                                        <td class="description-cell" title="${court.description}">
                                                            <c:if test="${not empty court.description}">
                                                                ${court.description}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty court.courtImage}">
                                                                <img src="${court.courtImage}" alt="Court Image" class="court-image">
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <form method="post" action="court-manager" style="display:inline">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="courtId" value="${court.courtId}">
                                                                <button type="submit" class="btn btn-link p-0 m-0 align-baseline" 
                                                                        style="color: ${court.status == 'Available' ? '#28a745' : (court.status == 'Unavailable' ? '#dc3545' : '#ffc107')}; text-decoration: underline;">
                                                                    ${court.status == 'Available' ? 'Hoạt động' : (court.status == 'Unavailable' ? 'Không hoạt động' : 'Bảo trì')}
                                                                </button>
                                                            </form>
                                                        </td>
                                                        <td>${court.createdBy}</td>
                                                        <td>
                                                            <c:if test="${not empty court.createdAt}">
                                                                ${court.createdAt}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-warning btn-sm" 
                                                                    onclick="editCourt(${court.courtId}, '${court.courtName}', '${court.courtType}', '${court.description}', '${court.status}', '${court.courtImage}')">
                                                                <i class="typcn typcn-edit"></i> Sửa
                                                            </button>
                                                            <button type="button" class="btn btn-danger btn-sm" 
                                                                    onclick="deleteCourt(${court.courtId}, '${court.courtName}')">
                                                                <i class="typcn typcn-delete"></i> Xóa
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <nav aria-label="Court pagination">
                                            <ul class="pagination justify-content-center">
                                                <!-- Previous page -->
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="court-manager?page=${currentPage - 1}&pageSize=${pageSize}&searchName=${searchName}&statusFilter=${statusFilter}&courtTypeFilter=${courtTypeFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                                        <i class="typcn typcn-chevron-left"></i>
                                                    </a>
                                                </li>
                                                
                                                <!-- Page numbers -->
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <c:choose>
                                                        <c:when test="${i == currentPage}">
                                                            <li class="page-item active">
                                                                <span class="page-link">${i}</span>
                                                            </li>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <li class="page-item">
                                                                <a class="page-link" href="court-manager?page=${i}&pageSize=${pageSize}&searchName=${searchName}&statusFilter=${statusFilter}&courtTypeFilter=${courtTypeFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                                                    ${i}
                                                                </a>
                                                            </li>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                
                                                <!-- Next page -->
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="court-manager?page=${currentPage + 1}&pageSize=${pageSize}&searchName=${searchName}&statusFilter=${statusFilter}&courtTypeFilter=${courtTypeFilter}&sortBy=${sortBy}&sortOrder=${sortOrder}">
                                                        <i class="typcn typcn-chevron-right"></i>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                    
                                    <c:if test="${empty courts}">
                                        <div class="text-center mt-4">
                                            <p class="text-muted">Không có dữ liệu sân nào.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add Court Modal -->
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
                                <label for="courtName" class="form-label">Tên sân *</label>
                                <input type="text" class="form-control" id="courtName" name="courtName" required>
                            </div>
                            <div class="mb-3">
                                <label for="courtType" class="form-label">Loại sân *</label>
                                <select class="form-control" id="courtType" name="courtType" required>
                                    <option value="">Chọn loại sân</option>
                                    <option value="VIP">VIP</option>
                                    <option value="Double">Double</option>
                                    <option value="Single">Single</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="description" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="status" class="form-label">Trạng thái</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="Available">Hoạt động</option>
                                    <option value="Unavailable">Không hoạt động</option>
                                    <option value="Maintenance">Bảo trì</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="courtImage" class="form-label">Hình ảnh (URL)</label>
                                <input type="text" class="form-control" id="courtImage" name="courtImage" placeholder="Nhập URL hình ảnh">
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
        
        <!-- Edit Court Modal -->
        <div class="modal fade" id="editCourtModal" tabindex="-1" aria-labelledby="editCourtModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form method="post" action="court-manager">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="courtId" id="editCourtId">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editCourtModalLabel">Sửa Sân</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="editCourtName" class="form-label">Tên sân *</label>
                                <input type="text" class="form-control" id="editCourtName" name="courtName" required>
                            </div>
                            <div class="mb-3">
                                <label for="editCourtType" class="form-label">Loại sân *</label>
                                <select class="form-control" id="editCourtType" name="courtType" required>
                                    <option value="">Chọn loại sân</option>
                                    <option value="VIP">VIP</option>
                                    <option value="Double">Double</option>
                                    <option value="Single">Single</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editDescription" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="editDescription" name="description" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="editStatus" class="form-label">Trạng thái</label>
                                <select class="form-control" id="editStatus" name="status">
                                    <option value="Available">Hoạt động</option>
                                    <option value="Unavailable">Không hoạt động</option>
                                    <option value="Maintenance">Bảo trì</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="editCourtImage" class="form-label">Hình ảnh (URL)</label>
                                <input type="text" class="form-control" id="editCourtImage" name="courtImage" placeholder="Nhập URL hình ảnh">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteCourtModal" tabindex="-1" aria-labelledby="deleteCourtModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteCourtModalLabel">Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa sân "<span id="deleteCourtName"></span>"?</p>
                        <p class="text-danger">Hành động này không thể hoàn tác!</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <form method="post" action="court-manager" style="display:inline">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="courtId" id="deleteCourtId">
                            <button type="submit" class="btn btn-danger">Xóa</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
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

// Sort table function
function sortTable(sortBy) {
    const urlParams = new URLSearchParams(window.location.search);
    let currentSortOrder = urlParams.get('sortOrder') || 'DESC';
    
    if (urlParams.get('sortBy') === sortBy) {
        currentSortOrder = currentSortOrder === 'ASC' ? 'DESC' : 'ASC';
    } else {
        currentSortOrder = 'ASC';
    }
    
    urlParams.set('sortBy', sortBy);
    urlParams.set('sortOrder', currentSortOrder);
    urlParams.set('page', '1'); // Reset to first page when sorting
    
    window.location.href = 'court-manager?' + urlParams.toString();
}

// Edit court function
function editCourt(courtId, courtName, courtType, description, status, courtImage) {
    document.getElementById('editCourtId').value = courtId;
    document.getElementById('editCourtName').value = courtName;
    document.getElementById('editCourtType').value = courtType;
    document.getElementById('editDescription').value = description || '';
    document.getElementById('editStatus').value = status;
    document.getElementById('editCourtImage').value = courtImage || '';
    
    new bootstrap.Modal(document.getElementById('editCourtModal')).show();
}

// Delete court function
function deleteCourt(courtId, courtName) {
    document.getElementById('deleteCourtId').value = courtId;
    document.getElementById('deleteCourtName').textContent = courtName;
    
    new bootstrap.Modal(document.getElementById('deleteCourtModal')).show();
}
</script>
</body>
</html> 