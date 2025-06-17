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
                max-width: 150px;
                max-height: 100px;
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
            .description-preview {
                max-width: 300px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .vip-badge {
                background: linear-gradient(45deg, #ffd700, #ffed4e);
                color: #000;
                font-weight: bold;
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
                        <!-- Offer Table -->
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Quản lý Offers</h4>
                                    
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
                                        <form method="get" action="offer-manager" class="row">
                                            <div class="col-md-3">
                                                <label for="searchTitle">Tìm kiếm theo tiêu đề:</label>
                                                <input type="text" class="form-control search-box" id="searchTitle" name="searchTitle" 
                                                       value="${searchTitle}" placeholder="Nhập tiêu đề...">
                                            </div>
                                            <div class="col-md-2">
                                                <label for="statusFilter">Lọc theo trạng thái:</label>
                                                <select class="form-control" id="statusFilter" name="statusFilter">
                                                    <option value="">Tất cả</option>
                                                    <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <label for="vipFilter">Loại offer:</label>
                                                <select class="form-control" id="vipFilter" name="vipFilter">
                                                    <option value="">Tất cả</option>
                                                    <option value="vip" ${vipFilter == 'vip' ? 'selected' : ''}>VIP</option>
                                                    <option value="normal" ${vipFilter == 'normal' ? 'selected' : ''}>Thường</option>
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
                                                    <a href="offer-manager" class="btn btn-secondary">
                                                        <i class="typcn typcn-refresh"></i> Làm mới
                                                    </a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <!-- Pagination Info -->
                                    <div class="pagination-info">
                                        Hiển thị ${startRecord} - ${endRecord} của ${totalOffers} offer
                                        <c:if test="${not empty searchTitle or not empty statusFilter or not empty vipFilter}">
                                            (đã lọc)
                                        </c:if>
                                    </div>
                                    
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th class="sort-header" onclick="sortTable('OfferID')">
                                                        ID
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'OfferID' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'OfferID' and sortOrder == 'DESC'}">
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
                                                    <th>Mô tả</th>
                                                    <th>Ảnh</th>
                                                    <th class="sort-header" onclick="sortTable('Capacity')">
                                                        Sức chứa
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'Capacity' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'Capacity' and sortOrder == 'DESC'}">
                                                                <i class="typcn typcn-arrow-sorted-down sort-icon"></i>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="typcn typcn-arrow-unsorted sort-icon"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </th>
                                                    <th class="sort-header" onclick="sortTable('IsVIP')">
                                                        Loại
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'IsVIP' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'IsVIP' and sortOrder == 'DESC'}">
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
                                                <c:forEach var="offer" items="${offers}">
                                                    <tr>
                                                        <td>${offer.offerID}</td>
                                                        <td>${offer.title}</td>
                                                        <td>${offer.subtitle}</td>
                                                        <td>
                                                            <div class="description-preview" title="${offer.description}">
                                                                ${offer.description}
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty offer.imageUrl}">
                                                                <img src="${offer.imageUrl.startsWith('http') ? offer.imageUrl : pageContext.request.contextPath.concat(offer.imageUrl)}" class="image-preview"/>
                                                            </c:if>
                                                        </td>
                                                        <td>${offer.capacity}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${offer.isVIP}">
                                                                    <span class="badge vip-badge">VIP</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-secondary">Thường</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <form method="post" action="offer-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="offerID" value="${offer.offerID}">
                                                                <c:choose>
                                                                    <c:when test="${offer.isActive}">
                                                                        <button type="submit" class="badge badge-success" onclick="return confirm('Bạn có muốn ẩn offer này?')">Hoạt động</button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="submit" class="badge badge-danger" onclick="return confirm('Bạn có muốn hiện offer này?')">Không hoạt động</button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-warning btn-sm edit-offer-btn" 
                                                                    data-offer-id="${offer.offerID}" 
                                                                    data-title="${offer.title}" 
                                                                    data-subtitle="${offer.subtitle}"
                                                                    data-description="${offer.description}"
                                                                    data-image-url="${offer.imageUrl}"
                                                                    data-capacity="${offer.capacity}"
                                                                    data-is-vip="${offer.isVIP}">Sửa</button>
                                                            <form method="post" action="offer-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="offerID" value="${offer.offerID}">
                                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa offer này?')">Xóa</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        
                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <nav aria-label="Offer pagination">
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
                                        
                                        <button class="btn btn-primary mt-2" data-toggle="modal" data-target="#addOfferModal">Thêm mới Offer</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add Offer Modal -->
        <div class="modal fade" id="addOfferModal" tabindex="-1" role="dialog" aria-labelledby="addOfferModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addOfferModalLabel">Thêm Offer Mới</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="offer-manager" enctype="multipart/form-data">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="title">Tiêu đề *</label>
                                        <input type="text" class="form-control" id="title" name="title" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="capacity">Sức chứa *</label>
                                        <input type="number" class="form-control" id="capacity" name="capacity" min="1" required>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="subtitle">Subtitle</label>
                                <input type="text" class="form-control" id="subtitle" name="subtitle">
                            </div>
                            <div class="form-group">
                                <label for="description">Mô tả *</label>
                                <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" class="custom-control-input" id="isVIP" name="isVIP">
                                    <label class="custom-control-label" for="isVIP">Offer VIP</label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Ảnh</label>
                                <div class="file-input-wrapper">
                                    <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('imageFile').click()">
                                        <i class="typcn typcn-upload"></i> Chọn ảnh
                                    </button>
                                    <input type="file" id="imageFile" name="imageFile" accept="image/*" style="display: none;" onchange="previewImage(this, 'addImagePreview')">
                                </div>
                                <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                <input type="text" class="form-control mt-2" id="imageUrl" name="imageUrl" placeholder="VD: /img/offers/offer_1.jpg hoặc URL">
                                <img id="addImagePreview" class="image-preview" style="display: none;">
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
        
        <!-- Edit Offer Modal -->
        <div class="modal fade" id="editOfferModal" tabindex="-1" role="dialog" aria-labelledby="editOfferModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editOfferModalLabel">Sửa Offer</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="offer-manager" enctype="multipart/form-data">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" id="editOfferID" name="offerID">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="editTitle">Tiêu đề *</label>
                                        <input type="text" class="form-control" id="editTitle" name="title" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="editCapacity">Sức chứa *</label>
                                        <input type="number" class="form-control" id="editCapacity" name="capacity" min="1" required>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="editSubtitle">Subtitle</label>
                                <input type="text" class="form-control" id="editSubtitle" name="subtitle">
                            </div>
                            <div class="form-group">
                                <label for="editDescription">Mô tả *</label>
                                <textarea class="form-control" id="editDescription" name="description" rows="4" required></textarea>
                            </div>
                            <div class="form-group">
                                <div class="custom-control custom-checkbox">
                                    <input type="checkbox" class="custom-control-input" id="editIsVIP" name="isVIP">
                                    <label class="custom-control-label" for="editIsVIP">Offer VIP</label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Ảnh</label>
                                <div class="file-input-wrapper">
                                    <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('editImageFile').click()">
                                        <i class="typcn typcn-upload"></i> Chọn ảnh
                                    </button>
                                    <input type="file" id="editImageFile" name="imageFile" accept="image/*" style="display: none;" onchange="previewImage(this, 'editImagePreview')">
                                </div>
                                <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                <input type="text" class="form-control mt-2" id="editImageUrl" name="imageUrl" placeholder="VD: /img/offers/offer_1.jpg hoặc URL">
                                <img id="editImagePreview" class="image-preview" style="display: none;">
                                <img id="editCurrentImage" class="image-preview" style="display: none;">
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
    $(document).on('click', '.edit-offer-btn', function() {
        var offerId = $(this).data('offer-id');
        var title = $(this).data('title');
        var subtitle = $(this).data('subtitle');
        var description = $(this).data('description');
        var imageUrl = $(this).data('image-url');
        var capacity = $(this).data('capacity');
        var isVIP = $(this).data('is-vip');
        
        console.log('DEBUG: Edit button clicked');
        console.log('DEBUG: offerId:', offerId);
        console.log('DEBUG: title:', title);
        console.log('DEBUG: subtitle:', subtitle);
        console.log('DEBUG: description:', description);
        console.log('DEBUG: imageUrl:', imageUrl);
        console.log('DEBUG: capacity:', capacity);
        console.log('DEBUG: isVIP:', isVIP);
        
        document.getElementById('editOfferID').value = offerId;
        document.getElementById('editTitle').value = title;
        document.getElementById('editSubtitle').value = subtitle;
        document.getElementById('editDescription').value = description;
        document.getElementById('editImageUrl').value = imageUrl;
        document.getElementById('editCapacity').value = capacity;
        document.getElementById('editIsVIP').checked = isVIP;
        
        // Show current image preview
        var currentImage = document.getElementById('editCurrentImage');
        var imagePreview = document.getElementById('editImagePreview');
        if (imageUrl && imageUrl.trim() !== '') {
            currentImage.src = imageUrl.startsWith('http') ? imageUrl : window.location.origin + imageUrl;
            currentImage.style.display = 'block';
            imagePreview.style.display = 'none';
        } else {
            currentImage.style.display = 'none';
        }
        
        console.log('DEBUG: Form values set, opening modal');
        $('#editOfferModal').modal('show');
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
    if ('${vipFilter}') {
        url.searchParams.set('vipFilter', '${vipFilter}');
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
    if ('${vipFilter}') {
        url.searchParams.set('vipFilter', '${vipFilter}');
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