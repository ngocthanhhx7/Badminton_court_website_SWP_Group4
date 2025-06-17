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
            .content-preview {
                max-width: 300px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
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
                        <!-- About Section Table -->
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Quản lý About Section</h4>
                                    
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
                                        <form method="get" action="about-manager" class="row">
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
                                                <label for="sectionTypeFilter">Loại section:</label>
                                                <select class="form-control" id="sectionTypeFilter" name="sectionTypeFilter">
                                                    <option value="">Tất cả</option>
                                                    <option value="hero" ${sectionTypeFilter == 'hero' ? 'selected' : ''}>Hero</option>
                                                    <option value="about" ${sectionTypeFilter == 'about' ? 'selected' : ''}>About</option>
                                                    <option value="service" ${sectionTypeFilter == 'service' ? 'selected' : ''}>Service</option>
                                                    <option value="team" ${sectionTypeFilter == 'team' ? 'selected' : ''}>Team</option>
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
                                                    <a href="about-manager" class="btn btn-secondary">
                                                        <i class="typcn typcn-refresh"></i> Làm mới
                                                    </a>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <!-- Pagination Info -->
                                    <div class="pagination-info">
                                        Hiển thị ${startRecord} - ${endRecord} của ${totalSections} section
                                        <c:if test="${not empty searchTitle or not empty statusFilter or not empty sectionTypeFilter}">
                                            (đã lọc)
                                        </c:if>
                                    </div>
                                    
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th class="sort-header" onclick="sortTable('AboutID')">
                                                        ID
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'AboutID' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'AboutID' and sortOrder == 'DESC'}">
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
                                                    <th>Nội dung</th>
                                                    <th>Ảnh 1</th>
                                                    <th>Ảnh 2</th>
                                                    <th class="sort-header" onclick="sortTable('SectionType')">
                                                        Loại
                                                        <c:choose>
                                                            <c:when test="${sortBy == 'SectionType' and sortOrder == 'ASC'}">
                                                                <i class="typcn typcn-arrow-sorted-up sort-icon"></i>
                                                            </c:when>
                                                            <c:when test="${sortBy == 'SectionType' and sortOrder == 'DESC'}">
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
                                                <c:forEach var="section" items="${sections}">
                                                    <tr>
                                                        <td>${section.aboutID}</td>
                                                        <td>${section.title}</td>
                                                        <td>${section.subtitle}</td>
                                                        <td>
                                                            <div class="content-preview" title="${section.content}">
                                                                ${section.content}
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty section.image1}">
                                                                <img src="${section.image1.startsWith('http') ? section.image1 : pageContext.request.contextPath.concat(section.image1)}" class="image-preview"/>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty section.image2}">
                                                                <img src="${section.image2.startsWith('http') ? section.image2 : pageContext.request.contextPath.concat(section.image2)}" class="image-preview"/>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <span class="badge badge-info">${section.sectionType}</span>
                                                        </td>
                                                        <td>
                                                            <form method="post" action="about-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="sectionID" value="${section.aboutID}">
                                                                <c:choose>
                                                                    <c:when test="${section.isActive}">
                                                                        <button type="submit" class="badge badge-success" onclick="return confirm('Bạn có muốn ẩn section này?')">Hoạt động</button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="submit" class="badge badge-danger" onclick="return confirm('Bạn có muốn hiện section này?')">Không hoạt động</button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-warning btn-sm edit-section-btn" 
                                                                    data-section-id="${section.aboutID}" 
                                                                    data-title="${section.title}" 
                                                                    data-subtitle="${section.subtitle}"
                                                                    data-content="${section.content}"
                                                                    data-image1="${section.image1}"
                                                                    data-image2="${section.image2}"
                                                                    data-section-type="${section.sectionType}">Sửa</button>
                                                            <form method="post" action="about-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="sectionID" value="${section.aboutID}">
                                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa section này?')">Xóa</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        
                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 1}">
                                            <nav aria-label="About section pagination">
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
                                        
                                        <button class="btn btn-primary mt-2" data-toggle="modal" data-target="#addSectionModal">Thêm mới Section</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add Section Modal -->
        <div class="modal fade" id="addSectionModal" tabindex="-1" role="dialog" aria-labelledby="addSectionModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addSectionModalLabel">Thêm Section Mới</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="about-manager" enctype="multipart/form-data">
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
                                        <label for="sectionType">Loại section *</label>
                                        <select class="form-control" id="sectionType" name="sectionType" required>
                                            <option value="">Chọn loại section</option>
                                            <option value="hero">Hero</option>
                                            <option value="about">About</option>
                                            <option value="service">Service</option>
                                            <option value="team">Team</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="subtitle">Subtitle</label>
                                <input type="text" class="form-control" id="subtitle" name="subtitle">
                            </div>
                            <div class="form-group">
                                <label for="content">Nội dung *</label>
                                <textarea class="form-control" id="content" name="content" rows="4" required></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Ảnh 1</label>
                                        <div class="file-input-wrapper">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('image1File').click()">
                                                <i class="typcn typcn-upload"></i> Chọn ảnh 1
                                            </button>
                                            <input type="file" id="image1File" name="image1File" accept="image/*" style="display: none;" onchange="previewImage(this, 'addImage1Preview')">
                                        </div>
                                        <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                        <input type="text" class="form-control mt-2" id="image1" name="image1" placeholder="VD: /img/about/about_1.jpg hoặc URL">
                                        <img id="addImage1Preview" class="image-preview" style="display: none;">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Ảnh 2</label>
                                        <div class="file-input-wrapper">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('image2File').click()">
                                                <i class="typcn typcn-upload"></i> Chọn ảnh 2
                                            </button>
                                            <input type="file" id="image2File" name="image2File" accept="image/*" style="display: none;" onchange="previewImage(this, 'addImage2Preview')">
                                        </div>
                                        <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                        <input type="text" class="form-control mt-2" id="image2" name="image2" placeholder="VD: /img/about/about_2.jpg hoặc URL">
                                        <img id="addImage2Preview" class="image-preview" style="display: none;">
                                    </div>
                                </div>
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
        
        <!-- Edit Section Modal -->
        <div class="modal fade" id="editSectionModal" tabindex="-1" role="dialog" aria-labelledby="editSectionModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editSectionModalLabel">Sửa Section</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="about-manager" enctype="multipart/form-data">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" id="editSectionID" name="sectionID">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="editTitle">Tiêu đề *</label>
                                        <input type="text" class="form-control" id="editTitle" name="title" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="editSectionType">Loại section *</label>
                                        <select class="form-control" id="editSectionType" name="sectionType" required>
                                            <option value="">Chọn loại section</option>
                                            <option value="hero">Hero</option>
                                            <option value="about">About</option>
                                            <option value="service">Service</option>
                                            <option value="team">Team</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="editSubtitle">Subtitle</label>
                                <input type="text" class="form-control" id="editSubtitle" name="subtitle">
                            </div>
                            <div class="form-group">
                                <label for="editContent">Nội dung *</label>
                                <textarea class="form-control" id="editContent" name="content" rows="4" required></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Ảnh 1</label>
                                        <div class="file-input-wrapper">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('editImage1File').click()">
                                                <i class="typcn typcn-upload"></i> Chọn ảnh 1
                                            </button>
                                            <input type="file" id="editImage1File" name="image1File" accept="image/*" style="display: none;" onchange="previewImage(this, 'editImage1Preview')">
                                        </div>
                                        <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                        <input type="text" class="form-control mt-2" id="editImage1" name="image1" placeholder="VD: /img/about/about_1.jpg hoặc URL">
                                        <img id="editImage1Preview" class="image-preview" style="display: none;">
                                        <img id="editCurrentImage1" class="image-preview" style="display: none;">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Ảnh 2</label>
                                        <div class="file-input-wrapper">
                                            <button type="button" class="btn btn-outline-primary" onclick="document.getElementById('editImage2File').click()">
                                                <i class="typcn typcn-upload"></i> Chọn ảnh 2
                                            </button>
                                            <input type="file" id="editImage2File" name="image2File" accept="image/*" style="display: none;" onchange="previewImage(this, 'editImage2Preview')">
                                        </div>
                                        <small class="form-text text-muted">Hoặc nhập đường dẫn ảnh bên dưới</small>
                                        <input type="text" class="form-control mt-2" id="editImage2" name="image2" placeholder="VD: /img/about/about_2.jpg hoặc URL">
                                        <img id="editImage2Preview" class="image-preview" style="display: none;">
                                        <img id="editCurrentImage2" class="image-preview" style="display: none;">
                                    </div>
                                </div>
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
    $(document).on('click', '.edit-section-btn', function() {
        var sectionId = $(this).data('section-id');
        var title = $(this).data('title');
        var subtitle = $(this).data('subtitle');
        var content = $(this).data('content');
        var image1 = $(this).data('image1');
        var image2 = $(this).data('image2');
        var sectionType = $(this).data('section-type');
        
        console.log('DEBUG: Edit button clicked');
        console.log('DEBUG: sectionId:', sectionId);
        console.log('DEBUG: title:', title);
        console.log('DEBUG: subtitle:', subtitle);
        console.log('DEBUG: content:', content);
        console.log('DEBUG: image1:', image1);
        console.log('DEBUG: image2:', image2);
        console.log('DEBUG: sectionType:', sectionType);
        
        document.getElementById('editSectionID').value = sectionId;
        document.getElementById('editTitle').value = title;
        document.getElementById('editSubtitle').value = subtitle;
        document.getElementById('editContent').value = content;
        document.getElementById('editImage1').value = image1;
        document.getElementById('editImage2').value = image2;
        document.getElementById('editSectionType').value = sectionType;
        
        // Show current image previews
        var currentImage1 = document.getElementById('editCurrentImage1');
        var image1Preview = document.getElementById('editImage1Preview');
        if (image1 && image1.trim() !== '') {
            currentImage1.src = image1.startsWith('http') ? image1 : window.location.origin + image1;
            currentImage1.style.display = 'block';
            image1Preview.style.display = 'none';
        } else {
            currentImage1.style.display = 'none';
        }
        
        var currentImage2 = document.getElementById('editCurrentImage2');
        var image2Preview = document.getElementById('editImage2Preview');
        if (image2 && image2.trim() !== '') {
            currentImage2.src = image2.startsWith('http') ? image2 : window.location.origin + image2;
            currentImage2.style.display = 'block';
            image2Preview.style.display = 'none';
        } else {
            currentImage2.style.display = 'none';
        }
        
        console.log('DEBUG: Form values set, opening modal');
        $('#editSectionModal').modal('show');
    });
    
    // Debug: Log form submissions
    $('form').on('submit', function() {
        console.log('DEBUG: Form submitted:', $(this).serialize());
    });
});

// Function to preview uploaded image
function previewImage(input, previewId) {
    var preview = document.getElementById(previewId);
    var currentImage1 = document.getElementById('editCurrentImage1');
    var currentImage2 = document.getElementById('editCurrentImage2');
    
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
            if (currentImage1) {
                currentImage1.style.display = 'none';
            }
            if (currentImage2) {
                currentImage2.style.display = 'none';
            }
        };
        
        reader.readAsDataURL(input.files[0]);
    } else {
        preview.style.display = 'none';
        if (currentImage1) {
            currentImage1.style.display = 'block';
        }
        if (currentImage2) {
            currentImage2.style.display = 'block';
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
    if ('${sectionTypeFilter}') {
        url.searchParams.set('sectionTypeFilter', '${sectionTypeFilter}');
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
    if ('${sectionTypeFilter}') {
        url.searchParams.set('sectionTypeFilter', '${sectionTypeFilter}');
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