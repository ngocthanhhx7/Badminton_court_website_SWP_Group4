<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Design Homepage</title>
    <!-- Thêm các link css/js cần thiết nếu có -->
</head>
<body>
    <jsp:include page="../../header-manager_1.jsp" />
    <div class="main-panel">
        <div class="content-wrapper">
            <div class="row">
                <!-- Slider Table -->
                <div class="col-lg-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Quản lý Slider</h4>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tiêu đề</th>
                                            <th>Subtitle</th>
                                            <th>Ảnh nền</th>
                                            <th>Vị trí</th>
                                            <th>Trạng thái</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="slider" items="${sliders}">
                                            <tr>
                                                <td>${slider.sliderID}</td>
                                                <td>${slider.title}</td>
                                                <td>${slider.subtitle}</td>
                                                <td><img src="${slider.backgroundImage}" width="80"/></td>
                                                <td>${slider.position}</td>
                                                <td>
                                                    <button type="button" class="badge ${slider.isActive ? 'badge-success' : 'badge-danger'}">${slider.isActive ? 'Hoạt động' : 'Không hoạt động'}</button>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm">Sửa</button>
                                                    <button class="btn btn-danger btn-sm">Xóa</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <button class="btn btn-primary mt-2">Thêm mới Slider</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- AboutSection Table -->
                <div class="col-lg-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Quản lý About Section</h4>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tiêu đề</th>
                                            <th>Subtitle</th>
                                            <th>Nội dung</th>
                                            <th>Ảnh 1</th>
                                            <th>Ảnh 2</th>
                                            <th>Loại Section</th>
                                            <th>Trạng thái</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="about" items="${aboutSections}">
                                            <tr>
                                                <td>${about.aboutID}</td>
                                                <td>${about.title}</td>
                                                <td>${about.subtitle}</td>
                                                <td>${about.content}</td>
                                                <td><img src="${about.image1}" width="60"/></td>
                                                <td><img src="${about.image2}" width="60"/></td>
                                                <td>${about.sectionType}</td>
                                                <td>
                                                    <button type="button" class="badge ${about.isActive ? 'badge-success' : 'badge-danger'}">${about.isActive ? 'Hoạt động' : 'Không hoạt động'}</button>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm">Sửa</button>
                                                    <button class="btn btn-danger btn-sm">Xóa</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <button class="btn btn-primary mt-2">Thêm mới About Section</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Offer Table -->
                <div class="col-lg-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Quản lý Offer</h4>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tiêu đề</th>
                                            <th>Subtitle</th>
                                            <th>Mô tả</th>
                                            <th>Ảnh</th>
                                            <th>Sức chứa</th>
                                            <th>VIP</th>
                                            <th>Trạng thái</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="offer" items="${offers}">
                                            <tr>
                                                <td>${offer.offerID}</td>
                                                <td>${offer.title}</td>
                                                <td>${offer.subtitle}</td>
                                                <td>${offer.description}</td>
                                                <td><img src="${offer.imageUrl}" width="60"/></td>
                                                <td>${offer.capacity}</td>
                                                <td>
                                                    <button type="button" class="badge ${offer.isVIP ? 'badge-info' : 'badge-secondary'}">${offer.isVIP ? 'VIP' : 'Thường'}</button>
                                                </td>
                                                <td>
                                                    <button type="button" class="badge ${offer.isActive ? 'badge-success' : 'badge-danger'}">${offer.isActive ? 'Hoạt động' : 'Không hoạt động'}</button>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm">Sửa</button>
                                                    <button class="btn btn-danger btn-sm">Xóa</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <button class="btn btn-primary mt-2">Thêm mới Offer</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Video Table -->
                <div class="col-lg-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Quản lý Video</h4>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tiêu đề</th>
                                            <th>Subtitle</th>
                                            <th>Video URL</th>
                                            <th>Thumbnail</th>
                                            <th>Nổi bật</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="video" items="${videos}">
                                            <tr>
                                                <td>${video.videoID}</td>
                                                <td>${video.title}</td>
                                                <td>${video.subtitle}</td>
                                                <td><a href="${video.videoUrl}" target="_blank">${video.videoUrl}</a></td>
                                                <td><img src="${video.thumbnailUrl}" width="60"/></td>
                                                <td>
                                                    <button type="button" class="badge ${video.isFeatured ? 'badge-info' : 'badge-secondary'}">${video.isFeatured ? 'Nổi bật' : 'Thường'}</button>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm">Sửa</button>
                                                    <button class="btn btn-danger btn-sm">Xóa</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <button class="btn btn-primary mt-2">Thêm mới Video</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Contact Table -->
                <div class="col-lg-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Quản lý Contact</h4>
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
                                                    <button type="button" class="badge ${contact.isActive ? 'badge-success' : 'badge-danger'}">${contact.isActive ? 'Hoạt động' : 'Không hoạt động'}</button>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm">Sửa</button>
                                                    <button class="btn btn-danger btn-sm">Xóa</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <button class="btn btn-primary mt-2">Thêm mới Contact</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Instagram Table -->
                <div class="col-lg-12 grid-margin stretch-card">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title">Quản lý Instagram Feed</h4>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Ảnh</th>
                                            <th>Link Instagram</th>
                                            <th>Thứ tự hiển thị</th>
                                            <th>Trạng thái</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="insta" items="${instagrams}">
                                            <tr>
                                                <td>${insta.feedID}</td>
                                                <td><img src="${insta.imageUrl}" width="60"/></td>
                                                <td><a href="${insta.instagramLink}" target="_blank">${insta.instagramLink}</a></td>
                                                <td>${insta.displayOrder}</td>
                                                <td>
                                                    <button type="button" class="badge ${insta.isVisible ? 'badge-success' : 'badge-danger'}">${insta.isVisible ? 'Hiện' : 'Ẩn'}</button>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm">Sửa</button>
                                                    <button class="btn btn-danger btn-sm">Xóa</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <button class="btn btn-primary mt-2">Thêm mới Instagram Feed</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 