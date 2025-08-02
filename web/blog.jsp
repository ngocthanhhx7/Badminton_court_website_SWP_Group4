<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*, models.BlogPostDTO, dao.BlogPostDAO" %>

<%
    Integer userID = (Integer) session.getAttribute("userID");
    String username = (String) session.getAttribute("username");
    String accType = (String) session.getAttribute("accType");

    BlogPostDAO postDAO = new BlogPostDAO();
    List<BlogPostDTO> posts = postDAO.getByStatus("Published");
    request.setAttribute("posts", posts);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    
    
    <meta charset="UTF-8">
    <title>Blog</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- CSS layout để header hiển thị đúng -->
<link rel="stylesheet" href="css/owl.carousel.min.css">
<link rel="stylesheet" href="css/magnific-popup.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/themify-icons.css">
<link rel="stylesheet" href="css/nice-select.css">
<link rel="stylesheet" href="css/flaticon.css">
<link rel="stylesheet" href="css/gijgo.css">
<link rel="stylesheet" href="css/animate.css">
<link rel="stylesheet" href="css/slicknav.css">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/responsive.css">

    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .bradcam_area {
            padding: 100px 0;
            background: url('img/banner/bradcam2.png') center center/cover no-repeat;
            color: white;
            text-align: center;
            position: relative;
        }
        .bradcam_area::before {
            content: "";
            position: absolute;
            inset: 0;
            background-color: rgba(0, 0, 0, 0.4);
        }
        .bradcam_area h3 {
            position: relative;
            font-size: 48px;
            font-weight: bold;
            z-index: 1;
        }
        .blog_item {
            margin-bottom: 30px;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            transition: 0.3s;
            box-shadow: 0 6px 20px rgba(0,0,0,0.07);
        }
        .blog_item:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
        }
        .blog_item_img {
            width: 100%;
            height: 240px;
            object-fit: cover;
            border-bottom: 3px solid #007bff;
        }
        .blog_item_date {
            position: absolute;
            top: 15px;
            left: 15px;
            background: #007bff;
            color: white;
            padding: 8px 12px;
            border-radius: 5px;
            z-index: 2;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            text-align: center;
        }
        .blog_item_date h5 {
            margin: 0;
            font-size: 18px;
        }
        .blog_item_date small {
            font-size: 12px;
        }
        .blog_details {
            padding: 20px;
        }
        .blog_details h2 {
            font-size: 22px;
            color: #007bff;
            font-weight: bold;
            margin-bottom: 10px;
            transition: color 0.3s;
        }
        .blog_details h2:hover {
            color: #0056b3;
        }
        .blog_details p {
            color: #555;
            font-size: 15px;
            line-height: 1.6;
        }
        .blog-info-link {
            list-style: none;
            padding: 0;
            margin-top: 15px;
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #888;
        }
        .blog-info-link li {
            display: flex;
            align-items: center;
        }
        .blog-info-link i {
            margin-right: 5px;
            color: #007bff;
        }
        .blog_right_sidebar {
            padding: 30px;
            background-color: #f9f9f9;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }
        .search_widget input,
        .search_widget select {
            border-radius: 6px;
            padding: 10px 15px;
            font-size: 14px;
            border: 1px solid #ced4da;
        }
        .search_widget input:focus,
        .search_widget select:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .search_widget button {
            margin-top: 10px;
            padding: 10px;
            font-weight: bold;
            text-transform: uppercase;
        }
        @media (max-width: 768px) {
            .blog_item_img {
                height: 200px;
            }
            .blog_item_date {
                padding: 6px 10px;
            }
            .blog_details h2 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>

<!-- Header -->
<%
    if (accType == null) {
%>
    <jsp:include page="header.jsp" />
<%
    } else if ("admin".equals(accType)) {
%>
    <jsp:include page="header-auth.jsp" />
<%
    } else if ("user".equals(accType) || "google".equals(accType)) {
%>
    <jsp:include page="header-user.jsp" />
<%
    }
%>

<!-- Tiêu đề trang -->
<div class="bradcam_area">
    <h3>Blog</h3>
</div>

<!-- Nội dung chính -->
<section class="blog_area section-padding">
    <div class="container">
        <div class="row">
            <!-- Danh sách bài viết -->
            <div class="col-lg-8 mb-5 mb-lg-0">
                <div class="blog_left_sidebar">
                    <c:forEach var="post" items="${posts}">
                        <article class="blog_item">
                            <div class="position-relative">
                                <img class="card-img rounded-0 blog_item_img" src="${post.thumbnailUrl}" alt="Thumbnail">
                                <div class="blog_item_date">
                                    <h5><fmt:formatDate value="${post.publishedAt}" pattern="dd" /></h5>
                                    <small><fmt:formatDate value="${post.publishedAt}" pattern="MMM" /></small>
                                </div>
                            </div>
                            <div class="blog_details">
                                <a class="d-inline-block" href="post-detail.jsp?postID=${post.postID}">
                                    <h2>${post.title}</h2>
                                </a>
                                <p>${post.summary}</p>
                                <ul class="blog-info-link">
                                    <li><i class="fa fa-user"></i> ${post.authorID}</li>
                                    <li><i class="fa fa-eye"></i> ${post.viewCount} Views</li>
                                </ul>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </div>

            <!-- Sidebar tìm kiếm -->
       
        </div>
    </div>
</section>
<!-- jQuery (required for Bootstrap 5 JS in một số template) -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<!-- Bootstrap Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<jsp:include page="footer.jsp" />
<jsp:include page="header-user.jsp" />
</body>
</html>
