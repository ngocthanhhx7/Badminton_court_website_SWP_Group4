<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="models.UserDTO, models.AdminDTO" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- partial:partials/_navbar.html -->
<nav class="navbar col-lg-12 col-12 p-0 fixed-top d-flex flex-row">
    <div class="text-center navbar-brand-wrapper d-flex align-items-center justify-content-center">
        <a class="navbar-brand brand-logo" href="./page-manager"><img src="img/logo.svg" alt="logo"/></a>
        <a class="navbar-brand brand-logo-mini" href="./page-manager"><img src="img/logo-mini.svg" alt="logo"/></a>
        <button class="navbar-toggler navbar-toggler align-self-center d-none d-lg-flex" type="button" data-toggle="minimize">
            <span class="typcn typcn-th-menu"></span>
        </button>
    </div>
    <div class="navbar-menu-wrapper d-flex align-items-center justify-content-end">
        <ul class="navbar-nav mr-lg-2">
            <li class="nav-item  d-none d-lg-flex">
                <a class="nav-link" href="#">
                    Calendar
                </a>
            </li>
            <li class="nav-item  d-none d-lg-flex">
                <a class="nav-link active" href="#">
                    Statistic
                </a>
            </li>
            <li class="nav-item  d-none d-lg-flex">
                <a class="nav-link" href="#">
                    Employee
                </a>
            </li>
        </ul>
        <ul class="navbar-nav navbar-nav-right">
            <li class="nav-item d-none d-lg-flex  mr-2">
                <a class="nav-link" href="#">
                    Help
                </a>
            </li>
            <%
    Object accObj = session.getAttribute("acc");
    String avatarUrl = "https://cdn-icons-png.flaticon.com/512/149/149071.png";
    String username = "Guest";
    if (accObj != null && accObj instanceof models.UserDTO) {
        models.UserDTO user = (models.UserDTO) accObj;
        username = user.getUsername();
        String gender = user.getGender();
        if ("Male".equalsIgnoreCase(gender)) {
            avatarUrl = "https://symbols.vn/wp-content/uploads/2021/11/Anh-avatar-de-thuong-cho-nam.jpg";
        } else if ("Female".equalsIgnoreCase(gender)) {
            avatarUrl = "https://img6.thuthuatphanmem.vn/uploads/2022/10/23/hinh-avatar-chibi-cute_031501070.jpg";
        }
    }
            %>

            <li class="nav-item nav-profile dropdown">
                <a class="nav-link dropdown-toggle pl-0 pr-0 d-flex align-items-center" href="#" data-bs-toggle="dropdown" id="profileDropdown">
                    <img src="<%= avatarUrl %>" alt="Avatar" class="rounded-circle" width="35" height="35">
                    <span class="nav-profile-name ms-2 fw-bold text-white"><%= username %></span>
                </a>
                <div class="dropdown-menu dropdown-menu-right navbar-dropdown" aria-labelledby="profileDropdown">
                    <a class="dropdown-item" href="./view-profile">
                        <i class="typcn typcn-user text-primary me-2"></i>
                        View Profile
                    </a>
                    <a class="dropdown-item" href="change-password.jsp">
                        <i class="typcn typcn-cog text-primary me-2"></i>
                        Change Password
                    </a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item text-danger" href="./logout">
                        <i class="typcn typcn-power text-danger me-2"></i>
                        Logout
                    </a>
                </div>
            </li>

        </ul>
        <button class="navbar-toggler navbar-toggler-right d-lg-none align-self-center" type="button" data-toggle="offcanvas">
            <span class="typcn typcn-th-menu"></span>
        </button>
    </div>
