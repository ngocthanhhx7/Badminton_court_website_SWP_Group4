<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản lý lịch sân</title>
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
        .search-box { max-width: 200px; }
        .badge-status { padding: 5px 10px; border-radius: 4px; font-size: 12px; }
        .badge-available { background: #28a745; color: #fff; }
        .badge-booked { background: #dc3545; color: #fff; }
        .badge-maintenance { background: #ffc107; color: #212529; }
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
                            <h4 class="card-title">Quản lý lịch sân</h4>
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
                            <form method="get" action="court-scheduler-manager" class="row mb-3">
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
                                    <label for="courtType">Loại sân</label>
                                    <input type="text" class="form-control" id="courtType" name="courtType" value="${courtType}" placeholder="VD: Single, Double">
                                </div>
                                <div class="col-md-2">
                                    <label for="status">Trạng thái</label>
                                    <select class="form-control" id="status" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="Available" ${status == 'Available' ? 'selected' : ''}>Available</option>
                                        <option value="Booked" ${status == 'Booked' ? 'selected' : ''}>Booked</option>
                                        <option value="Maintenance" ${status == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label for="scheduleDate">Ngày</label>
                                    <input type="date" class="form-control" id="scheduleDate" name="scheduleDate" value="${scheduleDate}">
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
                                    <a href="court-scheduler-manager" class="btn btn-secondary"><i class="typcn typcn-refresh"></i> Làm mới</a>
                                </div>
                            </form>
                            <!-- Button to generate 7 days schedule -->
                            <form method="post" action="court-scheduler-manager" style="display:inline;">
                                <input type="hidden" name="action" value="generate7days">
                                <button type="submit" class="btn btn-success mb-3" onclick="return confirm('Bạn có chắc chắn muốn tạo lịch 7 ngày?');">
                                    <i class="typcn typcn-calendar-outline"></i> Tạo lịch 7 ngày
                                </button>
                            </form>
                            <!-- Pagination Info -->
                            <div class="pagination-info">
                                Hiển thị ${startRecord} - ${endRecord} của ${totalSchedules} lịch sân
                                <c:if test="${not empty courtId or not empty status or not empty courtType or not empty scheduleDate}">
                                    (đã lọc)
                                </c:if>
                            </div>
                            <!-- Table -->
                            <div class="table-responsive">
                                <table class="table table-bordered">
                                    <thead>
                                    <tr>
                                        <th class="sort-header" onclick="sortTable('ScheduleID')">ID
                                            <c:choose>
                                                <c:when test="${sortBy == 'ScheduleID' && sortOrder == 'ASC'}"><i class="typcn typcn-arrow-sorted-up sort-icon"></i></c:when>
                                                <c:when test="${sortBy == 'ScheduleID' && sortOrder == 'DESC'}"><i class="typcn typcn-arrow-sorted-down sort-icon"></i></c:when>
                                                <c:otherwise><i class="typcn typcn-arrow-unsorted sort-icon"></i></c:otherwise>
                                            </c:choose>
                                        </th>
                                        <th>Sân</th>
                                        <th>Loại sân</th>
                                        <th>Ngày</th>
                                        <th class="sort-header" onclick="sortTable('StartTime')">Bắt đầu
                                            <c:choose>
                                                <c:when test="${sortBy == 'StartTime' && sortOrder == 'ASC'}"><i class="typcn typcn-arrow-sorted-up sort-icon"></i></c:when>
                                                <c:when test="${sortBy == 'StartTime' && sortOrder == 'DESC'}"><i class="typcn typcn-arrow-sorted-down sort-icon"></i></c:when>
                                                <c:otherwise><i class="typcn typcn-arrow-unsorted sort-icon"></i></c:otherwise>
                                            </c:choose>
                                        </th>
                                        <th>Kết thúc</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày lễ</th>
                                        <th>Hành động</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="schedule" items="${schedules}">
                                        <tr>
                                            <td>${schedule.scheduleId}</td>
                                            <td>${schedule.courtName}</td>
                                            <td>${schedule.courtType}</td>
                                            <td>${schedule.scheduleDate}</td>
                                            <td>${schedule.startTime}</td>
                                            <td>${schedule.endTime}</td>
                                            <td>
                                                <span class="badge-status ${schedule.status == 'Available' ? 'badge-available' : (schedule.status == 'Booked' ? 'badge-booked' : 'badge-maintenance')}">
                                                    ${schedule.status}
                                                </span>
                                            </td>
                                            <td><c:if test="${schedule.holiday}"><span class="badge badge-warning">Lễ</span></c:if></td>
                                            <td>
                                                <button class="btn btn-warning btn-sm edit-btn"
                                                        data-id="${schedule.scheduleId}"
                                                        data-court="${schedule.courtId}"
                                                        data-date="${schedule.scheduleDate}"
                                                        data-start="${schedule.startTime}"
                                                        data-end="${schedule.endTime}"
                                                        data-status="${schedule.status}"
                                                        data-holiday="${schedule.holiday}">
                                                    Sửa
                                                </button>
                                                <form method="post" action="court-scheduler-manager" style="display:inline;">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch này?')">Xóa</button>
                                                </form>
                                                <form method="post" action="court-scheduler-manager" style="display:inline;">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                                    <input type="hidden" name="currentStatus" value="${schedule.status}">
                                                    <button type="submit" class="btn btn-info btn-sm">Đổi trạng thái</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <nav aria-label="Lịch sân pagination">
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
                                <button class="btn btn-primary mt-2" data-toggle="modal" data-target="#addScheduleModal">Thêm lịch mới</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal Thêm Lịch Sân -->
<div class="modal fade" id="addScheduleModal" tabindex="-1" role="dialog" aria-labelledby="addScheduleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="court-scheduler-manager">
                <div class="modal-header">
                    <h5 class="modal-title" id="addScheduleModalLabel">Thêm lịch sân mới</h5>
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
                        <label for="addScheduleDate">Ngày</label>
                        <input type="date" class="form-control" id="addScheduleDate" name="scheduleDate" required>
                    </div>
                    <div class="form-group">
                        <label for="addStartTime">Giờ bắt đầu</label>
                        <input type="time" class="form-control" id="addStartTime" name="startTime" required>
                    </div>
                    <div class="form-group">
                        <label for="addEndTime">Giờ kết thúc</label>
                        <input type="time" class="form-control" id="addEndTime" name="endTime" required>
                    </div>
                    <div class="form-group">
                        <label for="addStatus">Trạng thái</label>
                        <select class="form-control" id="addStatus" name="status" required>
                            <option value="Available">Available</option>
                            <option value="Booked">Booked</option>
                            <option value="Maintenance">Maintenance</option>
                        </select>
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
<!-- Modal Sửa Lịch Sân -->
<div class="modal fade" id="editScheduleModal" tabindex="-1" role="dialog" aria-labelledby="editScheduleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <form method="post" action="court-scheduler-manager">
                <div class="modal-header">
                    <h5 class="modal-title" id="editScheduleModalLabel">Sửa lịch sân</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" id="editScheduleId" name="scheduleId">
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
                        <label for="editScheduleDate">Ngày</label>
                        <input type="date" class="form-control" id="editScheduleDate" name="scheduleDate" required>
                    </div>
                    <div class="form-group">
                        <label for="editStartTime">Giờ bắt đầu</label>
                        <input type="time" class="form-control" id="editStartTime" name="startTime" required>
                    </div>
                    <div class="form-group">
                        <label for="editEndTime">Giờ kết thúc</label>
                        <input type="time" class="form-control" id="editEndTime" name="endTime" required>
                    </div>
                    <div class="form-group">
                        <label for="editStatus">Trạng thái</label>
                        <select class="form-control" id="editStatus" name="status" required>
                            <option value="Available">Available</option>
                            <option value="Booked">Booked</option>
                            <option value="Maintenance">Maintenance</option>
                        </select>
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
// Auto-hide alerts after 5 seconds
$(document).ready(function() {
    setTimeout(function() { $('.alert').fadeOut('slow'); }, 5000);
    // Edit button click
    $(document).on('click', '.edit-btn', function() {
        $('#editScheduleId').val($(this).data('id'));
        $('#editCourtId').val($(this).data('court'));
        $('#editScheduleDate').val($(this).data('date'));
        $('#editStartTime').val($(this).data('start'));
        $('#editEndTime').val($(this).data('end'));
        $('#editStatus').val($(this).data('status'));
        $('#editIsHoliday').prop('checked', $(this).data('holiday') === true || $(this).data('holiday') === 'true');
        $('#editScheduleModal').modal('show');
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
    if ('${status}') url.searchParams.set('status', '${status}');
    if ('${courtType}') url.searchParams.set('courtType', '${courtType}');
    if ('${scheduleDate}') url.searchParams.set('scheduleDate', '${scheduleDate}');
    if ('${pageSize}') url.searchParams.set('pageSize', '${pageSize}');
    window.location.href = url.toString();
}
function goToPage(page) {
    var url = new URL(window.location);
    url.searchParams.set('page', page);
    if ('${courtId}') url.searchParams.set('courtId', '${courtId}');
    if ('${status}') url.searchParams.set('status', '${status}');
    if ('${courtType}') url.searchParams.set('courtType', '${courtType}');
    if ('${scheduleDate}') url.searchParams.set('scheduleDate', '${scheduleDate}');
    if ('${pageSize}') url.searchParams.set('pageSize', '${pageSize}');
    if ('${sortBy}') url.searchParams.set('sortBy', '${sortBy}');
    if ('${sortOrder}') url.searchParams.set('sortOrder', '${sortOrder}');
    window.location.href = url.toString();
}
</script>
</body>
</html> 