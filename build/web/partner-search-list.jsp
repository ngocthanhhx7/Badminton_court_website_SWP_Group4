<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Find Playing Partner</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        /* Hide booking modal and related elements on partner search pages */
        .white-popup-block,
        .mfp-hide,
        #test-form,
        .popup_box,
        .popup_inner,
        .mfp-bg,
        .mfp-wrap,
        .mfp-container,
        .mfp-content {
            display: none !important;
            visibility: hidden !important;
        }

        .partner-search-container {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 30px 0;
            position: relative;
            z-index: 2;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 120px 0 60px 0; /* Tăng padding-top nhiều hơn */
            margin-top: 0; /* Bỏ margin-top */
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .search-section {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .stats-bar {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .posts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px; /* Khoảng cách giữa các posts */
            margin-top: 20px;
            padding: 10px 0; /* Thêm padding để tránh post đầu tiên dính vào stats-bar */
            align-items: start; /* Căn chỉnh từ trên xuống */
        }

        .partner-post-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 25px;
            transition: all 0.3s ease;
            border: 1px solid #e9ecef;
            height: 100%; /* Đặt chiều cao bằng nhau */
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* Phân bố đều các phần tử */
        }

        .partner-post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .post-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .author-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .author-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #667eea;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        .skill-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .skill-beginner { background: #e8f5e8; color: #2e7d32; }
        .skill-intermediate { background: #fff3e0; color: #ef6c00; }
        .skill-advanced { background: #ffebee; color: #c62828; }

        .play-style-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 11px;
            margin-left: 5px;
        }

        .seeking-badge {
            background: #f3e5f5;
            color: #7b1fa2;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 11px;
            margin-left: 5px;
            font-weight: 500;
        }

        .post-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin: 20px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            color: #666;
            font-size: 14px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 5px 10px;
            background: white;
            border-radius: 15px;
            font-size: 13px;
            border: 1px solid #e9ecef;
        }

        .post-title {
            color: #333;
            font-weight: 600;
            margin-bottom: 15px;
            line-height: 1.4;
        }

        .post-description {
            color: #666;
            line-height: 1.6;
            margin-bottom: 20px;
            flex-grow: 1; /* Cho phép mô tả mở rộng để fill không gian */
            display: -webkit-box;
            -webkit-line-clamp: 4; /* Giới hạn tối đa 4 dòng */
            line-clamp: 4;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .post-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .post-footer {
            margin-top: auto; /* Đẩy footer xuống dưới cùng */
        }

        .view-detail-btn {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .view-detail-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .search-form {
            background: transparent;
            padding: 0;
            border-radius: 0;
            margin-bottom: 0;
        }

        .form-control, .form-select {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 14px;
            height: 48px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .search-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .clear-btn {
            background: #6c757d;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
        }

        .no-posts {
            text-align: center;
            padding: 60px 20px;
            color: #666;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        .no-posts {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .create-post-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: linear-gradient(45deg, #fcedc9, #dbaa32);
            color: white;
            border: none;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            font-size: 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .create-post-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
            color: white;
        }

        @media (max-width: 768px) {
            .page-header {
                padding: 100px 0 40px 0;
                margin-top: 0;
            }
            
            .posts-grid {
                grid-template-columns: 1fr;
                gap: 20px;
                padding: 5px 0;
            }
            
            .partner-post-card {
                height: auto; /* Cho phép chiều cao tự động trên mobile */
            }
            
            .post-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .post-meta {
                flex-direction: column;
                gap: 8px;
            }
            
            .meta-item {
                width: 100%;
                justify-content: flex-start;
            }
            
            .stats-bar {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }
        }
    </style>
</head>

<body class="partner-search-page">
    <div class="main-wrapper">
        <!-- Header -->
        <jsp:include page="header-user.jsp"/>
        
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <h1 class="mb-3">
                    <i class="fa fa-users"></i> Find Your Badminton Partner
                </h1>
                <p class="lead mb-0">Connect with players in your area and skill level</p>
            </div>
    </div>

    <div class="partner-search-container">
        <div class="container">
            <!-- Back button -->
            <div class="mb-4">
                <a href="./home" class="btn btn-outline-secondary">
                    <i class="fa fa-arrow-left"></i> Back to Home
                </a>
            </div>

            <!-- Search Section -->
            <div class="search-section">
                <h4 class="mb-4">
                    <i class="fa fa-search"></i> Search Partners
                </h4>
                
                <form method="GET" action="partner-search" class="search-form">
                    <input type="hidden" name="action" value="search">
                    
                    <div class="row g-3">
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label fw-bold">Location</label>
                            <input type="text" class="form-control" name="location" 
                                   value="${searchLocation}" placeholder="City or area">
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label fw-bold">Skill Level</label>
                            <select class="form-select" name="skillLevel">
                                <option value="">Any Level</option>
                                <option value="Beginner" ${searchSkillLevel == 'Beginner' ? 'selected' : ''}>Beginner</option>
                                <option value="Intermediate" ${searchSkillLevel == 'Intermediate' ? 'selected' : ''}>Intermediate</option>
                                <option value="Advanced" ${searchSkillLevel == 'Advanced' ? 'selected' : ''}>Advanced</option>
                            </select>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label fw-bold">Play Style</label>
                            <select class="form-select" name="playStyle">
                                <option value="">Any Style</option>
                                <option value="Singles" ${searchPlayStyle == 'Singles' ? 'selected' : ''}>Singles</option>
                                <option value="Doubles" ${searchPlayStyle == 'Doubles' ? 'selected' : ''}>Doubles</option>
                                <option value="Mixed" ${searchPlayStyle == 'Mixed' ? 'selected' : ''}>Mixed</option>
                            </select>
                        </div>
                        <div class="col-md-6 col-lg-3">
                            <label class="form-label fw-bold">Max Distance (km)</label>
                            <input type="number" class="form-control" name="maxDistance" 
                                   value="${searchMaxDistance}" placeholder="Within km" min="1" max="100">
                        </div>
                    </div>
                    
                    <div class="text-center mt-4">
                        <button type="submit" class="search-btn me-3">
                            <i class="fa fa-search"></i> Search Partners
                        </button>
                        <a href="partner-search" class="clear-btn">
                            <i class="fa fa-refresh"></i> Show All
                        </a>
                    </div>
                </form>
            </div>

            <!-- Stats Bar -->
            <div class="stats-bar">
                <div>
                    <strong>${partnerPosts.size()}</strong> posts found
                    <c:if test="${not empty searchLocation or not empty searchSkillLevel or not empty searchPlayStyle or not empty searchMaxDistance}">
                        <span class="text-muted">• Filtered results</span>
                    </c:if>
                </div>
                <div>
                    <a href="partner-search?action=create" class="btn btn-success">
                        <i class="fa fa-plus"></i> Create Post
                    </a>
                </div>
            </div>

            <!-- Posts List -->
            <c:choose>
                <c:when test="${empty partnerPosts}">
                    <div class="no-posts">
                        <i class="fa fa-users fa-4x mb-4 text-muted"></i>
                        <h4>No partner posts found</h4>
                        <p class="text-muted mb-4">Be the first to post and find your ideal badminton partner!</p>
                        <a href="partner-search?action=create" class="btn btn-primary btn-lg">
                            <i class="fa fa-plus"></i> Create First Post
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="posts-grid">
                        <c:forEach var="post" items="${partnerPosts}">
                            <div class="partner-post-card">
                                <div class="post-content">
                                    <div class="post-header">
                                        <div class="author-info">
                                            <div class="author-avatar">
                                                ${post.authorName.substring(0,1).toUpperCase()}
                                            </div>
                                            <div>
                                                <h6 class="mb-1 fw-bold">${post.authorName}</h6>
                                                <span class="skill-badge skill-${post.authorSportLevel.toLowerCase()}">
                                                    ${post.authorSportLevel}
                                                </span>
                                                <span class="play-style-badge">${post.playStyle}</span>
                                                <span class="seeking-badge">Looking for: ${post.skillLevel}</span>
                                            </div>
                                        </div>
                                        <small class="text-muted">
                                            ${post.createdAt.toString().substring(0, 16).replace("T", " ")}
                                        </small>
                                    </div>

                                    <h5 class="post-title mt-3 mb-2">${post.title}</h5>
                                    
                                    <p class="post-description text-muted">
                                        <c:choose>
                                            <c:when test="${post.description.length() > 120}">
                                                ${post.description.substring(0, 120)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${post.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </p>

                                    <div class="post-meta">
                                        <c:if test="${not empty post.preferredLocation}">
                                            <div class="meta-item">
                                                <i class="fa fa-map-marker-alt text-danger"></i>
                                                <span>${post.preferredLocation}</span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty post.preferredDateTime}">
                                            <div class="meta-item">
                                                <i class="fa fa-clock text-primary"></i>
                                                <span>${post.preferredDateTime.toString().substring(0, 16).replace("T", " ")}</span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty post.maxDistance}">
                                            <div class="meta-item">
                                                <i class="fa fa-route text-info"></i>
                                                <span>Within ${post.maxDistance}km</span>
                                            </div>
                                        </c:if>
                                        
                                        <div class="meta-item">
                                            <i class="fa fa-eye text-secondary"></i>
                                            <span>${post.viewCount} views</span>
                                        </div>
                                        
                                        <div class="meta-item">
                                            <i class="fa fa-comments text-success"></i>
                                            <span>${post.responseCount} responses</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="post-footer">
                                    <div class="text-center mt-4">
                                        <a href="partner-search?action=detail&id=${post.postID}" 
                                           class="view-detail-btn">
                                            <i class="fa fa-info-circle"></i> View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Include footer -->
    <jsp:include page="footer.jsp"/>
    </div> <!-- Close main-wrapper -->

    <script>
        // Prevent any modal/popup interference
        document.addEventListener('DOMContentLoaded', function() {
            // Hide any booking modals that might appear
            const popupElements = document.querySelectorAll('.white-popup-block, .mfp-hide, #test-form, .popup_box');
            popupElements.forEach(element => {
                element.style.display = 'none';
                element.style.visibility = 'hidden';
            });

            // Disable magnific popup if it exists
            if (typeof $.magnificPopup !== 'undefined') {
                $.magnificPopup.close();
            }

            // Ensure body classes don't interfere
            document.body.classList.remove('mfp-zoom-out-cur');
            document.body.classList.remove('mfp-ready');
        });
    </script>
</body>
</html>
