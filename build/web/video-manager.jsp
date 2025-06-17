<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Video Manager - Admin</title>
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
            .preview-image {
                max-width: 200px;
                max-height: 200px;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container-scroller">
            <jsp:include page="header-manager.jsp" />
            <!-- partial -->
            <div class="main-panel">
                <div class="content-wrapper">
                    <!-- Alert Messages -->
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${sessionScope.successMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <% session.removeAttribute("successMessage"); %>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${sessionScope.errorMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <% session.removeAttribute("errorMessage"); %>
                    </c:if>

                    <!-- Search and Filter -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/video-manager" method="get" class="row">
                                        <div class="col-md-4">
                                            <input type="text" name="search" value="${search}" class="form-control" placeholder="Search videos...">
                                        </div>
                                        <div class="col-md-3">
                                            <select name="featured" class="form-control">
                                                <option value="">All Videos</option>
                                                <option value="true" ${featured == 'true' ? 'selected' : ''}>Featured Only</option>
                                                <option value="false" ${featured == 'false' ? 'selected' : ''}>Non-Featured Only</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary">Search</button>
                                        </div>
                                        <div class="col-md-3 text-right">
                                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addVideoModal">
                                                Add New Video
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Video Table -->
                    <div class="row">
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Video Management</h4>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Thumbnail</th>
                                                    <th>Title</th>
                                                    <th>Subtitle</th>
                                                    <th>Video URL</th>
                                                    <th>Featured</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="video" items="${videos}">
                                                    <tr>
                                                        <td>${video.videoID}</td>
                                                        <td>
                                                            <img src="${video.thumbnailUrl}" alt="thumbnail" class="img-thumbnail" style="width: 100px;">
                                                        </td>
                                                        <td>${video.title}</td>
                                                        <td>${video.subtitle}</td>
                                                        <td>
                                                            <a href="${video.videoUrl}" target="_blank" class="text-truncate d-inline-block" style="max-width: 150px;">
                                                                ${video.videoUrl}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/video-manager" method="post" style="display: inline;">
                                                                <input type="hidden" name="action" value="toggle-featured">
                                                                <input type="hidden" name="videoId" value="${video.videoID}">
                                                                <button type="submit" class="btn btn-sm ${video.isFeatured ? 'btn-info' : 'btn-secondary'}">
                                                                    ${video.isFeatured ? 'Featured' : 'Not Featured'}
                                                                </button>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-warning btn-sm" 
                                                                    data-toggle="modal" 
                                                                    data-target="#editVideoModal"
                                                                    data-id="${video.videoID}"
                                                                    data-title="${video.title}"
                                                                    data-subtitle="${video.subtitle}"
                                                                    data-videourl="${video.videoUrl}"
                                                                    data-thumbnailurl="${video.thumbnailUrl}"
                                                                    data-featured="${video.isFeatured}">
                                                                Edit
                                                            </button>
                                                            <button type="button" class="btn btn-danger btn-sm" 
                                                                    onclick="confirmDelete(${video.videoID})">
                                                                Delete
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${totalPages > 1}">
                                        <div class="d-flex justify-content-center mt-4">
                                            <ul class="pagination">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage - 1}&search=${search}&featured=${featured}">Previous</a>
                                                </li>
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link" href="?page=${i}&search=${search}&featured=${featured}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage + 1}&search=${search}&featured=${featured}">Next</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- content-wrapper ends -->
    </div>
    <!-- main-panel ends -->

    <!-- Add Video Modal -->
    <div class="modal fade" id="addVideoModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Video</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/video-manager" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group">
                            <label>Title</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Subtitle</label>
                            <input type="text" name="subtitle" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Video URL</label>
                            <input type="url" name="videoUrl" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Thumbnail URL</label>
                            <input type="url" name="thumbnailUrl" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <div class="custom-control custom-switch">
                                <input type="checkbox" name="isFeatured" class="custom-control-input" id="addFeaturedSwitch">
                                <label class="custom-control-label" for="addFeaturedSwitch">Featured Video</label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Video</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Edit Video Modal -->
    <div class="modal fade" id="editVideoModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Video</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/video-manager" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="videoId" id="editVideoId">
                        <div class="form-group">
                            <label>Title</label>
                            <input type="text" name="title" id="editTitle" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Subtitle</label>
                            <input type="text" name="subtitle" id="editSubtitle" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Video URL</label>
                            <input type="url" name="videoUrl" id="editVideoUrl" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label>Thumbnail URL</label>
                            <input type="url" name="thumbnailUrl" id="editThumbnailUrl" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <div class="custom-control custom-switch">
                                <input type="checkbox" name="isFeatured" class="custom-control-input" id="editFeaturedSwitch">
                                <label class="custom-control-label" for="editFeaturedSwitch">Featured Video</label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Form -->
    <form id="deleteForm" action="${pageContext.request.contextPath}/video-manager" method="post" style="display: none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="videoId" id="deleteVideoId">
    </form>

    <!-- Scripts -->
    <script src="vendors/js/vendor.bundle.base.js"></script>
    <script src="js/off-canvas.js"></script>
    <script src="js/hoverable-collapse.js"></script>
    <script src="js/template.js"></script>
    <script src="js/settings.js"></script>
    <script src="js/todolist.js"></script>
    
    <script>
        // Handle edit modal data
        $('#editVideoModal').on('show.bs.modal', function (event) {
            var button = $(event.relatedTarget);
            var modal = $(this);
            modal.find('#editVideoId').val(button.data('id'));
            modal.find('#editTitle').val(button.data('title'));
            modal.find('#editSubtitle').val(button.data('subtitle'));
            modal.find('#editVideoUrl').val(button.data('videourl'));
            modal.find('#editThumbnailUrl').val(button.data('thumbnailurl'));
            modal.find('#editFeaturedSwitch').prop('checked', button.data('featured'));
        });

        // Handle delete confirmation
        function confirmDelete(videoId) {
            if (confirm('Are you sure you want to delete this video?')) {
                document.getElementById('deleteVideoId').value = videoId;
                document.getElementById('deleteForm').submit();
            }
        }

        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            $('.alert').alert('close');
        }, 5000);
    </script>
</body>
</html>