<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Blog Manager</title>
    <link rel="stylesheet" href="vendors/typicons.font/font/typicons.css">
    <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
    <link rel="stylesheet" href="css/vertical-layout-light/style.css">
    <link rel="shortcut icon" href="img/favicon.png" />
    <style>
        .image-preview {
            max-width: 120px;
            max-height: 80px;
            border-radius: 4px;
        }
        .sort-header { cursor: pointer; user-select: none; }
        .sort-header:hover { background-color: #f8f9fa; }
        .sort-icon { margin-left: 5px; font-size: 12px; }
        .badge-status { padding: 5px 10px; border-radius: 4px; font-size: 12px; }
        .badge-active { background: #28a745; color: #fff; }
        .badge-inactive { background: #dc3545; color: #fff; }
        .pagination-info { margin: 10px 0; color: #6c757d; }
        .search-box { max-width: 300px; }
        .table td, .table th { vertical-align: middle !important; }
        .modal .form-group { margin-bottom: 1rem; }
    </style>
</head>
<body>
<div class="container-scroller">
    <jsp:include page="header-manager.jsp" />
    <div class="main-panel">
        <div class="content-wrapper">
            <div class="row">
                <div class="col-lg-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Quản lý Blog</h4>
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
                            <!-- Filter Section -->
                            <div class="filter-section" style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
                                <form method="get" action="blog-manager" class="row">
                                    <div class="col-md-3">
                                        <label for="title">Tiêu đề</label>
                                        <input type="text" class="form-control search-box" id="title" name="title" value="${title}" placeholder="Nhập tiêu đề...">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="status">Trạng thái</label>
                                        <select class="form-control" id="status" name="status">
                                            <option value="">Tất cả</option>
                                            <option value="Active" ${status == 'Active' ? 'selected' : ''}>Active</option>
                                            <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label for="authorId">Tác giả (ID)</label>
                                        <input type="number" class="form-control" id="authorId" name="authorId" value="${authorId}" min="1">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="pageSize">Hiển thị</label>
                                        <select class="form-control" id="pageSize" name="pageSize">
                                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                            <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 d-flex align-items-end">
                                        <button type="submit" class="btn btn-primary mr-2"><i class="typcn typcn-zoom"></i> Lọc</button>
                                        <a href="blog-manager" class="btn btn-secondary"><i class="typcn typcn-refresh"></i> Làm mới</a>
                                    </div>
                                </form>
                            </div>
                            <!-- Pagination Info -->
                            <div class="pagination-info">
                                Hiển thị ${startRecord} - ${endRecord} của ${totalPosts} bài viết
                                <c:if test="${not empty title or not empty status or not empty authorId}">
                                    (đã lọc)
                                </c:if>
                            </div>
                            <!-- Table -->
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th class="sort-header" onclick="sortTable('PostID')">ID
                                            <c:choose>
                                                <c:when test="${sortBy == 'PostID' && sortOrder == 'ASC'}"><i class="typcn typcn-arrow-sorted-up sort-icon"></i></c:when>
                                                <c:when test="${sortBy == 'PostID' && sortOrder == 'DESC'}"><i class="typcn typcn-arrow-sorted-down sort-icon"></i></c:when>
                                                <c:otherwise><i class="typcn typcn-arrow-unsorted sort-icon"></i></c:otherwise>
                                            </c:choose>
                                        </th>
                                        <th>Tiêu đề</th>
                                        <th>Slug</th>
                                        <th>Tóm tắt</th>
                                        <th>Ảnh</th>
                                        <th>Ngày đăng</th>
                                        <th>Tác giả</th>
                                        <th>Lượt xem</th>
                                        <th>Trạng thái</th>
                                        <th>Hành động</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="post" items="${posts}">
                                        <tr>
                                            <td>${post.postID}</td>
                                            <td>${post.title}</td>
                                            <td>${post.slug}</td>
                                            <td>${post.summary}</td>
                                            <td><c:if test="${not empty post.thumbnailUrl}"><img src="${post.thumbnailUrl}" class="image-preview"/></c:if></td>
                                            <td>${post.publishedAt}</td>
                                            <td>${post.authorID}</td>
                                            <td>${post.viewCount}</td>
                                            <td>
                                                <form method="post" action="blog-manager" style="display:inline;">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="postId" value="${post.postID}">
                                                    <button type="submit" class="badge badge-status ${post.status == 'Active' ? 'badge-active' : 'badge-inactive'}" style="border:none; background:none; cursor:pointer;">
                                                        ${post.status}
                                                    </button>
                                                </form>
                                            </td>
                                            <td>
                                                <button class="btn btn-warning btn-sm edit-btn"
                                                        data-id="${post.postID}"
                                                        data-title="${post.title}"
                                                        data-slug="${post.slug}"
                                                        data-content="${post.content}"
                                                        data-summary="${post.summary}"
                                                        data-thumbnailurl="${post.thumbnailUrl}"
                                                        data-publishedat="${post.publishedAt}"
                                                        data-authorid="${post.authorID}"
                                                        data-status="${post.status}">
                                                    Sửa
                                                </button>
                                                <form method="post" action="blog-manager" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="postId" value="${post.postID}">
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?')">Xóa</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <nav aria-label="Blog pagination">
                                        <ul class="pagination justify-content-center">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="javascript:void(0)" onclick="goToPage(${currentPage - 1})">&laquo;</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="javascript:void(0)" onclick="goToPage(${pageNum})">${pageNum}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="javascript:void(0)" onclick="goToPage(${currentPage + 1})">&raquo;</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </c:if>
                                <button class="btn btn-primary mt-2" data-toggle="modal" data-target="#addPostModal">Thêm bài viết mới</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal Thêm Bài Viết -->
<div class="modal fade" id="addPostModal" tabindex="-1" role="dialog" aria-labelledby="addPostModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="blog-manager">
                <div class="modal-header">
                    <h5 class="modal-title" id="addPostModalLabel">Thêm bài viết mới</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label for="addTitle">Tiêu đề</label>
                        <input type="text" class="form-control" id="addTitle" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="addSlug">Slug</label>
                        <input type="text" class="form-control" id="addSlug" name="slug" required>
                    </div>
                    <div class="form-group">
                        <label for="addSummary">Tóm tắt</label>
                        <textarea class="form-control" id="addSummary" name="summary" rows="2"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="addContent">Nội dung</label>
                        <textarea class="form-control" id="addContent" name="content" rows="6" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="addThumbnailUrl">Ảnh đại diện (URL)</label>
                        <input type="text" class="form-control" id="addThumbnailUrl" name="thumbnailUrl">
                    </div>
                    <div class="form-group">
                        <label for="addPublishedAt">Ngày đăng (yyyy-MM-dd HH:mm)</label>
                        <input type="text" class="form-control" id="addPublishedAt" name="publishedAt" placeholder="2024-06-01 08:00">
                    </div>
                    <div class="form-group">
                        <label for="addAuthorId">Tác giả (ID)</label>
                        <input type="number" class="form-control" id="addAuthorId" name="authorId" min="1" required>
                    </div>
                    <div class="form-group">
                        <label for="addStatus">Trạng thái</label>
                        <select class="form-control" id="addStatus" name="status" required>
                            <option value="Archived">Archived</option>
                            <option value="Draft">Draft</option>
                            <option value="Published">Published</option>
                        </select>
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
<!-- Modal Sửa Bài Viết -->
<div class="modal fade" id="editPostModal" tabindex="-1" role="dialog" aria-labelledby="editPostModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="blog-manager">
                <div class="modal-header">
                    <h5 class="modal-title" id="editPostModalLabel">Sửa bài viết</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" id="editPostId" name="postId">
                    <div class="form-group">
                        <label for="editTitle">Tiêu đề</label>
                        <input type="text" class="form-control" id="editTitle" name="title" required>
                    </div>
                    <div class="form-group">
                        <label for="editSlug">Slug</label>
                        <input type="text" class="form-control" id="editSlug" name="slug" required>
                    </div>
                    <div class="form-group">
                        <label for="editSummary">Tóm tắt</label>
                        <textarea class="form-control" id="editSummary" name="summary" rows="2"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="editContent">Nội dung</label>
                        <textarea class="form-control" id="editContent" name="content" rows="6" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="editThumbnailUrl">Ảnh đại diện (URL)</label>
                        <input type="text" class="form-control" id="editThumbnailUrl" name="thumbnailUrl">
                    </div>
                    <div class="form-group">
                        <label for="editPublishedAt">Ngày đăng (yyyy-MM-dd HH:mm)</label>
                        <input type="text" class="form-control" id="editPublishedAt" name="publishedAt" placeholder="2024-06-01 08:00">
                    </div>
                    <div class="form-group">
                        <label for="editAuthorId">Tác giả (ID)</label>
                        <input type="number" class="form-control" id="editAuthorId" name="authorId" min="1" required>
                    </div>
                    <div class="form-group">
                        <label for="editStatus">Trạng thái</label>
                        <select class="form-control" id="editStatus" name="status" required>
                            <option value="Archived">Archived</option>
                            <option value="Draft">Draft</option>
                            <option value="Published">Published</option>
                        </select>
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
<!-- Modal Đổi Trạng Thái Bài Viết -->
<div class="modal fade" id="changeStatusModal" tabindex="-1" role="dialog" aria-labelledby="changeStatusModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="blog-manager">
                <div class="modal-header">
                    <h5 class="modal-title" id="changeStatusModalLabel">Đổi trạng thái bài viết</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="toggleStatus">
                    <input type="hidden" id="changeStatusPostId" name="postId">
                    <div class="form-group">
                        <label for="changeStatusSelect">Chọn trạng thái mới</label>
                        <select class="form-control" id="changeStatusSelect" name="newStatus" required>
                            <option value="Published">Published</option>
                            <option value="Draft">Draft</option>
                            <option value="Archived">Archived</option>
                        </select>
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
<!-- JS & Script -->
<script src="vendors/js/vendor.bundle.base.js"></script>
<script src="js/off-canvas.js"></script>
<script src="js/hoverable-collapse.js"></script>
<script src="js/template.js"></script>
<script src="js/settings.js"></script>
<script src="js/todolist.js"></script>
<script>
$(document).ready(function() {
    setTimeout(function() { $('.alert').fadeOut('slow'); }, 5000);
    $(document).on('click', '.edit-btn', function() {
        $('#editPostId').val($(this).data('id'));
        $('#editTitle').val($(this).data('title'));
        $('#editSlug').val($(this).data('slug'));
        $('#editSummary').val($(this).data('summary'));
        $('#editContent').val($(this).data('content'));
        $('#editThumbnailUrl').val($(this).data('thumbnailurl'));
        $('#editPublishedAt').val($(this).data('publishedat'));
        $('#editAuthorId').val($(this).data('authorid'));
        $('#editStatus').val($(this).data('status'));
        $('#editPostModal').modal('show');
    });
    $(document).on('click', '.badge-status', function(e) {
        e.preventDefault();
        var postId = $(this).closest('tr').find('input[name="postId"]').val() || $(this).closest('tr').find('.edit-btn').data('id');
        var currentStatus = $(this).text().trim();
        $('#changeStatusPostId').val(postId);
        $('#changeStatusSelect').val(currentStatus);
        $('#changeStatusModal').modal('show');
    });
});
function sortTable(sortBy) {
    var url = new URL(window.location);
    var currentSortBy = '${sortBy}';
    var currentSortOrder = '${sortOrder}';
    var newSortOrder = (currentSortBy === sortBy && currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
    url.searchParams.set('sortBy', sortBy);
    url.searchParams.set('sortOrder', newSortOrder);
    if ('${title}') url.searchParams.set('title', '${title}');
    if ('${status}') url.searchParams.set('status', '${status}');
    if ('${authorId}') url.searchParams.set('authorId', '${authorId}');
    if ('${pageSize}') url.searchParams.set('pageSize', '${pageSize}');
    window.location.href = url.toString();
}
function goToPage(page) {
    var url = new URL(window.location);
    url.searchParams.set('page', page);
    if ('${title}') url.searchParams.set('title', '${title}');
    if ('${status}') url.searchParams.set('status', '${status}');
    if ('${authorId}') url.searchParams.set('authorId', '${authorId}');
    if ('${pageSize}') url.searchParams.set('pageSize', '${pageSize}');
    if ('${sortBy}') url.searchParams.set('sortBy', '${sortBy}');
    if ('${sortOrder}') url.searchParams.set('sortOrder', '${sortOrder}');
    window.location.href = url.toString();
}
</script>
</body>
</html> 