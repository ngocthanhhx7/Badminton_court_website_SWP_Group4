package controllerUser;

import java.io.IOException;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Lấy thông tin từ form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Cấu hình email
        final String username = "nguyenngocthanhhx7@gmail.com";
        final String password = "gxqf nwwa vebx iavq";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        props.put("mail.debug", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            // Tạo email
            Message emailMessage = new MimeMessage(session);
            emailMessage.setFrom(new InternetAddress(username));
            emailMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(username));
            emailMessage.setSubject("Contact Form: " + subject);
            
            // Tạo nội dung email
            String emailContent = "Name: " + name + "\n"
                    + "Email: " + email + "\n"
                    + "Subject: " + subject + "\n\n"
                    + "Message:\n" + message;
            
            emailMessage.setText(emailContent);

            // Gửi email
            Transport.send(emailMessage);

            // Chuyển hướng với thông báo thành công
            response.sendRedirect("contact.jsp?status=success");
        } catch (MessagingException e) {
            e.printStackTrace(); // In ra log để debug
            // Chuyển hướng với thông báo lỗi
            response.sendRedirect("contact.jsp?status=error");
        }
    }
} 
