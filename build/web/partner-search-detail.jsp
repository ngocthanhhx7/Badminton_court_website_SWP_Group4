<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Partner Search Details</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/favicon.png">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Global functions for response form handling
        window.showResponseForm = function() {
            const responseForm = document.getElementById('responseForm');
            if (responseForm) {
                responseForm.style.display = 'block';
                responseForm.scrollIntoView({ behavior: 'smooth' });
            }
        };

        window.hideResponseForm = function() {
            const responseForm = document.getElementById('responseForm');
            if (responseForm) {
                responseForm.style.display = 'none';
            }
        };

        window.closePost = function(postId) {
            if (confirm('Are you sure you want to close this post? This action cannot be undone.')) {
                window.location.href = 'partner-search?action=close&id=' + postId;
            }
        };
        
        document.addEventListener('DOMContentLoaded', function() {
            // Hide any booking modals that might appear
            const popupElements = document.querySelectorAll('.white-popup-block, .mfp-hide, #test-form, .popup_box');
            popupElements.forEach(element => {
                element.style.display = 'none';
                element.style.visibility = 'hidden';
            });

            // Disable magnific popup if it exists
            if (typeof $ !== 'undefined' && typeof $.magnificPopup !== 'undefined') {
                $.magnificPopup.close();
            }

            // Ensure body classes don't interfere
            document.body.classList.remove('mfp-zoom-out-cur');
            document.body.classList.remove('mfp-ready');
        });
    </script>

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

        .partner-detail-container {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 30px 0;
            position: relative;
            z-index: 2;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 120px 0 60px 0;
            margin-top: 0;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .post-detail-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .post-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
        }

        .author-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .author-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 24px;
            border: 3px solid rgba(255,255,255,0.3);
        }

        .author-details h4 {
            margin: 0;
            font-weight: 600;
        }

        .skill-badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
            background: rgba(255,255,255,0.2);
            color: white;
            margin-top: 5px;
        }

        .play-style-badge {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            margin-left: 10px;
            margin-top: 5px;
        }

        .seeking-badge {
            display: inline-block;
            background: rgba(255,255,255,0.15);
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 12px;
            margin-left: 10px;
            margin-top: 5px;
            font-weight: 500;
        }

        .post-content {
            padding: 30px;
        }

        .post-title {
            color: #333;
            font-weight: 600;
            margin-bottom: 20px;
            font-size: 28px;
            line-height: 1.3;
        }

        .post-description {
            color: #666;
            line-height: 1.8;
            font-size: 16px;
            margin-bottom: 30px;
        }

        .post-meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 15px 20px;
            background: #f8f9fa;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }

        .meta-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }

        .meta-icon.location { background: #dc3545; }
        .meta-icon.time { background: #007bff; }
        .meta-icon.distance { background: #17a2b8; }
        .meta-icon.views { background: #6c757d; }
        .meta-icon.responses { background: #28a745; }

        .meta-text h6 {
            margin: 0;
            color: #333;
            font-weight: 600;
        }

        .meta-text span {
            color: #666;
            font-size: 14px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 30px;
        }

        .btn-respond {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-respond:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            color: white;
        }

        .btn-edit {
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
            color: white;
        }

        .btn-close {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-close:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
            color: white;
        }

        .responses-section {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .response-item {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .response-item:hover {
            border-color: #667eea;
            box-shadow: 0 2px 10px rgba(102, 126, 234, 0.1);
        }

        .response-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .response-author {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .response-avatar {
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

        .respond-form {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
        }

        .back-btn {
            background: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: #5a6268;
            color: white;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .page-header {
                padding: 100px 0 40px 0;
            }
            
            .post-content {
                padding: 20px;
            }
            
            .post-meta-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .responses-section {
                padding: 20px;
            }
        }
    </style>
</head>

<body class="partner-detail-page">
    <div class="main-wrapper">
        <!-- Header -->
        <jsp:include page="header-user.jsp"/>
        
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <h1 class="mb-3">
                    <i class="fa fa-info-circle"></i> Partner Search Details
                </h1>
                <p class="lead mb-0">View detailed information about this partner request</p>
            </div>
        </div>

        <div class="partner-detail-container">
            <div class="container">
                <!-- Back button -->
                <div class="mb-4">
                    <a href="partner-search" class="back-btn">
                        <i class="fa fa-arrow-left"></i> Back to Search
                    </a>
                </div>

                <!-- Success/Error Messages -->
                <c:if test="${param.success == 'updated'}">
                    <div class="alert alert-success">
                        <i class="fa fa-check-circle"></i> Post updated successfully!
                    </div>
                </c:if>
                <c:if test="${param.success == 'responded'}">
                    <div class="alert alert-success">
                        <i class="fa fa-check-circle"></i> Your response has been sent successfully!
                    </div>
                </c:if>
                <c:if test="${param.error == 'response_failed'}">
                    <div class="alert alert-danger">
                        <i class="fa fa-exclamation-circle"></i> Failed to send response. Please try again.
                    </div>
                </c:if>

                <!-- Post Details -->
                <c:if test="${not empty post}">
                    <div class="post-detail-card">
                        <!-- Post Header -->
                        <div class="post-header">
                            <div class="author-info">
                                <div class="author-avatar">
                                    ${post.authorName.substring(0,1).toUpperCase()}
                                </div>
                                <div class="author-details">
                                    <h4>${post.authorName}</h4>
                                    <div>
                                        <span class="skill-badge">
                                            ${post.authorSportLevel}
                                        </span>
                                        <span class="play-style-badge">${post.playStyle}</span>
                                        <span class="seeking-badge">Looking for: ${post.skillLevel}</span>
                                    </div>
                                </div>
                            </div>
                            <div class="text-end">
                                <small class="d-block text-white-50">Posted on</small>
                                <strong>${post.createdAt.toString().substring(0, 16).replace("T", " ")}</strong>
                            </div>
                        </div>

                        <!-- Post Content -->
                        <div class="post-content">
                            <h2 class="post-title">${post.title}</h2>
                            
                            <div class="post-description">
                                ${post.description}
                            </div>

                            <!-- Post Meta Information -->
                            <div class="post-meta-grid">
                                <c:if test="${not empty post.preferredLocation}">
                                    <div class="meta-item">
                                        <div class="meta-icon location">
                                            <i class="fa fa-map-marker-alt"></i>
                                        </div>
                                        <div class="meta-text">
                                            <h6>Preferred Location</h6>
                                            <span>${post.preferredLocation}</span>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty post.preferredDateTime}">
                                    <div class="meta-item">
                                        <div class="meta-icon time">
                                            <i class="fa fa-clock"></i>
                                        </div>
                                        <div class="meta-text">
                                            <h6>Preferred Time</h6>
                                            <span>${post.preferredDateTime.toString().substring(0, 16).replace("T", " ")}</span>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <c:if test="${not empty post.maxDistance}">
                                    <div class="meta-item">
                                        <div class="meta-icon distance">
                                            <i class="fa fa-route"></i>
                                        </div>
                                        <div class="meta-text">
                                            <h6>Maximum Distance</h6>
                                            <span>Within ${post.maxDistance} km</span>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <div class="meta-item">
                                    <div class="meta-icon views">
                                        <i class="fa fa-eye"></i>
                                    </div>
                                    <div class="meta-text">
                                        <h6>Views</h6>
                                        <span>${post.viewCount} people viewed</span>
                                    </div>
                                </div>
                                
                                <div class="meta-item">
                                    <div class="meta-icon responses">
                                        <i class="fa fa-comments"></i>
                                    </div>
                                    <div class="meta-text">
                                        <h6>Responses</h6>
                                        <span>${post.responseCount} responses</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="action-buttons">
                                <c:choose>
                                    <c:when test="${isOwner}">
                                        <a href="partner-search?action=edit&id=${post.postID}" class="btn-edit">
                                            <i class="fa fa-edit"></i> Edit Post
                                        </a>
                                        <c:if test="${post.status == 'Active'}">
                                            <button type="button" class="btn-close" onclick="window.closePost('${post.postID}')">
                                                <i class="fa fa-times"></i> Close Post
                                            </button>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${post.status == 'Active'}">
                                            <button type="button" class="btn-respond" onclick="window.showResponseForm()">
                                                <i class="fa fa-reply"></i> Respond to This Post
                                            </button>
                                        </c:if>
                                        <c:if test="${post.status != 'Active'}">
                                            <div class="alert alert-warning">
                                                <i class="fa fa-info-circle"></i> This post is no longer active
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Response Form (Hidden by default) -->
                    <c:if test="${not isOwner and post.status == 'Active'}">
                        <div id="responseForm" class="respond-form" style="display: none;">
                            <h4 class="mb-4">
                                <i class="fa fa-reply"></i> Send Response
                            </h4>
                            <form method="POST" action="partner-search">
                                <input type="hidden" name="action" value="respond">
                                <input type="hidden" name="postId" value="${post.postID}">
                                
                                <div class="mb-3">
                                    <label for="message" class="form-label fw-bold">Your Message</label>
                                    <textarea class="form-control" id="message" name="message" rows="4" 
                                              placeholder="Introduce yourself and explain why you'd be a great playing partner..."
                                              required></textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="contactInfo" class="form-label fw-bold">Contact Information</label>
                                    <input type="text" class="form-control" id="contactInfo" name="contactInfo" 
                                           placeholder="Phone number, email, or preferred contact method"
                                           required>
                                </div>
                                
                                <div class="text-center">
                                    <button type="submit" class="btn-respond me-3">
                                        <i class="fa fa-paper-plane"></i> Send Response
                                    </button>
                                    <button type="button" class="back-btn" onclick="window.hideResponseForm()">
                                        <i class="fa fa-times"></i> Cancel
                                    </button>
                                </div>
                            </form>
                        </div>
                    </c:if>

                    <!-- Responses Section: Hiển thị cho tất cả user -->
                    <div class="responses-section">
                        <h4 class="mb-4">
                            <i class="fa fa-comments"></i> Responses
                        </h4>
                        <c:choose>
                            <c:when test="${not empty responses}">
                                <c:forEach var="response" items="${responses}">
                                    <div class="response-item">
                                        <div class="response-header">
                                            <div class="response-author">
                                                <div class="response-avatar">
                                                    ${response.responderName.substring(0,1).toUpperCase()}
                                                </div>
                                                <div>
                                                    <h6 class="mb-1">${response.responderName}</h6>
                                                    <small class="text-muted">
                                                        ${response.createdAt.toString().substring(0, 16).replace("T", " ")}
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="response-content">
                                            <p class="mb-2">${response.message}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center text-muted py-4">
                                    <i class="fa fa-inbox fa-2x mb-2"></i><br>
                                    No responses yet. Be the first to respond!
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <!-- Post not found -->
                <c:if test="${empty post}">
                    <div class="text-center py-5">
                        <i class="fa fa-exclamation-triangle fa-4x text-warning mb-4"></i>
                        <h3>Post Not Found</h3>
                        <p class="text-muted">The partner search post you're looking for doesn't exist or has been removed.</p>
                        <a href="partner-search" class="back-btn">
                            <i class="fa fa-arrow-left"></i> Back to Search
                        </a>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Include footer -->
        <jsp:include page="footer.jsp"/>
    </div> <!-- Close main-wrapper -->

</body>
</html>
