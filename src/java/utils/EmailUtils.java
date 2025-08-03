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

    // Gửi mã xác minh để đặt lại mật khẩu
    public static void sendPasswordResetVerificationEmail(String recipientEmail, String verifyCode) throws MessagingException {
        String subject = "Mã xác minh đặt lại mật khẩu - BadmintonHub";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px; color:#333;'>"
                + "<div style='max-width:600px; margin:0 auto; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
                + "<div style='text-align:center; background-color:#007bff; color:white; padding:20px; border-radius:8px 8px 0 0; margin:-20px -20px 20px -20px;'>"
                + "<h1 style='margin:0; font-size:24px;'>🏸 BadmintonHub</h1>"
                + "<h2 style='margin:10px 0 0 0; font-size:18px; font-weight:normal;'>Đặt lại mật khẩu</h2>"
                + "</div>"
                
                + "<p>Xin chào,</p>"
                + "<p>Bạn vừa yêu cầu đặt lại mật khẩu cho tài khoản BadmintonHub.</p>"
                
                + "<div style='background-color:#f8f9fa; padding:20px; border-radius:8px; margin:20px 0; text-align:center;'>"
                + "<h3 style='color:#007bff; margin-top:0;'>🔐 Mã xác minh của bạn:</h3>"
                + "<div style='background-color:white; border:2px solid #007bff; border-radius:8px; padding:15px; margin:10px 0;'>"
                + "<span style='font-size:32px; font-weight:bold; color:#007bff; letter-spacing:3px;'>" + verifyCode + "</span>"
                + "</div>"
                + "<p style='color:#6c757d; margin:10px 0 0 0; font-size:12px;'>Mã này có hiệu lực trong <b>10 phút</b></p>"
                + "</div>"
                
                + "<div style='background-color:#fff3cd; border:1px solid #ffc107; border-radius:8px; padding:15px; margin:20px 0;'>"
                + "<h4 style='color:#856404; margin-top:0;'>⚠️ Lưu ý quan trọng:</h4>"
                + "<ul style='margin:0; padding-left:20px; color:#856404;'>"
                + "<li>Mã xác minh này chỉ có hiệu lực trong <b>10 phút</b></li>"
                + "<li>Không chia sẻ mã này với bất kỳ ai</li>"
                + "<li>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này</li>"
                + "</ul>"
                + "</div>"
                
                + "<div style='text-align:center; margin:30px 0;'>"
                + "<p style='margin:10px 0;'>📞 <b>Hotline:</b> 0123-456-789</p>"
                + "<p style='margin:10px 0;'>📧 <b>Email:</b> support@badmintonhub.com</p>"
                + "</div>"
                
                + "<div style='border-top:1px solid #dee2e6; padding-top:20px; margin-top:30px; text-align:center; color:#6c757d; font-size:12px;'>"
                + "<p>Email này được gửi tự động vào lúc " + currentTime + "</p>"
                + "<p>Trân trọng,<br><b style='color:#007bff;'>Đội ngũ BadmintonHub</b></p>"
                + "</div>"
                + "</div>"
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

    // Gửi email thông báo đặt sân thành công
    public static void sendBookingConfirmationEmail(String recipientEmail, String customerName, 
            String bookingId, String courtName, String courtType, String startTime, 
            String endTime, String amount, String paymentMethod) throws MessagingException {
        String subject = "Xác nhận đặt sân thành công - BadmintonHub";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px; color:#333;'>"
                + "<div style='max-width:600px; margin:0 auto; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
                + "<div style='text-align:center; background-color:#007bff; color:white; padding:20px; border-radius:8px 8px 0 0; margin:-20px -20px 20px -20px;'>"
                + "<h1 style='margin:0; font-size:24px;'>🏸 BadmintonHub</h1>"
                + "<h2 style='margin:10px 0 0 0; font-size:18px; font-weight:normal;'>Xác nhận đặt sân thành công</h2>"
                + "</div>"
                
                + "<p>Xin chào <b style='color:#007bff;'>" + customerName + "</b>,</p>"
                + "<p>Cảm ơn bạn đã đặt sân tại BadmintonHub! Thanh toán của bạn đã được xử lý thành công.</p>"
                
                + "<div style='background-color:#f8f9fa; padding:20px; border-radius:8px; margin:20px 0;'>"
                + "<h3 style='color:#007bff; margin-top:0;'>📋 Thông tin đặt sân:</h3>"
                + "<table style='width:100%; border-collapse:collapse;'>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Mã đặt sân:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6; color:#007bff; font-weight:bold;'>#" + bookingId + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Sân:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + courtName + " (" + courtType + ")</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Thời gian:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + startTime + " - " + endTime + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Phương thức thanh toán:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + paymentMethod + "</td></tr>"
                + "<tr><td style='padding:8px 0;'><b>Số tiền đã thanh toán:</b></td><td style='padding:8px 0; color:#28a745; font-weight:bold; font-size:16px;'>" + amount + " VNĐ</td></tr>"
                + "</table>"
                + "</div>"
                
                + "<div style='background-color:#e8f5e8; border:1px solid #28a745; border-radius:8px; padding:15px; margin:20px 0;'>"
                + "<p style='margin:0; color:#28a745;'><b>✅ Trạng thái:</b> Đã xác nhận và thanh toán thành công</p>"
                + "</div>"
                
                + "<h3 style='color:#007bff;'>📝 Lưu ý quan trọng:</h3>"
                + "<ul style='line-height:1.6;'>"
                + "<li>Vui lòng có mặt <b>15 phút trước</b> giờ đặt sân</li>"
                + "<li>Mang theo giày thể thao phù hợp</li>"
                + "<li>Liên hệ với chúng tôi nếu cần hỗ trợ thêm</li>"
                + "<li>Có thể hủy sân trước <b>2 tiếng</b> để được hoàn tiền</li>"
                + "</ul>"
                
                + "<div style='text-align:center; margin:30px 0;'>"
                + "<p style='margin:10px 0;'>📞 <b>Hotline:</b> 0123-456-789</p>"
                + "<p style='margin:10px 0;'>📧 <b>Email:</b> support@badmintonhub.com</p>"
                + "<p style='margin:10px 0;'>🌐 <b>Website:</b> www.badmintonhub.com</p>"
                + "</div>"
                
                + "<div style='border-top:1px solid #dee2e6; padding-top:20px; margin-top:30px; text-align:center; color:#6c757d; font-size:12px;'>"
                + "<p>Email này được gửi tự động vào lúc " + currentTime + "</p>"
                + "<p>Trân trọng,<br><b style='color:#007bff;'>Đội ngũ BadmintonHub</b></p>"
                + "</div>"
                + "</div>"
                + "</body></html>";
        sendEmail(recipientEmail, subject, htmlContent);
    }

    // Gửi email thông báo hủy đặt sân
    public static void sendBookingCancellationEmail(String recipientEmail, String customerName, 
            String bookingId, java.util.List<String> courtDetails) throws MessagingException {
        String subject = "Xác nhận hủy đặt sân - BadmintonHub";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        StringBuilder courtInfo = new StringBuilder();
        for (String courtDetail : courtDetails) {
            courtInfo.append(courtDetail);
        }

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px; color:#333;'>"
                + "<div style='max-width:600px; margin:0 auto; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
                + "<div style='text-align:center; background-color:#dc3545; color:white; padding:20px; border-radius:8px 8px 0 0; margin:-20px -20px 20px -20px;'>"
                + "<h1 style='margin:0; font-size:24px;'>🏸 BadmintonHub</h1>"
                + "<h2 style='margin:10px 0 0 0; font-size:18px; font-weight:normal;'>Xác nhận hủy đặt sân</h2>"
                + "</div>"
                
                + "<p>Xin chào <b style='color:#007bff;'>" + customerName + "</b>,</p>"
                + "<p>Yêu cầu hủy đặt sân của bạn đã được xử lý thành công.</p>"
                
                + "<div style='background-color:#f8f9fa; padding:20px; border-radius:8px; margin:20px 0;'>"
                + "<h3 style='color:#dc3545; margin-top:0;'>📋 Thông tin đặt sân đã hủy:</h3>"
                + "<table style='width:100%; border-collapse:collapse;'>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Mã đặt sân:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6; color:#dc3545; font-weight:bold;'>#" + bookingId + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Thời gian hủy:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + currentTime + "</td></tr>"
                + "</table>"
                
                + "<h4 style='color:#dc3545; margin-top:20px; margin-bottom:10px;'>Chi tiết sân đã hủy:</h4>"
                + "<table style='width:100%; border-collapse:collapse; border:1px solid #dee2e6;'>"
                + "<tr style='background-color:#f8f9fa;'>"
                + "<th style='padding:8px; text-align:left; border-bottom:1px solid #dee2e6;'>Tên sân</th>"
                + "<th style='padding:8px; text-align:left; border-bottom:1px solid #dee2e6;'>Loại sân</th>"
                + "<th style='padding:8px; text-align:left; border-bottom:1px solid #dee2e6;'>Thời gian</th>"
                + "</tr>"
                + courtInfo.toString()
                + "</table>"
                + "</div>"
                
                + "<div style='background-color:#ffe6e6; border:1px solid #dc3545; border-radius:8px; padding:15px; margin:20px 0;'>"
                + "<p style='margin:0; color:#dc3545;'><b>❌ Trạng thái:</b> Đã hủy thành công</p>"
                + "</div>"
                
                + "<h3 style='color:#dc3545;'>📝 Chính sách hoàn tiền:</h3>"
                + "<ul style='line-height:1.6;'>"
                + "<li>Hoàn tiền sẽ được xử lý trong vòng <b>3-5 ngày làm việc</b></li>"
                + "<li>Số tiền sẽ được hoàn về tài khoản thanh toán ban đầu</li>"
                + "<li>Liên hệ hotline nếu có thắc mắc về việc hoàn tiền</li>"
                + "</ul>"
                
                + "<div style='text-align:center; margin:30px 0;'>"
                + "<p style='margin:10px 0;'>📞 <b>Hotline:</b> 0123-456-789</p>"
                + "<p style='margin:10px 0;'>📧 <b>Email:</b> support@badmintonhub.com</p>"
                + "<p style='margin:10px 0;'>🌐 <b>Website:</b> www.badmintonhub.com</p>"
                + "</div>"
                
                + "<div style='border-top:1px solid #dee2e6; padding-top:20px; margin-top:30px; text-align:center; color:#6c757d; font-size:12px;'>"
                + "<p>Email này được gửi tự động vào lúc " + currentTime + "</p>"
                + "<p>Cảm ơn bạn đã sử dụng dịch vụ BadmintonHub!</p>"
                + "<p>Trân trọng,<br><b style='color:#007bff;'>Đội ngũ BadmintonHub</b></p>"
                + "</div>"
                + "</div>"
                + "</body></html>";
        sendEmail(recipientEmail, subject, htmlContent);
    }

    // Gửi email hủy đặt sân đơn giản (không có chi tiết sân)
    public static void sendSimpleCancellationEmail(String recipientEmail, String customerName, 
            String bookingId) throws MessagingException {
        
        String subject = "Xác nhận hủy đặt sân - BadmintonHub";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px; color:#333;'>"
                + "<div style='max-width:600px; margin:0 auto; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
                + "<div style='text-align:center; background-color:#dc3545; color:white; padding:20px; border-radius:8px 8px 0 0; margin:-20px -20px 20px -20px;'>"
                + "<h1 style='margin:0; font-size:24px;'>🏸 BadmintonHub</h1>"
                + "<h2 style='margin:10px 0 0 0; font-size:18px; font-weight:normal;'>Xác nhận hủy đặt sân</h2>"
                + "</div>"
                
                + "<p>Xin chào <b style='color:#007bff;'>" + customerName + "</b>,</p>"
                + "<p>Yêu cầu hủy đặt sân của bạn đã được xử lý thành công.</p>"
                
                + "<div style='background-color:#f8f9fa; padding:20px; border-radius:8px; margin:20px 0;'>"
                + "<h3 style='color:#dc3545; margin-top:0;'>📋 Thông tin đặt sân đã hủy:</h3>"
                + "<table style='width:100%; border-collapse:collapse;'>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Mã đặt sân:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6; color:#dc3545; font-weight:bold;'>#" + bookingId + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Thời gian hủy:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + currentTime + "</td></tr>"
                + "</table>"
                + "</div>"
                
                + "<div style='background-color:#ffe6e6; border:1px solid #dc3545; border-radius:8px; padding:15px; margin:20px 0;'>"
                + "<p style='margin:0; color:#dc3545;'><b>❌ Trạng thái:</b> Đã hủy thành công</p>"
                + "</div>"
                
                + "<h3 style='color:#dc3545;'>📝 Chính sách hoàn tiền:</h3>"
                + "<ul style='line-height:1.6;'>"
                + "<li>Hoàn tiền sẽ được xử lý trong vòng <b>3-5 ngày làm việc</b></li>"
                + "<li>Số tiền sẽ được hoàn về tài khoản thanh toán ban đầu</li>"
                + "<li>Liên hệ hotline nếu có thắc mắc về việc hoàn tiền</li>"
                + "</ul>"
                
                + "<div style='text-align:center; margin:30px 0;'>"
                + "<p style='margin:10px 0;'>📞 <b>Hotline:</b> 0123-456-789</p>"
                + "<p style='margin:10px 0;'>📧 <b>Email:</b> support@badmintonhub.com</p>"
                + "<p style='margin:10px 0;'>🌐 <b>Website:</b> www.badmintonhub.com</p>"
                + "</div>"
                
                + "<div style='border-top:1px solid #dee2e6; padding-top:20px; margin-top:30px; text-align:center; color:#6c757d; font-size:12px;'>"
                + "<p>Email này được gửi tự động vào lúc " + currentTime + "</p>"
                + "<p>Cảm ơn bạn đã sử dụng dịch vụ BadmintonHub!</p>"
                + "<p>Trân trọng,<br><b style='color:#007bff;'>Đội ngũ BadmintonHub</b></p>"
                + "</div>"
                + "</div>"
                + "</body></html>";
        
        System.out.println("HTML content length: " + htmlContent.length());
        System.out.println("Calling sendEmail method...");
        sendEmail(recipientEmail, subject, htmlContent);
        System.out.println("sendEmail method completed successfully");
        System.out.println("=== SIMPLE CANCELLATION EMAIL SENT ===");
    }

    // Gửi email thông báo đặt sân bởi Staff cho Customer
    public static void sendStaffBookingConfirmationEmail(String recipientEmail, String customerName, 
            String bookingId, String courtInfo, String dateInfo, String timeInfo) throws MessagingException {
        String subject = "Xác nhận đặt sân thành công - BadmintonHub";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px; color:#333;'>"
                + "<div style='max-width:600px; margin:0 auto; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
                + "<div style='text-align:center; background-color:#007bff; color:white; padding:20px; border-radius:8px 8px 0 0; margin:-20px -20px 20px -20px;'>"
                + "<h1 style='margin:0; font-size:24px;'>🏸 BadmintonHub</h1>"
                + "<h2 style='margin:10px 0 0 0; font-size:18px; font-weight:normal;'>Xác nhận đặt sân thành công</h2>"
                + "</div>"
                
                + "<p>Xin chào <b style='color:#007bff;'>" + customerName + "</b>,</p>"
                + "<p>Nhân viên của chúng tôi đã đặt sân dùm bạn. Vui lòng kiểm tra thông tin đặt sân dưới đây:</p>"
                
                + "<div style='background-color:#f8f9fa; padding:20px; border-radius:8px; margin:20px 0;'>"
                + "<h3 style='color:#007bff; margin-top:0;'>📋 Thông tin đặt sân:</h3>"
                + "<table style='width:100%; border-collapse:collapse;'>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Mã đặt sân:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6; color:#007bff; font-weight:bold;'>#" + bookingId + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Sân:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + courtInfo + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Ngày:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + dateInfo + "</td></tr>"
                + "<tr><td style='padding:8px 0;'><b>Thời gian:</b></td><td style='padding:8px 0; color:#28a745; font-weight:bold;'>" + timeInfo + "</td></tr>"
                + "</table>"
                + "</div>"
                
                + "<div style='background-color:#e8f5e8; border:1px solid #28a745; border-radius:8px; padding:15px; margin:20px 0;'>"
                + "<p style='margin:0; color:#28a745;'><b>✅ Trạng thái:</b> Đã xác nhận - Đặt bởi nhân viên</p>"
                + "</div>"
                
                + "<h3 style='color:#007bff;'>📝 Lưu ý quan trọng:</h3>"
                + "<ul style='line-height:1.6;'>"
                + "<li>Vui lòng có mặt <b>15 phút trước</b> giờ đặt sân</li>"
                + "<li>Mang theo giày thể thao phù hợp</li>"
                + "<li>Thanh toán có thể thực hiện tại quầy lễ tân</li>"
                + "<li>Liên hệ với chúng tôi nếu cần thay đổi hoặc hủy sân</li>"
                + "</ul>"
                
                + "<div style='text-align:center; margin:30px 0;'>"
                + "<p style='margin:10px 0;'>📞 <b>Hotline:</b> 0123-456-789</p>"
                + "<p style='margin:10px 0;'>📧 <b>Email:</b> support@badmintonhub.com</p>"
                + "<p style='margin:10px 0;'>🌐 <b>Website:</b> www.badmintonhub.com</p>"
                + "</div>"
                
                + "<div style='border-top:1px solid #dee2e6; padding-top:20px; margin-top:30px; text-align:center; color:#6c757d; font-size:12px;'>"
                + "<p>Email này được gửi tự động vào lúc " + currentTime + "</p>"
                + "<p>Trân trọng,<br><b style='color:#007bff;'>Đội ngũ BadmintonHub</b></p>"
                + "</div>"
                + "</div>"
                + "</body></html>";
        
        sendEmail(recipientEmail, subject, htmlContent);
        System.out.println("=== STAFF BOOKING CONFIRMATION EMAIL SENT ===");
    }

    // Gửi email thông báo cho Staff về booking mới
    public static void sendNewBookingNotificationToStaff(String staffEmail, String customerName, 
            String bookingId, String courtName, String courtType, String startTime, 
            String endTime, String amount) throws MessagingException {
        String subject = "[STAFF NOTIFICATION] New Booking - BadmintonHub";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px; color:#333;'>"
                + "<div style='max-width:600px; margin:0 auto; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
                + "<div style='text-align:center; background-color:#28a745; color:white; padding:20px; border-radius:8px 8px 0 0; margin:-20px -20px 20px -20px;'>"
                + "<h1 style='margin:0; font-size:24px;'>🏸 BadmintonHub - Staff Portal</h1>"
                + "<h2 style='margin:10px 0 0 0; font-size:18px; font-weight:normal;'>New Booking Alert</h2>"
                + "</div>"
                
                + "<p><b>🆕 NEW BOOKING RECEIVED</b></p>"
                + "<p>A new booking has been created and requires your attention.</p>"
                
                + "<div style='background-color:#f8f9fa; padding:20px; border-radius:8px; margin:20px 0;'>"
                + "<h3 style='color:#28a745; margin-top:0;'>📋 Booking Details:</h3>"
                + "<table style='width:100%; border-collapse:collapse;'>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Booking ID:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6; color:#28a745; font-weight:bold;'>#" + bookingId + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Customer:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + customerName + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Court:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + courtName + " (" + courtType + ")</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Time:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + startTime + " - " + endTime + "</td></tr>"
                + "<tr><td style='padding:8px 0;'><b>Amount:</b></td><td style='padding:8px 0; color:#28a745; font-weight:bold; font-size:16px;'>" + amount + " VNĐ</td></tr>"
                + "</table>"
                + "</div>"
                
                + "<div style='background-color:#e8f5e8; border:1px solid #28a745; border-radius:8px; padding:15px; margin:20px 0;'>"
                + "<p style='margin:0; color:#28a745;'><b>✅ Status:</b> New booking created at " + currentTime + "</p>"
                + "</div>"
                
                + "<h3 style='color:#28a745;'>📝 Staff Actions Required:</h3>"
                + "<ul style='line-height:1.6;'>"
                + "<li>Review booking details and confirm availability</li>"
                + "<li>Prepare court and equipment if needed</li>"
                + "<li>Contact customer if any issues arise</li>"
                + "<li>Update booking status in the system</li>"
                + "</ul>"
                
                + "<div style='text-align:center; margin:30px 0;'>"
                + "<a href='http://localhost:8080/SWP_Project/booking?action=my-bookings&customerId=" + bookingId + "' "
                + "style='background-color:#28a745; color:white; padding:12px 24px; text-decoration:none; border-radius:6px; font-weight:bold;'>"
                + "📱 View Booking Details</a>"
                + "</div>"
                
                + "<div style='border-top:1px solid #dee2e6; padding-top:20px; margin-top:30px; text-align:center; color:#6c757d; font-size:12px;'>"
                + "<p>This is an automated staff notification sent at " + currentTime + "</p>"
                + "<p><b style='color:#28a745;'>BadmintonHub Staff System</b></p>"
                + "</div>"
                + "</div>"
                + "</body></html>";
        sendEmail(staffEmail, subject, htmlContent);
    }

    // Gửi email thông báo cho Staff về booking bị hủy
    public static void sendCancelBookingNotificationToStaff(String staffEmail, String customerName, 
            String bookingId) throws MessagingException {
        String subject = "[STAFF NOTIFICATION] Booking Cancelled - BadmintonHub";
        String currentTime = java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy"));

        String htmlContent = "<html><body style='font-family:Arial,sans-serif;font-size:14px; color:#333;'>"
                + "<div style='max-width:600px; margin:0 auto; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
                + "<div style='text-align:center; background-color:#dc3545; color:white; padding:20px; border-radius:8px 8px 0 0; margin:-20px -20px 20px -20px;'>"
                + "<h1 style='margin:0; font-size:24px;'>🏸 BadmintonHub - Staff Portal</h1>"
                + "<h2 style='margin:10px 0 0 0; font-size:18px; font-weight:normal;'>Booking Cancellation Alert</h2>"
                + "</div>"
                
                + "<p><b>❌ BOOKING CANCELLED</b></p>"
                + "<p>A booking has been cancelled and requires your attention.</p>"
                
                + "<div style='background-color:#f8f9fa; padding:20px; border-radius:8px; margin:20px 0;'>"
                + "<h3 style='color:#dc3545; margin-top:0;'>📋 Cancelled Booking Details:</h3>"
                + "<table style='width:100%; border-collapse:collapse;'>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Booking ID:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6; color:#dc3545; font-weight:bold;'>#" + bookingId + "</td></tr>"
                + "<tr><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'><b>Customer:</b></td><td style='padding:8px 0; border-bottom:1px solid #dee2e6;'>" + customerName + "</td></tr>"
                + "<tr><td style='padding:8px 0;'><b>Cancelled At:</b></td><td style='padding:8px 0; color:#dc3545; font-weight:bold;'>" + currentTime + "</td></tr>"
                + "</table>"
                + "</div>"
                
                + "<div style='background-color:#ffe6e6; border:1px solid #dc3545; border-radius:8px; padding:15px; margin:20px 0;'>"
                + "<p style='margin:0; color:#dc3545;'><b>❌ Status:</b> Booking cancelled and court slot released</p>"
                + "</div>"
                + 
                "<h3 style='color:#dc3545;'>📝 Staff Actions Required:</h3>"
                + "<ul style='line-height:1.6;'>"
                + "<li>Confirm court slot is now available for other bookings</li>"
                + "<li>Process refund if applicable</li>"
                + "<li>Update court schedule and availability</li>"
                + "<li>Clean and prepare court for next booking</li>"
                + "</ul>"
                
                + "<div style='border-top:1px solid #dee2e6; padding-top:20px; margin-top:30px; text-align:center; color:#6c757d; font-size:12px;'>"
                + "<p>This is an automated staff notification sent at " + currentTime + "</p>"
                + "<p><b style='color:#dc3545;'>BadmintonHub Staff System</b></p>"
                + "</div>"
                + "</div>"
                + "</body></html>";
        sendEmail(staffEmail, subject, htmlContent);
    }

    // Hàm gửi email public để sử dụng từ bên ngoài
    public static void sendEmail(String recipientEmail, String subject, String htmlContent) throws MessagingException {
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