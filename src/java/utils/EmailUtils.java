//package utils;
//
//import jakarta.mail.*;
//import jakarta.mail.internet.*;
//import java.util.Properties;
//
//public class EmailUtils {
//
//    public static void sendEmail(String recipientEmail, String verifyCode) throws MessagingException {
//        // Thông tin cấu hình SMTP server (ví dụ Gmail)
//        String host = "smtp.gmail.com";
//        String port = "587";
//        final String senderEmail = "buivanthong10052004@gmail.com";   
//        final String senderPassword = "xjfo eorw wjbu nwbb";     
//
//        Properties props = new Properties();
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
//        props.put("mail.smtp.host", host);
//        props.put("mail.smtp.port", port);
//
//        // Tạo session xác thực
//        Session session = Session.getInstance(props, new Authenticator() {
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(senderEmail, senderPassword);
//            }
//        });
//
//        // Tạo message
//        Message message = new MimeMessage(session);
//        message.setFrom(new InternetAddress(senderEmail));
//        message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
//        message.setSubject("Mã xác minh email của bạn");
//        message.setText("Chào bạn,\n\nMã xác minh của bạn là: " + verifyCode + "\n\nCảm ơn bạn đã đăng ký!");
//
//        // Gửi mail
//        Transport.send(message);
//    }
//}

package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtils {

    // Thông tin tài khoản gửi email
    private static final String SENDER_EMAIL = "buivanthong10052004@gmail.com";
    private static final String SENDER_PASSWORD = "xjfo eorw wjbu nwbb"; // App password Gmail

    // Gửi mã xác minh tài khoản
    public static void sendVerificationEmail(String recipientEmail, String verifyCode) throws MessagingException {
        String subject = "Mã xác minh email của bạn";
        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px;'>"
                + "<p>Chào bạn,</p>"
                + "<p>Mã xác minh tài khoản của bạn là: <b style='color:blue'>" + verifyCode + "</b></p>"
                + "<p>Vui lòng nhập mã này để hoàn tất đăng ký tài khoản.</p>"
                + "<p>Trân trọng,<br>Hệ thống BadmintonHub</p>"
                + "</body></html>";
        sendEmail(recipientEmail, subject, htmlContent);
    }

    // Gửi email xác nhận thay đổi mật khẩu
    public static void sendPasswordChangedEmail(String recipientEmail, String newPassword) throws MessagingException {
        String subject = "Xác nhận thay đổi mật khẩu";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px;'>"
                + "<p>Xin chào,</p>"
                + "<p>Bạn vừa thay đổi mật khẩu thành công vào lúc <b>" + currentTime + "</b>.</p>"
                + "<p><b>Mật khẩu mới của bạn là:</b> <span style='color:blue'>" + newPassword + "</span></p>"
                + "<p>Nếu bạn không thực hiện việc này, vui lòng liên hệ với quản trị viên ngay.</p>"
                + "<p>Trân trọng,<br>Hệ thống BadmintonHub</p>"
                + "</body></html>";
        sendEmail(recipientEmail, subject, htmlContent);
    }

    // Hàm gửi email chung (HTML, hỗ trợ Unicode)
    private static void sendEmail(String recipientEmail, String subject, String htmlContent) throws MessagingException {
        String host = "smtp.gmail.com";
        String port = "587";

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
            }
        });

        MimeMessage message = new MimeMessage(session);
        message.setFrom(new InternetAddress(SENDER_EMAIL));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
        message.setSubject(subject, "UTF-8");
        message.setContent(htmlContent, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}

