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
    </head>
    <body>
        <div class="container-scroller">
            <jsp:include page="header-manager.jsp" />
            <!-- partial -->
            <div class="main-panel">
                <div class="content-wrapper">
                    <div class="row">
                        <!-- Contact Table -->
                        <div class="col-lg-12 grid-margin stretch-card">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Quản lý Contact</h4>
                                    
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
                                    
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Tin nhắn</th>
                                                    <th>Điện thoại</th>
                                                    <th>Trạng thái</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="contact" items="${contacts}">
                                                    <tr>
                                                        <td>${contact.contactID}</td>
                                                        <td>${contact.message}</td>
                                                        <td>${contact.phoneNumber}</td>
                                                        <td>
                                                            <form method="post" action="contact-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="toggleStatus">
                                                                <input type="hidden" name="contactID" value="${contact.contactID}">
                                                                <c:choose>
                                                                    <c:when test="${contact.active}">
                                                                        <button type="submit" class="badge badge-success" onclick="return confirm('Bạn có muốn ẩn contact này?')">Hiện</button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="submit" class="badge badge-danger" onclick="return confirm('Bạn có muốn hiện contact này?')">Ẩn</button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </form>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-warning btn-sm edit-contact-btn" 
                                                                    data-contact-id="${contact.contactID}" 
                                                                    data-message="${contact.message}" 
                                                                    data-phone="${contact.phoneNumber}">Sửa</button>
                                                            <form method="post" action="contact-manager" style="display:inline;">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="contactID" value="${contact.contactID}">
                                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa contact này?')">Xóa</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        <button class="btn btn-primary mt-2" data-toggle="modal" data-target="#addContactModal">Thêm mới Contact</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add Contact Modal -->
        <div class="modal fade" id="addContactModal" tabindex="-1" role="dialog" aria-labelledby="addContactModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addContactModalLabel">Thêm Contact Mới</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="contact-manager">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">
                            <div class="form-group">
                                <label for="message">Tin nhắn</label>
                                <textarea class="form-control" id="message" name="message" rows="3" required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="phoneNumber">Số điện thoại</label>
                                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" required>
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
        
        <!-- Edit Contact Modal -->
        <div class="modal fade" id="editContactModal" tabindex="-1" role="dialog" aria-labelledby="editContactModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editContactModalLabel">Sửa Contact</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <form method="post" action="contact-manager">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" id="editContactID" name="contactID">
                            <div class="form-group">
                                <label for="editMessage">Tin nhắn</label>
                                <textarea class="form-control" id="editMessage" name="message" rows="3" required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="editPhoneNumber">Số điện thoại</label>
                                <input type="text" class="form-control" id="editPhoneNumber" name="phoneNumber" required>
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
    $(document).on('click', '.edit-contact-btn', function() {
        var contactId = $(this).data('contact-id');
        var message = $(this).data('message');
        var phone = $(this).data('phone');
        
        document.getElementById('editContactID').value = contactId;
        document.getElementById('editMessage').value = message;
        document.getElementById('editPhoneNumber').value = phone;
        $('#editContactModal').modal('show');
    });
});
</script>
</body>
</html>