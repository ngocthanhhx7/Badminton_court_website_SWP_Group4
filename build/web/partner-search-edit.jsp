<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Edit Partner Search Post</title>
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

        .edit-post-container {
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

        .edit-form {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 30px;
            margin-bottom: 30px;
        }

        .form-control, .form-select {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            font-size: 15px;
            transition: all 0.3s ease;
            height: 48px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .save-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .save-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }

        .cancel-btn {
            background: #6c757d;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
        }

        .cancel-btn:hover {
            background: #5a6268;
            color: white;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .page-header {
                padding: 100px 0 40px 0;
            }

            .edit-form {
                padding: 20px;
            }
        }
    </style>
</head>

<body class="edit-post-page">
    <div class="main-wrapper">
        <!-- Header -->
        <jsp:include page="header-user.jsp"/>
        
        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <h1 class="mb-3">
                    <i class="fa fa-edit"></i> Edit Partner Search Post
                </h1>
                <p class="lead mb-0">Update your post details to find the perfect partner</p>
            </div>
        </div>

        <div class="edit-post-container">
            <div class="container">
                <!-- Back button -->
                <div class="mb-4">
                    <a href="partner-search" class="btn btn-outline-secondary">
                        <i class="fa fa-arrow-left"></i> Back to Partner Search
                    </a>
                </div>

                <div class="edit-form">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fa fa-exclamation-triangle"></i> ${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty post}">
                    <form method="POST" action="partner-search">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="postId" value="${post.postID}">

                        <!-- Basic Information -->
                        <div class="form-section">
                            <h4 class="section-title">
                                <i class="fa fa-info-circle"></i> Basic Information
                            </h4>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Post Title *</label>
                                <input type="text" class="form-control" name="title" required
                                       value="${post.title}" placeholder="e.g., Looking for doubles partner in District 1">
                                <div class="help-text">Make it clear and specific to attract the right partner</div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Description *</label>
                                <textarea class="form-control" name="description" rows="4" required
                                          placeholder="Describe what you're looking for, your playing style, availability, etc.">${post.description}</textarea>
                                <div class="help-text">Be detailed about your preferences and expectations</div>
                            </div>
                        </div>

                        <!-- Playing Preferences -->
                        <div class="form-section">
                            <h4 class="section-title">
                                <i class="fa fa-play-circle"></i> Playing Preferences
                            </h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Skill Level *</label>
                                    <select class="form-select" name="skillLevel" required>
                                        <option value="">Select your level</option>
                                        <option value="Beginner" ${post.skillLevel == 'Beginner' ? 'selected' : ''}>Beginner</option>
                                        <option value="Intermediate" ${post.skillLevel == 'Intermediate' ? 'selected' : ''}>Intermediate</option>
                                        <option value="Advanced" ${post.skillLevel == 'Advanced' ? 'selected' : ''}>Advanced</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Play Style *</label>
                                    <select class="form-select" name="playStyle" required>
                                        <option value="">Select play style</option>
                                        <option value="Singles" ${post.playStyle == 'Singles' ? 'selected' : ''}>Singles</option>
                                        <option value="Doubles" ${post.playStyle == 'Doubles' ? 'selected' : ''}>Doubles</option>
                                        <option value="Mixed" ${post.playStyle == 'Mixed' ? 'selected' : ''}>Mixed (Both)</option>
                                    </select>
                                </div>
                            </div>
                            <div class="skill-info">
                                <small>
                                    <strong>Skill Levels:</strong><br>
                                    <strong>Beginner:</strong> New to badminton or less than 1 year experience<br>
                                    <strong>Intermediate:</strong> 1-3 years experience, knows basic techniques<br>
                                    <strong>Advanced:</strong> 3+ years, competitive level, advanced techniques
                                </small>
                            </div>
                        </div>

                        <!-- Location & Time -->
                        <div class="form-section">
                            <h4 class="section-title">
                                <i class="fa fa-map-marker-alt"></i> Location & Timing
                            </h4>
                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label class="form-label fw-bold">Preferred Location</label>
                                    <input type="text" class="form-control" name="preferredLocation"
                                           value="${post.preferredLocation}" placeholder="e.g., District 1, Ho Chi Minh City">
                                    <div class="help-text">Where would you like to play?</div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label fw-bold">Max Distance (km)</label>
                                    <input type="number" class="form-control" name="maxDistance" min="1" max="100"
                                           value="${post.maxDistance}" placeholder="10">
                                    <div class="help-text">How far are you willing to travel?</div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold">Preferred Date & Time</label>
                                <input type="datetime-local" class="form-control" name="preferredDateTime" value="${post.preferredDateTime}">
                                <div class="help-text">When would you like to play? (Optional)</div>
                            </div>
                        </div>

                        <!-- Contact Information -->
                        <div class="form-section">
                            <h4 class="section-title">
                                <i class="fa fa-phone"></i> Contact Information
                            </h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Contact Method *</label>
                                    <select class="form-select" name="contactMethod" required>
                                        <option value="">How should people contact you?</option>
                                        <option value="Phone" ${post.contactMethod == 'Phone' ? 'selected' : ''}>Phone Call</option>
                                        <option value="Message" ${post.contactMethod == 'Message' ? 'selected' : ''}>Message Only</option>
                                        <option value="Both" ${post.contactMethod == 'Both' ? 'selected' : ''}>Both Phone & Message</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Contact Information *</label>
                                    <input type="text" class="form-control" name="contactInfo" required
                                           value="${post.contactInfo}" placeholder="Phone number or preferred contact method">
                                    <div class="help-text">Your phone number or how people can reach you</div>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Buttons -->
                        <div class="text-center">
                            <button type="submit" class="save-btn me-3">
                                <i class="fa fa-save"></i> Save Changes
                            </button>
                            <a href="partner-search" class="cancel-btn">
                                <i class="fa fa-times"></i> Cancel
                            </a>
                        </div>
                    </form>
                    </c:if>

                    <!-- Post not found -->
                    <c:if test="${empty post}">
                        <div class="text-center py-5">
                            <i class="fa fa-exclamation-triangle fa-4x text-warning mb-4"></i>
                            <h3>Post Not Found</h3>
                            <p class="text-muted">The partner search post you're looking for doesn't exist or has been removed.</p>
                            <a href="partner-search" class="cancel-btn">
                                <i class="fa fa-arrow-left"></i> Back to Search
                            </a>
                        </div>
                    </c:if>
                </div>
        </div>

        <!-- Include footer -->
        <jsp:include page="footer.jsp"/>
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
    </div> <!-- Close main-wrapper -->
</body>
</html>
