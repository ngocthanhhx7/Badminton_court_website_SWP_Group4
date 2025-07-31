package controller.admin;

import dal.ContactInfoDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import models.ContactInfoDTO;
import utils.AccessControlUtil;

@WebServlet(name="ContactManagerController", urlPatterns={"/contact-manager"})
public class ContactManagerController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ContactManagerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ContactManagerController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // Kiểm tra phân quyền
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        try {
            // Get messages from session and remove them
            HttpSession session = request.getSession();
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
            }
            
            ContactInfoDAO contactDAO = new ContactInfoDAO();
            List<ContactInfoDTO> contacts = contactDAO.getAllContactInfo();
            request.setAttribute("contacts", contacts);
            
            request.getRequestDispatcher("contact-manager.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Kiểm tra phân quyền
        if (!AccessControlUtil.hasManagerAccess(request)) {
            response.sendRedirect(request.getContextPath() + "/access-denied.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            ContactInfoDAO contactDAO = new ContactInfoDAO();
            
            switch (action) {
                case "add":
                    handleAddContact(request, response, contactDAO);
                    break;
                case "edit":
                    handleEditContact(request, response, contactDAO);
                    break;
                case "delete":
                    handleDeleteContact(request, response, contactDAO);
                    break;
                case "toggleStatus":
                    handleToggleStatus(request, response, contactDAO);
                    break;
                default:
                    response.sendRedirect("contact-manager");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred: " + e.getMessage());
        }
    }
    
    private void handleAddContact(HttpServletRequest request, HttpServletResponse response, ContactInfoDAO contactDAO) 
            throws ServletException, IOException {
        String message = request.getParameter("message");
        String phoneNumber = request.getParameter("phoneNumber");
        HttpSession session = request.getSession();
        
        if (message != null && !message.trim().isEmpty() && phoneNumber != null && !phoneNumber.trim().isEmpty()) {
            ContactInfoDTO newContact = ContactInfoDTO.builder()
                    .message(message.trim())
                    .phoneNumber(phoneNumber.trim())
                    .isActive(true)
                    .build();
            
            boolean success = contactDAO.addContactInfo(newContact);
            if (success) {
                session.setAttribute("successMessage", "Thêm contact thành công!");
            } else {
                session.setAttribute("errorMessage", "Thêm contact thất bại!");
            }
        } else {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
        }
        
        response.sendRedirect("contact-manager");
    }
    
    private void handleEditContact(HttpServletRequest request, HttpServletResponse response, ContactInfoDAO contactDAO) 
            throws ServletException, IOException {
        String contactIdStr = request.getParameter("contactID");
        String message = request.getParameter("message");
        String phoneNumber = request.getParameter("phoneNumber");
        HttpSession session = request.getSession();
        
        if (contactIdStr != null && message != null && phoneNumber != null) {
            try {
                int contactId = Integer.parseInt(contactIdStr);
                ContactInfoDTO contact = ContactInfoDTO.builder()
                        .contactID(contactId)
                        .message(message.trim())
                        .phoneNumber(phoneNumber.trim())
                        .build();
                
                boolean success = contactDAO.updateContactInfo(contact);
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật contact thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật contact thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID contact không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin!");
        }
        
        response.sendRedirect("contact-manager");
    }
    
    private void handleDeleteContact(HttpServletRequest request, HttpServletResponse response, ContactInfoDAO contactDAO) 
            throws ServletException, IOException {
        String contactIdStr = request.getParameter("contactID");
        HttpSession session = request.getSession();
        
        if (contactIdStr != null) {
            try {
                int contactId = Integer.parseInt(contactIdStr);
                boolean success = contactDAO.deleteContactInfo(contactId);
                if (success) {
                    session.setAttribute("successMessage", "Xóa contact thành công!");
                } else {
                    session.setAttribute("errorMessage", "Xóa contact thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID contact không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID contact không được cung cấp!");
        }
        
        response.sendRedirect("contact-manager");
    }
    
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response, ContactInfoDAO contactDAO) 
            throws ServletException, IOException {
        String contactIdStr = request.getParameter("contactID");
        HttpSession session = request.getSession();
        
        if (contactIdStr != null) {
            try {
                int contactId = Integer.parseInt(contactIdStr);
                
                boolean success = contactDAO.toggleContactStatus(contactId);
                
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật trạng thái thành công!");
                } else {
                    session.setAttribute("errorMessage", "Cập nhật trạng thái thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID contact không hợp lệ!");
            }
        } else {
            session.setAttribute("errorMessage", "ID contact không được cung cấp!");
        }
        
        response.sendRedirect("contact-manager");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