</nav>
<!-- partial -->
<div class="container-fluid page-body-wrapper">
    <!-- partial:partials/_settings-panel.html -->
    <div class="theme-setting-wrapper">
        <div id="settings-trigger"><i class="typcn typcn-cog-outline"></i></div>
        <div id="theme-settings" class="settings-panel">
            <i class="settings-close typcn typcn-delete-outline"></i>
            <p class="settings-heading">SIDEBAR SKINS</p>
            <div class="sidebar-bg-options" id="sidebar-light-theme">
                <div class="img-ss rounded-circle bg-light border mr-3"></div>
                Light
            </div>
            <div class="sidebar-bg-options selected" id="sidebar-dark-theme">
                <div class="img-ss rounded-circle bg-dark border mr-3"></div>
                Dark
            </div>
            <p class="settings-heading mt-2">HEADER SKINS</p>
            <div class="color-tiles mx-0 px-4">
                <div class="tiles success"></div>
                <div class="tiles warning"></div>
                <div class="tiles danger"></div>
                <div class="tiles primary"></div>
                <div class="tiles info"></div>
                <div class="tiles dark"></div>
                <div class="tiles default border"></div>
            </div>
        </div>
    </div>
    <!-- partial -->
    <!-- partial:partials/_sidebar.html -->
    <nav class="sidebar sidebar-offcanvas" id="sidebar">
        <ul class="nav">
            <li class="nav-item">
                <div class="d-flex sidebar-profile">
                    <div class="sidebar-profile-image">
                        <img src="<%= avatarUrl %>" alt="image" class="rounded-circle" width="50" height="50">
                        <span class="sidebar-status-indicator"></span>
                    </div>
                    <div class="sidebar-profile-name">
                        <p class="sidebar-name">
                            <%= username %>
                        </p>
                        <p class="sidebar-designation">
                            Welcome
                        </p>
                    </div>
                </div>

                <div class="nav-search">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Type to search..." aria-label="search" aria-describedby="search">
                        <div class="input-group-append">
                            <span class="input-group-text" id="search">
                                <i class="typcn typcn-zoom"></i>
                            </span>
                        </div>
                    </div>
                </div>
                <p class="sidebar-menu-title">Dash menu</p>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="./page-manager">
                    <i class="typcn typcn-device-desktop menu-icon"></i>
                    <span class="menu-title">Dashboard <span class="badge badge-primary ml-3">New</span></span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="collapse" href="#ui-basic" aria-expanded="false" aria-controls="ui-basic">
                    <i class="typcn typcn-briefcase menu-icon"></i>
                    <span class="menu-title">UI Manager</span>
                    <i class="typcn typcn-chevron-right menu-arrow"></i>
                </a>
                <div class="collapse" id="ui-basic">
                    <ul class="nav flex-column sub-menu">
                        <li class="nav-item"> <a class="nav-link" href="./slider-manager">Slider</a></li>
                        <li class="nav-item"> <a class="nav-link" href="./about-manager">About</a></li>
                        <li class="nav-item"> <a class="nav-link" href="./offer-manager">Offer</a></li>
                        <li class="nav-item"> <a class="nav-link" href="./video-manager">Video</a></li>
                        <li class="nav-item"> <a class="nav-link" href="./contact-manager">Contact</a></li>
                        <li class="nav-item"> <a class="nav-link" href="./instagram-manager">Instagram</a></li>
                    </ul>
                </div>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="collapse" href="#form-elements" aria-expanded="false" aria-controls="form-elements">
                    <i class="typcn typcn-film menu-icon"></i>
                    <span class="menu-title">Account & Court Hub</span>
                    <i class="menu-arrow"></i>
                </a>
                <div class="collapse" id="form-elements">
                    <ul class="nav flex-column sub-menu">
                        <li class="nav-item"><a class="nav-link" href="./user-manager">User Account</a></li>
                        <li class="nav-item"><a class="nav-link" href="./admin-manager">Admin Account</a></li>
                        <li class="nav-item"><a class="nav-link" href="./court-manager">Court Manager</a></li>
                        <li class="nav-item"> <a class="nav-link" href="./sevice-manaer">Sevice Manager</a></li>
                    </ul>
                </div>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="collapse" href="#charts" aria-expanded="false" aria-controls="charts">
                    <i class="typcn typcn-chart-pie-outline menu-icon"></i>
                    <span class="menu-title">Sales</span>
                    <i class="menu-arrow"></i>
                </a>
                <div class="collapse" id="charts">
                    <ul class="nav flex-column sub-menu">
                        <li class="nav-item"> <a class="nav-link" href="pages/charts/chartjs.html">ChartJs</a></li>
                        <li class="nav-item"> <a class="nav-link" href="pages/charts/chartjs.html">ChartJs</a></li>
                    </ul>
                </div>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="collapse" href="#tables" aria-expanded="false" aria-controls="tables">
                    <i class="typcn typcn-th-small-outline menu-icon"></i>
                    <span class="menu-title">Statitics</span>
                    <i class="menu-arrow"></i>
                </a>
                <div class="collapse" id="tables">
                    <ul class="nav flex-column sub-menu">
                        <li class="nav-item"> <a class="nav-link" href="booking-manager">Booking</a></li>
                        <li class="nav-item"> <a class="nav-link" href="invoices-manager">Invoices</a></li>
                    </ul>
                </div>
            </li>
            <li class="nav-item">
                <a class="nav-link" data-toggle="collapse" href="#icons" aria-expanded="false" aria-controls="icons">
                    <i class="typcn typcn-compass menu-icon"></i>
                    <span class="menu-title">Icons</span>
                    <i class="menu-arrow"></i>
                </a>
                <div class="collapse" id="icons">
                    <ul class="nav flex-column sub-menu">
                        <li class="nav-item"> <a class="nav-link" href="pages/icons/mdi.html">Mdi icons</a></li>
                    </ul>
                </div>
            </li>
        </ul>
    </nav>