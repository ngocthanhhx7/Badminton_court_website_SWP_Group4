<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - My Partner Posts</title>
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

        .my-posts-container {
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px 0;
            position: relative;
            z-index: 2;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 120px 0;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            text-align: center;
            border-left: 4px solid #667eea;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .posts-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .post-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            padding: 25px;
            transition: all 0.3s ease;
            position: relative;
            border-top: 4px solid #667eea;
        }

        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .post-header {
            display: flex;
            justify-content: between;
            align-items: flex-start;
            margin-bottom: 15px;
            gap: 15px;
        }

        .post-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333;
            margin: 0;
            flex: 1;
            line-height: 1.4;
        }

        .post-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-closed {
            background: #e2e3e5;
            color: #495057;
            text-decoration: line-through;
        }

        .post-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 15px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: #495057;
        }

        .meta-icon {
            color: #667eea;
            width: 16px;
        }

        .post-description {
            color: #6c757d;
            font-size: 0.95rem;
            line-height: 1.5;
            margin: 15px 0;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .post-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0 15px 0;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.85rem;
            color: #6c757d;
        }

        .post-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-post {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-view {
            background: #667eea;
            color: white;
        }

        .btn-view:hover {
            background: #5a67d8;
            color: white;
        }

        .btn-edit {
            background: #28a745;
            color: white;
        }

        .btn-edit:hover {
            background: #218838;
            color: white;
        }

        .btn-delete {
            background: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background: #c82333;
            color: white;
        }

        .btn-toggle {
            background: #ffc107;
            color: #212529;
        }

        .btn-toggle:hover {
            background: #e0a800;
            color: #212529;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
        }

        .empty-icon {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .empty-title {
            font-size: 1.5rem;
            color: #495057;
            margin-bottom: 10px;
        }

        .empty-subtitle {
            color: #6c757d;
            margin-bottom: 30px;
        }

        .create-first-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .create-first-btn:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .page-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .create-new-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .create-new-btn:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .back-btn {
            background: #6c757d;
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-btn:hover {
            background: #5a6268;
            color: white;
        }

        @media (max-width: 768px) {
            .posts-grid {
                grid-template-columns: 1fr;
            }
            
            .post-meta {
                grid-template-columns: 1fr;
                gap: 10px;
            }
            
            .post-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .page-actions {
                flex-direction: column;
                align-items: stretch;
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
                    <i class="fa fa-user-circle"></i> My Partner Posts
                </h1>
                <p class="lead mb-0">Manage your partner search posts</p>
            </div>
        </div>

    <div class="my-posts-container">
        <div class="container">
            <div class="page-actions">
                <a href="partner-search" class="back-btn">
                    <i class="fa fa-arrow-left"></i> Back to Partner Search
                </a>
                <a href="partner-search?action=create" class="create-new-btn">
                    <i class="fa fa-plus"></i> Create New Post
                </a>
            </div>

            <!-- Status Messages -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fa fa-check-circle"></i>
                    <c:choose>
                        <c:when test="${param.success == 'activated'}">Post activated successfully!</c:when>
                        <c:when test="${param.success == 'deactivated'}">Post closed successfully!</c:when>
                        <c:when test="${param.success == 'closed'}">Post closed successfully!</c:when>
                        <c:when test="${param.success == 'restored'}">Post restored successfully!</c:when>
                        <c:when test="${param.success == 'closed'}">Post closed successfully!</c:when>
                        <c:otherwise>Action completed successfully!</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fa fa-exclamation-triangle"></i>
                    <c:choose>
                        <c:when test="${param.error == 'activation_failed'}">Failed to activate post. Please try again.</c:when>
                        <c:when test="${param.error == 'deactivation_failed'}">Failed to close post. Please try again.</c:when>
                        <c:when test="${param.error == 'deletion_failed'}">Failed to delete post. Please try again.</c:when>
                        <c:when test="${param.error == 'restore_failed'}">Failed to restore post. Please try again.</c:when>
                        <c:when test="${param.error == 'close_failed'}">Failed to close post. Please try again.</c:when>
                        <c:otherwise>An error occurred. Please try again.</c:otherwise>
                    </c:choose>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty myPosts}">
                    <!-- Empty State -->
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fa fa-search"></i>
                        </div>
                        <h3 class="empty-title">No Partner Posts Yet</h3>
                        <p class="empty-subtitle">
                            You haven't created any partner search posts yet.<br>
                            Start by creating your first post to find playing partners!
                        </p>
                        <a href="partner-search?action=create" class="create-first-btn">
                            <i class="fa fa-plus"></i> Create Your First Post
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Statistics Cards -->
                    <div class="stats-cards">
                        <div class="stat-card">
                            <div class="stat-number">${myPosts.size()}</div>
                            <div class="stat-label">Total Posts</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">
                                <c:set var="activeCount" value="0"/>
                                <c:forEach var="post" items="${myPosts}">
                                    <c:if test="${post.active}">
                                        <c:set var="activeCount" value="${activeCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${activeCount}
                            </div>
                            <div class="stat-label">Active Posts</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">
                                <c:set var="totalViews" value="0"/>
                                <c:forEach var="post" items="${myPosts}">
                                    <c:set var="totalViews" value="${totalViews + post.viewCount}"/>
                                </c:forEach>
                                ${totalViews}
                            </div>
                            <div class="stat-label">Total Views</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-number">
                                <c:set var="totalResponses" value="0"/>
                                <c:forEach var="post" items="${myPosts}">
                                    <c:set var="totalResponses" value="${totalResponses + post.responseCount}"/>
                                </c:forEach>
                                ${totalResponses}
                            </div>
                            <div class="stat-label">Total Responses</div>
                        </div>
                    </div>

                    <!-- Posts Grid -->
                    <div class="posts-grid">
                        <c:forEach var="post" items="${myPosts}">
                            <div class="post-card">
                                <div class="post-header">
                                    <h3 class="post-title">${post.title}</h3>
                                    <span class="post-status ${post.active ? 'status-active' : 'status-closed'}">
                                        ${post.active ? 'Active' : 'Closed'}
                                    </span>
                                </div>

                                <div class="post-meta">
                                    <div class="meta-item">
                                        <i class="fa fa-dumbbell meta-icon"></i>
                                        <span>${post.skillLevel}</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fa fa-play meta-icon"></i>
                                        <span>${post.playStyle}</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fa fa-map-marker-alt meta-icon"></i>
                                        <span>${not empty post.preferredLocation ? post.preferredLocation : 'Any location'}</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fa fa-calendar meta-icon"></i>
                                        <span>
                                            <fmt:formatDate value="${post.createdAt}" pattern="MMM dd, yyyy"/>
                                        </span>
                                    </div>
                                </div>

                                <p class="post-description">${post.description}</p>

                                <div class="post-stats">
                                    <div class="stat-item">
                                        <i class="fa fa-eye"></i>
                                        <span>${post.viewCount} views</span>
                                    </div>
                                    <div class="stat-item">
                                        <i class="fa fa-comment"></i>
                                        <span>${post.responseCount} responses</span>
                                    </div>
                                    <div class="stat-item">
                                        <i class="fa fa-clock"></i>
                                        <span>
                                            <fmt:formatDate value="${post.createdAt}" pattern="MMM dd"/>
                                        </span>
                                    </div>
                                </div>

                                <div class="post-actions">
                                    <a href="partner-search?action=detail&id=${post.id}" class="btn-post btn-view">
                                        <i class="fa fa-eye"></i> View
                                    </a>
                                    <a href="partner-search?action=edit&id=${post.id}" class="btn-post btn-edit">
                                        <i class="fa fa-edit"></i> Edit
                                    </a>
                                    <button onclick="togglePostStatus('${post.id}', '${post.active}')" 
                                            class="btn-post btn-toggle">
                                        <i class="fa fa-${post.active ? 'pause' : 'play'}"></i> 
                                        ${post.active ? 'Close' : 'Activate'}
                                    </button>
                                    <button onclick="deletePost('${post.id}')" class="btn-post btn-delete">
                                        <i class="fa fa-trash"></i> Delete
                                    </button>
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

        function togglePostStatus(postId, isActiveStr) {
            const isActive = isActiveStr === 'true';
            const action = isActive ? 'deactivate' : 'activate';
            const confirmMessage = isActive ? 
                'Are you sure you want to close this post? It will no longer be visible to others.' :
                'Are you sure you want to activate this post? It will be visible to others.';
            
            if (confirm(confirmMessage)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'partner-search';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = action;
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = postId;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function deletePost(postId) {
            if (confirm('Are you sure you want to delete this post? The post will be marked as closed but can be restored later.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'partner-search';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = postId;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
