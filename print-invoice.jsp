<%-- 
    Document   : print-invoice
    Created on : Jun 18, 2025, 4:37:46 PM
    Author     : HP
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, models.InvoiceDetailView, dao.InvoiceDetailDAO" %>
<%
    String[] ids = request.getParameterValues("id");
    List<InvoiceDetailView> invoices = new ArrayList<>();
    InvoiceDetailDAO dao = new InvoiceDetailDAO();
    if (ids != null) {
        for (String sid : ids) {
            try {
                InvoiceDetailView item = dao.getInvoiceDetailByID(Integer.parseInt(sid));
                if (item != null) invoices.add(item);
            } catch (Exception e){}
        }
    }
%>
<!DOCTYPE html>
<html>
<head><title>Print Invoice</title></head>
<body onload="window.print()">
  <h2>Hóa đơn đã chọn</h2>
  <table border="1" cellspacing="0" cellpadding="5">
    <tr>
      <th>ID</th><th>InvoiceID</th><th>ItemName</th><th>Qty</th>
      <th>Unit Price</th><th>Subtotal</th><th>Status</th>
    </tr>
    <c:forEach var="item" items="${invoices}">
      <tr>
        <td>${item.invoiceDetailID}</td>
        <td>${item.invoiceID}</td>
        <td>${item.itemName}</td>
        <td>${item.quantity}</td>
        <td>${item.unitPrice}</td>
        <td>${item.subtotal}</td>
        <td>${item.status}</td>
      </tr>
    </c:forEach>
  </table>
</body>
</html>
