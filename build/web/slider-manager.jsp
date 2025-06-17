<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>CelestialUI Admin</title>
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
                        <!-- Slider Table -->
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Quản lý Slider</h4>
                                    
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
                                        <form method="get" action="slider-manager" class="row">
                                            <div class="col-md-3">
                                                <label for="searchTitle">Tìm kiếm theo tiêu đề:</label>
                                                <input type="text" class="form-control search-box" id="searchTitle" name="searchTitle" 
                                                       value="${searchTitle}" placeholder="Nhập tiêu đề...">
                                            </div>
                                            <div class="col-md-3">
                                                <label for="statusFilter">Lọc theo trạng thái:</label>
                                                <select class="form-control" id="statusFilter" name="statusFilter">
                                                    <option value="">Tất cả</option>
                                                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
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
                                            <div class="col-md-4">
                                                <label>&nbsp;</label>
                                                <div>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="typcn typcn-zoom"></i> Tìm kiếm
                                                    </button>
                                                    <a href="slider-manager" class="btn btn-secondary">
                                                        <i class="typcn typcn-refresh"></i> Làm mới
                                                    </a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <!-- Pagination Info -->
                                    <div class="pagination-info">
                                        Hiển thị ${startRecord} - ${endRecord} của ${totalSliders} slider
                                        <c:if test="${not empty searchTitle or not empty statusFilter}">
                                            (đã lọc)
                                        </c:if>
                                    </div>
                                    
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th class="sort-header" onclick="sortTable('SliderID')">
                                                        ID
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'SliderID' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'SliderID' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th class="sort-header" onclick="sortTable('Title')">
                                                        Tiêu đề
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'Title' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'Title' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th>Subtitle</th>
                                                    <th>Ảnh nền</th>
                                                    <th class="sort-header" onclick="sortTable('Position')">
                                                        Vị trí
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'Position' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'Position' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th class="sort-header" onclick="sortTable('IsActive')">
                                                        Trạng thái
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'IsActive' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'IsActive' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="slider" items="${sliders}">
                                                    <tr>
                                                        <td>${slider.sliderID}</td>
                                                        <td>${slider.title}</td>
                                                        <td>${slider.subtitle}</td>
                                                        <td><img src="${slider.backgroundImage.startsWith('http') ? slider.backgroundImage : pageContext.request.contextPath.concat(slider.backgroundImage)}" width="80"/></td>
                                                        <td>${slider.position}</td>
                                                        <td>
                                                            <form method="post" action="slider-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="sliderID" value="${slider.sliderID}">
                                                                <c:choose>
                                                                    <c:when test="${slider.isActive}">
                                                                        <button type="submit" class="badge badge-success" onclick="return confirm('Bạn có muốn ẩn slider này?')">Hoạt động</button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="submit" class="badge badge-danger" onclick="return confirm('Bạn có muốn hiện slider này?')">Không hoạt động</button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-warning btn-sm edit-slider-btn" 
                                                                    data-slider-id="${slider.sliderID}" 
                                                                    data-title="${slider.title}" 
                                                                    data-subtitle="${slider.subtitle}"
                                                                    data-background-image="${slider.backgroundImage}"
                                                                    data-position="${slider.position}">Sửa</button>
                                                            <form method="post" action="slider-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="sliderID" value="${slider.sliderID}">
                                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa slider này?')">Xóa</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        
                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <nav aria-label="Slider pagination">
                                                <ul class="pagination justify-content-center">
                                                    <!-- Previous button -->
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="javascript:void(0)" onclick="goToPage(${currentPage - 1})" ${currentPage == 1 ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                                            <i class="typcn typcn-chevron-left"></i> Trước
                                                        </a>
                                                    </li>
                                                    
                                                    <!-- Page numbers -->
                                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                        <c:choose>
                                                            <c:when test="${pageNum == currentPage}">
                                                                <li class="page-item active">
                                                                    <span class="page-link">${pageNum}</span>
                                                                </li>
                                                            </c:when>
                                                            <c:when test="${pageNum <= 3 or pageNum > totalPages - 2 or (pageNum >= currentPage - 1 and pageNum <= currentPage + 1)}">
                                                                <li class="page-item">
                                                                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(${pageNum})">${pageNum}</a>
                                                                </li>
                                                            </c:when>
                                                            <c:when test="${pageNum == 4 and currentPage > 5}">
                                                                <li class="page-item disabled">
                                                                    <span class="page-link">...</span>
                                                                </li>
                                                            </c:when>
                                                            <c:when test="${pageNum == totalPages - 3 and currentPage < totalPages - 4}">
                                                                <li class="page-item disabled">
                                                                    <span class="page-link">...</span>
                                                                </li>
                                                            </c:when>
                                                        </c:choose>
                                                    </c:forEach>
                                                    
                                                    <!-- Next button -->
                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" href="javascript:void(0)" onclick="goToPage(${currentPage + 1})" ${currentPage == totalPages ? 'tabindex="-1" aria-disabled="true"' : ''}>
                                                            Sau <i class="typcn typcn-chevron-right"></i>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </c:if>
                                        
                                        <button class="btn btn-primary mt-2" data-toggle="modal" data-target="#addSliderModal">Thêm mới Slider</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add Slider Modal -->
        <div class="modal fade" id="addSliderModal" tabindex="-1" role="dialog" aria-labelledby="addSliderModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addSliderModalLabel">Thêm Slider Mới</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="slider-manager" enctype="multipart/form-data">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">
                            <div class="form-group">
                                <label for="title">Tiêu đề</label>
                                <input type="text" class="form-control" id="title" name="title" required>
                            </div>
                            <div class="form-group">
                                <label for="subtitle">Subtitle</label>
                                <textarea class="form-control" id="subtitle" name="subtitle" rows="2" required></textarea>
                            </div>
                            <div class="form-group">
                                <label>Ảnh nền</label>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="file-input-wrapper">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('backgroundImageFile').click()">
                                                <i class="typcn typcn-upload"></i> Chọn ảnh
                                            </button>
                                            <input type="file" id="backgroundImageFile" name="backgroundImageFile" accept="image/*" style="display: none;" onchange="previewImage(this, 'addImagePreview')">
                                        </div>
                                        <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                    </div>
                                    <div class="col-md-6">
                                        <img id="addImagePreview" class="image-preview" style="display: none;">
                                    </div>
                                </div>
                                <input type="text" class="form-control mt-2" id="backgroundImage" name="backgroundImage" placeholder="VD: /img/carousel/banner_1.jpg hoặc URL">
                            </div>
                            <div class="form-group">
                                <label for="position">Vị trí</label>
                                <input type="number" class="form-control" id="position" name="position" min="1" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Thêm</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- Edit Slider Modal -->
        <div class="modal fade" id="editSliderModal" tabindex="-1" role="dialog" aria-labelledby="editSliderModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editSliderModalLabel">Sửa Slider</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="slider-manager" enctype="multipart/form-data">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" id="editSliderID" name="sliderID">
                            <div class="form-group">
                                <label for="editTitle">Tiêu đề</label>
                                <input type="text" class="form-control" id="editTitle" name="title" required>
                            </div>
                            <div class="form-group">
                                <label for="editSubtitle">Subtitle</label>
                                <textarea class="form-control" id="editSubtitle" name="subtitle" rows="2" required></textarea>
                            </div>
                            <div class="form-group">
                                <label>Ảnh nền</label>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="file-input-wrapper">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('editBackgroundImageFile').click()">
                                                <i class="typcn typcn-upload"></i> Chọn ảnh
                                            </button>
                                            <input type="file" id="editBackgroundImageFile" name="backgroundImageFile" accept="image/*" style="display: none;" onchange="previewImage(this, 'editImagePreview')">
                                        </div>
                                        <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                    </div>
                                    <div class="col-md-6">
                                        <img id="editImagePreview" class="image-preview" style="display: none;">
                                        <img id="editCurrentImage" class="image-preview" style="display: none;">
                                    </div>
                                </div>
                                <input type="text" class="form-control mt-2" id="editBackgroundImage" name="backgroundImage" placeholder="VD: /img/carousel/banner_1.jpg hoặc URL">
                            </div>
                            <div class="form-group">
                                <label for="editPosition">Vị trí</label>
                                <input type="number" class="form-control" id="editPosition" name="position" min="1" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
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
    
    // Add event listener for edit buttons
    $(document).on('click', '.edit-slider-btn', function() {
        var sliderId = $(this).data('slider-id');
        var title = $(this).data('title');
        var subtitle = $(this).data('subtitle');
        var backgroundImage = $(this).data('background-image');
        var position = $(this).data('position');
        
        console.log('DEBUG: Edit button clicked');
        console.log('DEBUG: sliderId:', sliderId);
        console.log('DEBUG: title:', title);
        console.log('DEBUG: subtitle:', subtitle);
        console.log('DEBUG: backgroundImage:', backgroundImage);
        console.log('DEBUG: position:', position);
        
        document.getElementById('editSliderID').value = sliderId;
        document.getElementById('editTitle').value = title;
        document.getElementById('editSubtitle').value = subtitle;
        document.getElementById('editBackgroundImage').value = backgroundImage;
        document.getElementById('editPosition').value = position;
        
        // Show current image preview
        var currentImage = document.getElementById('editCurrentImage');
        var imagePreview = document.getElementById('editImagePreview');
        if (backgroundImage && backgroundImage.trim() !== '') {
            currentImage.src = backgroundImage.startsWith('http') ? backgroundImage : window.location.origin + backgroundImage;
            currentImage.style.display = 'block';
            imagePreview.style.display = 'none';
        } else {
            currentImage.style.display = 'none';
        }
        
        console.log('DEBUG: Form values set, opening modal');
        $('#editSliderModal').modal('show');
    });
    
    // Debug: Log form submissions
    $('form').on('submit', function() {
        console.log('DEBUG: Form submitted:', $(this).serialize());
    });
});

