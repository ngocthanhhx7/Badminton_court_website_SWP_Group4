<%-- 
    Document   : updateStatus
    Created on : Jun 11, 2025, 12:48:58 AM
    Author     : HP
--%>

<%@ page import="dao.BookingDAO" %>
<%
    int bookingID = Integer.parseInt(request.getParameter("bookingID"));
    String newStatus = request.getParameter("newStatus");

    BookingDAO dao = new BookingDAO();
    dao.updateBookingStatus(bookingID, newStatus);

    response.sendRedirect("view-revenue.jsp"); // quay l?i trang danh sách
%>
