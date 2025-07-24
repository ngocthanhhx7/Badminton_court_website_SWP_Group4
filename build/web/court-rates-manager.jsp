<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản lý giá sân</title>
    <link rel="stylesheet" href="vendors/typicons.font/font/typicons.css">
    <link rel="stylesheet" href="vendors/css/vendor.bundle.base.css">
    <link rel="stylesheet" href="css/vertical-layout-light/style.css">
    <link rel="shortcut icon" href="img/favicon.png" />
    <style>
        .modal .form-group { margin-bottom: 1rem; }
        .table th, .table td { vertical-align: middle !important; }
        .sort-header { cursor: pointer; user-select: none; }
        .sort-header:hover { background-color: #f8f9fa; }
        .sort-icon { margin-left: 5px; font-size: 12px; }
        .pagination-info { margin: 10px 0; color: #6c757d; }
        .badge-holiday { background: #ffc107; color: #212529; padding: 4px 8px; border-radius: 4px; font-size: 12px; }
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
                            <h4 class="card-title">Quản lý giá sân</h4>
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
                            <form method="get" action="court-rates-manager" class="row mb-3">
                                <div class="col-md-2">
                                    <label for="courtId">Sân</label>
                                    <select class="form-control" id="courtId" name="courtId">
                                        <option value="">Tất cả</option>
                                        <c:forEach var="court" items="${courts}">
                                            <option value="${court.courtId}" ${courtId == court.courtId ? 'selected' : ''}>${court.courtName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label for="dayOfWeek">Thứ</label>
                                    <select class="form-control" id="dayOfWeek" name="dayOfWeek">
                                        <option value="">Tất cả</option>
                                        <option value="0" ${dayOfWeek == '0' ? 'selected' : ''}>Chủ nhật</option>
                                        <option value="1" ${dayOfWeek == '1' ? 'selected' : ''}>Thứ 2</option>
                                        <option value="2" ${dayOfWeek == '2' ? 'selected' : ''}>Thứ 3</option>
                                        <option value="3" ${dayOfWeek == '3' ? 'selected' : ''}>Thứ 4</option>
                                        <option value="4" ${dayOfWeek == '4' ? 'selected' : ''}>Thứ 5</option>
                                        <option value="5" ${dayOfWeek == '5' ? 'selected' : ''}>Thứ 6</option>
                                        <option value="6" ${dayOfWeek == '6' ? 'selected' : ''}>Thứ 7</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label for="isHoliday">Ngày lễ</label>
                                    <select class="form-control" id="isHoliday" name="isHoliday">
                                        <option value="">Tất cả</option>
                                        <option value="1" ${isHoliday == '1' ? 'selected' : ''}>Có</option>
                                        <option value="0" ${isHoliday == '0' ? 'selected' : ''}>Không</option>
                                    </select>
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
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary mr-2"><i class="typcn typcn-zoom"></i> Lọc</button>
                                    <a href="court-rates-manager" class="btn btn-secondary"><i class="typcn typcn-refresh"></i> Làm mới</a>
                                </div>
                            </form>
                            <!-- Pagination Info -->
                            <div class="pagination-info">
                                Hiển thị ${startRecord} - ${endRecord} của ${totalRates} giá sân
                                <c:if test="${not empty courtId or not empty dayOfWeek or not empty isHoliday}">
                                    (đã lọc)
                                </c:if>
                            </div>
                            <!-- Table -->
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th class="sort-header" onclick="sortTable('RateID')">ID
                                            <c:choose>
                                                <c:when test="${sortBy == 'RateID' && sortOrder == 'ASC'}"><i class="typcn typcn-arrow-sorted-up sort-icon"></i></c:when>
                                                <c:when test="${sortBy == 'RateID' && sortOrder == 'DESC'}"><i class="typcn typcn-arrow-sorted-down sort-icon"></i></c:when>
                                                <c:otherwise><i class="typcn typcn-arrow-unsorted sort-icon"></i></c:otherwise>
                                            </c:choose>
                                        </th>
                                        <th>Sân</th>
                                        <th>Thứ</th>
                                        <th>Giờ bắt đầu</th>
                                        <th>Giờ kết thúc</th>
                                        <th>Giá/giờ</th>
                                        <th>Ngày lễ</th>
                                        <th>Hành động</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="rate" items="${rates}">
                                        <tr>
                                            <td>${rate.rateId}</td>
                                            <td>
                                                <c:forEach var="court" items="${courts}">
                                                    <c:if test="${court.courtId == rate.courtId}">${court.courtName}</c:if>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${rate.dayOfWeek == 0}">Chủ nhật</c:when>
                                                    <c:when test="${rate.dayOfWeek == 1}">Thứ 2</c:when>
                                                    <c:when test="${rate.dayOfWeek == 2}">Thứ 3</c:when>
                                                    <c:when test="${rate.dayOfWeek == 3}">Thứ 4</c:when>
                                                    <c:when test="${rate.dayOfWeek == 4}">Thứ 5</c:when>
                                                    <c:when test="${rate.dayOfWeek == 5}">Thứ 6</c:when>
                                                    <c:when test="${rate.dayOfWeek == 6}">Thứ 7</c:when>
                                                </c:choose>
                                            </td>
                                            <td>${rate.startHour}</td>
                                            <td>${rate.endHour}</td>
                                            <td>${rate.hourlyRate}</td>
                                            <td><c:if test="${rate.isHoliday}"><span class="badge-holiday">Lễ</span></c:if></td>
                                            <td>
                                                <button class="btn btn-warning btn-sm edit-btn"
                                                        data-id="${rate.rateId}"
                                                        data-court="${rate.courtId}"
                                                        data-dayofweek="${rate.dayOfWeek}"
                                                        data-starthour="${rate.startHour}"
                                                        data-endhour="${rate.endHour}"
                                                        data-hourlyrate="${rate.hourlyRate}"
                                                        data-isholiday="${rate.isHoliday}">
                                                    Sửa
                                                </button>
                                                <form method="post" action="court-rates-manager" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="rateId" value="${rate.rateId}">
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa giá này?')">Xóa</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <nav aria-label="Giá sân pagination">
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
                                <button class="btn btn-primary mt-2" data-toggle="modal" data-target="#addRateModal">Thêm giá mới</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal Thêm Giá Sân -->
<div class="modal fade" id="addRateModal" tabindex="-1" role="dialog" aria-labelledby="addRateModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="court-rates-manager">
                <div class="modal-header">
                    <h5 class="modal-title" id="addRateModalLabel">Thêm giá sân mới</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label for="addCourtId">Sân</label>
                        <select class="form-control" id="addCourtId" name="courtId" required>
                            <option value="">Chọn sân</option>
                            <c:forEach var="court" items="${courts}">
                                <option value="${court.courtId}">${court.courtName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="addDayOfWeek">Thứ</label>
                        <select class="form-control" id="addDayOfWeek" name="dayOfWeek" required>
                            <option value="0">Chủ nhật</option>
                            <option value="1">Thứ 2</option>
                            <option value="2">Thứ 3</option>
                            <option value="3">Thứ 4</option>
                            <option value="4">Thứ 5</option>
                            <option value="5">Thứ 6</option>
                            <option value="6">Thứ 7</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="addStartHour">Giờ bắt đầu</label>
                        <input type="time" class="form-control" id="addStartHour" name="startHour" required>
                    </div>
                    <div class="form-group">
                        <label for="addEndHour">Giờ kết thúc</label>
                        <input type="time" class="form-control" id="addEndHour" name="endHour" required>
                    </div>
                    <div class="form-group">
                        <label for="addHourlyRate">Giá/giờ</label>
                        <input type="number" class="form-control" id="addHourlyRate" name="hourlyRate" min="0" step="0.01" required>
                    </div>
                    <div class="form-group form-check">
                        <input type="checkbox" class="form-check-input" id="addIsHoliday" name="isHoliday">
                        <label class="form-check-label" for="addIsHoliday">Ngày lễ</label>
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
<!-- Modal Sửa Giá Sân -->
<div class="modal fade" id="editRateModal" tabindex="-1" role="dialog" aria-labelledby="editRateModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="court-rates-manager">
                <div class="modal-header">
                    <h5 class="modal-title" id="editRateModalLabel">Sửa giá sân</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" id="editRateId" name="rateId">
                    <div class="form-group">
                        <label for="editCourtId">Sân</label>
                        <select class="form-control" id="editCourtId" name="courtId" required>
                            <option value="">Chọn sân</option>
                            <c:forEach var="court" items="${courts}">
                                <option value="${court.courtId}">${court.courtName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editDayOfWeek">Thứ</label>
                        <select class="form-control" id="editDayOfWeek" name="dayOfWeek" required>
                            <option value="0">Chủ nhật</option>
                            <option value="1">Thứ 2</option>
                            <option value="2">Thứ 3</option>
                            <option value="3">Thứ 4</option>
                            <option value="4">Thứ 5</option>
                            <option value="5">Thứ 6</option>
                            <option value="6">Thứ 7</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editStartHour">Giờ bắt đầu</label>
                        <input type="time" class="form-control" id="editStartHour" name="startHour" required>
                    </div>
                    <div class="form-group">
                        <label for="editEndHour">Giờ kết thúc</label>
                        <input type="time" class="form-control" id="editEndHour" name="endHour" required>
                    </div>
                    <div class="form-group">
                        <label for="editHourlyRate">Giá/giờ</label>
                        <input type="number" class="form-control" id="editHourlyRate" name="hourlyRate" min="0" step="0.01" required>
                    </div>
                    <div class="form-group form-check">
                        <input type="checkbox" class="form-check-input" id="editIsHoliday" name="isHoliday">
                        <label class="form-check-label" for="editIsHoliday">Ngày lễ</label>
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
        $('#editRateId').val($(this).data('id'));
        $('#editCourtId').val($(this).data('court'));
        $('#editDayOfWeek').val($(this).data('dayofweek'));
        $('#editStartHour').val($(this).data('starthour'));
        $('#editEndHour').val($(this).data('endhour'));
        $('#editHourlyRate').val($(this).data('hourlyrate'));
        $('#editIsHoliday').prop('checked', $(this).data('isholiday') === true || $(this).data('isholiday') === 'true');
        $('#editRateModal').modal('show');
    });
});
function sortTable(sortBy) {
    var url = new URL(window.location);
    var currentSortBy = '${sortBy}';
    var currentSortOrder = '${sortOrder}';
    var newSortOrder = (currentSortBy === sortBy && currentSortOrder === 'ASC') ? 'DESC' : 'ASC';
    url.searchParams.set('sortBy', sortBy);
    url.searchParams.set('sortOrder', newSortOrder);
    if ('${courtId}') url.searchParams.set('courtId', '${courtId}');
    if ('${dayOfWeek}') url.searchParams.set('dayOfWeek', '${dayOfWeek}');
    if ('${isHoliday}') url.searchParams.set('isHoliday', '${isHoliday}');
    if ('${pageSize}') url.searchParams.set('pageSize', '${pageSize}');
    window.location.href = url.toString();
}
function goToPage(page) {
    var url = new URL(window.location);
    url.searchParams.set('page', page);
    if ('${courtId}') url.searchParams.set('courtId', '${courtId}');
    if ('${dayOfWeek}') url.searchParams.set('dayOfWeek', '${dayOfWeek}');
    if ('${isHoliday}') url.searchParams.set('isHoliday', '${isHoliday}');
    if ('${pageSize}') url.searchParams.set('pageSize', '${pageSize}');
    if ('${sortBy}') url.searchParams.set('sortBy', '${sortBy}');
    if ('${sortOrder}') url.searchParams.set('sortOrder', '${sortOrder}');
    window.location.href = url.toString();
}
</script>
</body>
</html> 