// Function to preview uploaded image
function previewImage(input, previewId) {
    var preview = document.getElementById(previewId);
    var currentImage = document.getElementById('editCurrentImage');
    
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
            if (currentImage) {
                currentImage.style.display = 'none';
            }
        };
        
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.style.display = 'none';
        if (currentImage) {
            currentImage.style.display = 'block';
        }
    }
}

// Function to sort table
function sortTable(sortBy) {
    var currentSortBy = '${sortBy}';
    var currentSortOrder = '${sortOrder}';
    var newSortOrder = (currentSortBy === sortBy && currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
    
    var url = new URL(window.location);
    url.searchParams.set('sortBy', sortBy);
    url.searchParams.set('sortOrder', newSortOrder);
    
    // Preserve other parameters
    if ('${searchTitle}') {
        url.searchParams.set('searchTitle', '${searchTitle}');
    }
    if ('${statusFilter}') {
        url.searchParams.set('statusFilter', '${statusFilter}');
    }
    if ('${pageSize}') {
        url.searchParams.set('pageSize', '${pageSize}');
    }
    
    window.location.href = url.toString();
}

// Function to go to specific page
function goToPage(page) {
    if (page < 1 || page > ${totalPages}) {
        return;
    }
    
    var url = new URL(window.location);
    url.searchParams.set('page', page);
    
    // Preserve other parameters
    if ('${searchTitle}') {
        url.searchParams.set('searchTitle', '${searchTitle}');
    }
    if ('${statusFilter}') {
        url.searchParams.set('statusFilter', '${statusFilter}');
    }
    if ('${pageSize}') {
        url.searchParams.set('pageSize', '${pageSize}');
    }
    if ('${sortBy}') {
        url.searchParams.set('sortBy', '${sortBy}');
    }
    if ('${sortOrder}') {
        url.searchParams.set('sortOrder', '${sortOrder}');
    }
    
    window.location.href = url.toString();
}
</script>
</body>
</html>