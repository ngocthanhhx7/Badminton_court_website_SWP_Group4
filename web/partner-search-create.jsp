<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!doctype html>
<html class="no-js" lang="zxx">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>BadmintonHub - Create Partner Post</title>
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
        .popup_inner {
            display: none !important;
            visibility: hidden !important;
        }

        /* Fix z-index issues */
        .page-header {
            position: relative;
            z-index: 1;
        }

        .create-container {
            position: relative;
            z-index: 2;
            background: #f8f9fa;
            min-height: 100vh;
            padding: 20px 0;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 0;
            margin-bottom: 30px;
            text-align: center;
            position: relative;
            z-index: 1;
        }

        .create-form-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 40px;
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            z-index: 3;
        }

        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .section-title {
            color: #495057;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-control, .form-select, .form-control:focus, .form-select:focus {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s ease;
            height: 48px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }

        .create-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 15px 40px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .create-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .cancel-btn {
            background: #6c757d;
            border: none;
            padding: 15px 40px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            font-size: 16px;
            text-decoration: none;
        }

        .cancel-btn:hover {
            background: #5a6268;
            color: white;
        }

        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        .skill-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            margin-top: 10px;
        }

        .alert {
            border-radius: 8px;
            border: none;
        }

        /* Additional modal prevention */
        .mfp-bg,
        .mfp-wrap,
        .mfp-container,
        .mfp-content {
            display: none !important;
        }

        /* Ensure footer doesn't interfere */
        footer {
            position: relative;
            z-index: 0;
        }

        /* Prevent any overlay issues */
        body.partner-search-page {
            overflow-x: hidden;
        }

        .main-wrapper {
            position: relative;
            z-index: 1;
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
                    <i class="fa fa-plus-circle"></i> Create Partner Post
                </h1>
                <p class="lead mb-0">Find your ideal badminton partner</p>
            </div>
        </div>

    <div class="create-container">
        <div class="container">
            <!-- Back button -->
            <div class="mb-4">
                <a href="partner-search" class="btn btn-outline-secondary">
                    <i class="fa fa-arrow-left"></i> Back to Partner Search
                </a>
            </div>

            <div class="create-form-card">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        <i class="fa fa-exclamation-triangle"></i> ${error}
                    </div>
                </c:if>

                <form method="POST" action="partner-search">
                    <input type="hidden" name="action" value="create">
                    
                    <!-- Basic Information -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fa fa-info-circle"></i> Basic Information
                        </h4>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Post Title *</label>
                            <input type="text" class="form-control" name="title" required
                                   placeholder="e.g., Looking for doubles partner in District 1">
                            <div class="help-text">Make it clear and specific to attract the right partner</div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Description *</label>
                            <textarea class="form-control" name="description" rows="4" required
                                      placeholder="Describe what you're looking for, your playing style, availability, etc."></textarea>
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
                                    <option value="Beginner">Beginner</option>
                                    <option value="Intermediate">Intermediate</option>
                                    <option value="Advanced">Advanced</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Play Style *</label>
                                <select class="form-select" name="playStyle" required>
                                    <option value="">Select play style</option>
                                    <option value="Singles">Singles</option>
                                    <option value="Doubles">Doubles</option>
                                    <option value="Mixed">Mixed (Both)</option>
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
                                       placeholder="e.g., District 1, Ho Chi Minh City">
                                <div class="help-text">Where would you like to play?</div>
                            </div>
                            
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Max Distance (km)</label>
                                <input type="number" class="form-control" name="maxDistance" min="1" max="100"
                                       placeholder="10">
                                <div class="help-text">How far are you willing to travel?</div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Preferred Date & Time</label>
                            <input type="datetime-local" class="form-control" name="preferredDateTime">
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
                                    <option value="Phone">Phone Call</option>
                                    <option value="Message">Message Only</option>
                                    <option value="Both">Both Phone & Message</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Contact Information *</label>
                                <input type="text" class="form-control" name="contactInfo" required
                                       placeholder="Phone number or preferred contact method">
                                <div class="help-text">Your phone number or how people can reach you</div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Buttons -->
                    <div class="text-center">
                        <button type="submit" class="create-btn me-3">
                            <i class="fa fa-paper-plane"></i> Create Post
                        </button>
                        <a href="partner-search" class="cancel-btn">
                            <i class="fa fa-times"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
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
