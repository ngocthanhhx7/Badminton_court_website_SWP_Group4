package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtils {

    public static void sendEmail(String recipientEmail, String verifyCode) throws MessagingException {
        // Thông tin cấu hình SMTP server (ví dụ Gmail)
        String host = "smtp.gmail.com";
        String port = "587";
        final String senderEmail = "buivanthong10052004@gmail.com";   
        final String senderPassword = "fovp fsbn ofam kjgr";     

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);

        // Tạo session xác thực
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        // Tạo message
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(senderEmail));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
        message.setSubject("Mã xác minh email của bạn");
        message.setText("Chào bạn,\n\nMã xác minh của bạn là: " + verifyCode + "\n\nCảm ơn bạn đã đăng ký!");

        // Gửi mail
        Transport.send(message);
    }
}