<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Badminton Manager System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex bg-gray-50">
    <div id="header" class="w-64 h-screen fixed left-0 top-0 bg-[#FFF2AF] shadow-lg flex flex-col">
        <nav class="flex-grow">
            <ul id="main-menu" class="space-y-2">
                <li class="p-4 text-center">
                    <a href="./court-manager">
                        <img src="img/logo.png" 
                             alt="Logo" class="max-w-[100%] mx-auto"/>
                    </a>
                </li>
                <li>
                    <a href="./sales-report" class="block px-4 py-2 text-gray-700 hover:bg-indigo-500 hover:text-white transition-colors">Sales Report</a>
                </li>
                <li>
                    <a href="./order-management" class="block px-4 py-2 text-gray-700 hover:bg-indigo-500 hover:text-white transition-colors">Orders</a>
                </li>
                <li>
                    <a href="./court-manager" class="block px-4 py-2 text-gray-700 hover:bg-indigo-500 hover:text-white transition-colors">Products</a>
                </li>
                <li>
                    <a href="./user-manager" class="block px-4 py-2 text-gray-700 hover:bg-indigo-500 hover:text-white transition-colors">Members</a>
                </li>
                <li>
                    <a href="./admin-manager" class="block px-4 py-2 text-gray-700 hover:bg-indigo-500 hover:text-white transition-colors">Members</a>
                </li>
            </ul>
        </nav>
        <div class="header_login p-4 text-center border-t border-gray-200">
            <c:choose>
        <c:when test="${sessionScope.acc == null}">
            <a href="UI/register.jsp" class="text-indigo-600 hover:text-indigo-800 transition-colors">Register</a>
            <span class="text-gray-500 mx-2">/</span>
            <a href="UI/login.jsp" class="text-indigo-600 hover:text-indigo-800 transition-colors">Login</a>
        </c:when>

        <c:otherwise>
            <div class="flex items-center justify-center gap-2">
                <c:if test="${sessionScope.accType == 'google'}">
                    <img src="${sessionScope.acc.picture}" alt="Avatar" class="w-8 h-8 rounded-full">
                    <span class="text-gray-700">Welcome,</span> 
                    <a href="view-profile.jsp" class="text-indigo-600 hover:text-indigo-800 transition-colors font-medium">
                        ${sessionScope.acc.name}
                    </a>
                </c:if>
                <c:if test="${sessionScope.accType != 'google'}">
                    <span class="text-gray-700">Welcome,</span> 
                    <a href="view-profile.jsp" class="text-indigo-600 hover:text-indigo-800 transition-colors font-medium">
                        ${sessionScope.acc.username}
                    </a>
                </c:if>
                <span class="text-gray-500 mx-2">/</span>
                <a href="./logout" class="text-indigo-600 hover:text-indigo-800 transition-colors">Logout</a>
            </div>
        </c:otherwise>
    </c:choose>    
        </div>
    </div>
   
</body>
</html>