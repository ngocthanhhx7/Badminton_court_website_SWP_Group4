<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Required meta tags -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Instagram Feed Manager - Admin</title>
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
            .instagram-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }
            .instagram-item {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 10px;
                text-align: center;
            }
            .instagram-item img {
                width: 100%;
                height: 150px;
                object-fit: cover;
                border-radius: 4px;
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
                                    <form action="${pageContext.request.contextPath}/instagram-manager" method="get" class="row">
                                        <div class="col-md-4">
                                            <input type="text" name="search" value="${search}" class="form-control" placeholder="Search Instagram feeds...">
                                        </div>
                                        <div class="col-md-3">
                                            <select name="visible" class="form-control">
                                                <option value="">All Feeds</option>
                                                <option value="true" ${visible == 'true' ? 'selected' : ''}>Visible Only</option>
                                                <option value="false" ${visible == 'false' ? 'selected' : ''}>Hidden Only</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="submit" class="btn btn-primary">Search</button>
                                        </div>
                                        <div class="col-md-3 text-right">
                                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addFeedModal">
                                                Add New Feed
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Instagram Feeds Table -->
                    <div class="row">
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Instagram Feed Management</h4>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Image</th>
                                                    <th>Instagram Link</th>
                                                    <th>Display Order</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="feed" items="${feeds}">
                                                    <tr>
                                                        <td>${feed.feedID}</td>
                                                        <td>
                                                            <img src="${feed.imageUrl}" alt="Instagram feed" class="img-thumbnail" style="width: 100px;">
                                                        </td>
                                                        <td>
                                                            <a href="${feed.instagramLink}" target="_blank" class="text-truncate d-inline-block" style="max-width: 200px;">
                                                                ${feed.instagramLink}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            <input type="number" value="${feed.displayOrder}" 
                                                                   class="form-control form-control-sm" 
                                                                   style="width: 80px;"
                                                                   onchange="updateOrder(${feed.feedID}, this.value)">
                                                        </td>
                                                        <td>
                                                            <form action="${pageContext.request.contextPath}/instagram-manager" method="post" style="display: inline;">
                                                                <input type="hidden" name="action" value="toggle-visibility">
                                                                <input type="hidden" name="feedId" value="${feed.feedID}">
                                                                <button type="submit" class="btn btn-sm ${feed.isVisible ? 'btn-success' : 'btn-danger'}">
                                                                    ${feed.isVisible ? 'Visible' : 'Hidden'}
                                                                </button>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <button type="button" class="btn btn-warning btn-sm" 
                                                                    data-toggle="modal" 
                                                                    data-target="#editFeedModal"
                                                                    data-id="${feed.feedID}"
                                                                    data-imageurl="${feed.imageUrl}"
                                                                    data-instagramlink="${feed.instagramLink}"
                                                                    data-displayorder="${feed.displayOrder}"
                                                                    data-visible="${feed.isVisible}">
                                                                Edit
                                                            </button>
                                                            <button type="button" class="btn btn-danger btn-sm" 
                                                                    onclick="confirmDelete(${feed.feedID})">
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
                                                    <a class="page-link" href="?page=${currentPage - 1}&search=${search}&visible=${visible}">Previous</a>
                                                </li>
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link" href="?page=${i}&search=${search}&visible=${visible}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage + 1}&search=${search}&visible=${visible}">Next</a>
                                                </li>
                                            </ul>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Instagram Feed Preview -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Feed Preview</h4>
                                    <div class="instagram-grid">
                                        <c:forEach var="feed" items="${feeds}">
                                            <div class="instagram-item">
                                                <img src="${feed.imageUrl}" alt="Instagram feed">
                                                <p class="mt-2 mb-1">
                                                    <small class="text-muted">Order: ${feed.displayOrder}</small>
                                                </p>
                                                <span class="badge ${feed.isVisible ? 'badge-success' : 'badge-danger'}">
                                                    ${feed.isVisible ? 'Visible' : 'Hidden'}
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
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
    // Handle edit modal data
    $('#editFeedModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget);
        var modal = $(this);
        modal.find('#editFeedId').val(button.data('id'));
        modal.find('#editImageUrl').val(button.data('imageurl'));
        modal.find('#editInstagramLink').val(button.data('instagramlink'));
        modal.find('#editDisplayOrder').val(button.data('displayorder'));
        modal.find('#editVisibleSwitch').prop('checked', button.data('visible'));
    });

    // Handle delete confirmation
    function confirmDelete(feedId) {
        if (confirm('Are you sure you want to delete this Instagram feed?')) {
            document.getElementById('deleteFeedId').value = feedId;
            document.getElementById('deleteForm').submit();
        }
    }

    // Handle display order update
    function updateOrder(feedId, newOrder) {
        document.getElementById('updateOrderFeedId').value = feedId;
        document.getElementById('updateOrderNewOrder').value = newOrder;
        document.getElementById('updateOrderForm').submit();
    }

    // Auto-dismiss alerts after 5 seconds
    setTimeout(function() {
        $('.alert').alert('close');
    }, 5000);
</script>

<!-- Add Feed Modal -->
<div class="modal fade" id="addFeedModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add New Instagram Feed</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/instagram-manager" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label>Image URL</label>
                        <input type="url" name="imageUrl" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Instagram Link</label>
                        <input type="url" name="instagramLink" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <div class="custom-control custom-switch">
                            <input type="checkbox" name="isVisible" class="custom-control-input" id="addVisibleSwitch" checked>
                            <label class="custom-control-label" for="addVisibleSwitch">Visible</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Add Feed</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Feed Modal -->
<div class="modal fade" id="editFeedModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Instagram Feed</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <form action="${pageContext.request.contextPath}/instagram-manager" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="feedId" id="editFeedId">
                    <div class="form-group">
                        <label>Image URL</label>
                        <input type="url" name="imageUrl" id="editImageUrl" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Instagram Link</label>
                        <input type="url" name="instagramLink" id="editInstagramLink" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>Display Order</label>
                        <input type="number" name="displayOrder" id="editDisplayOrder" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <div class="custom-control custom-switch">
                            <input type="checkbox" name="isVisible" class="custom-control-input" id="editVisibleSwitch">
                            <label class="custom-control-label" for="editVisibleSwitch">Visible</label>
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
<form id="deleteForm" action="${pageContext.request.contextPath}/instagram-manager" method="post" style="display: none;">
    <input type="hidden" name="action" value="delete">
    <input type="hidden" name="feedId" id="deleteFeedId">
</form>

<!-- Update Order Form -->
<form id="updateOrderForm" action="${pageContext.request.contextPath}/instagram-manager" method="post" style="display: none;">
    <input type="hidden" name="action" value="update-order">
    <input type="hidden" name="feedId" id="updateOrderFeedId">
    <input type="hidden" name="newOrder" id="updateOrderNewOrder">
</form>
</body>
</html>