<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php'; // Đảm bảo bạn đã chạy `composer require phpmailer/phpmailer`

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name    = $_POST['name'] ?? '';
    $email   = $_POST['email'] ?? '';
    $subject = $_POST['subject'] ?? '';
    $message = $_POST['message'] ?? '';

    $mail = new PHPMailer(true);

    try {
        // Cấu hình SMTP
        $mail->isSMTP();
        $mail->Host       = 'smtp.gmail.com';
        $mail->SMTPAuth   = true;
        $mail->Username   = 'nguyenngocthanhhx7@gmail.com'; // Tài khoản Gmail
        $mail->Password   = 'xxumelrdsdpjrjzv';             // App Password (không phải mật khẩu Gmail thường)
        $mail->SMTPSecure = 'tls';
        $mail->Port       = 587;

        // Người gửi và người nhận
        $mail->setFrom($email, $name);
        $mail->addAddress('thanhnnhe186491@fpt.edu.vn', 'FPT Contact');

        // Nội dung email
        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body    = "
            <h2>Contact Message</h2>
            <p><strong>Name:</strong> {$name}</p>
            <p><strong>Email:</strong> {$email}</p>
            <p><strong>Subject:</strong> {$subject}</p>
            <p><strong>Message:</strong><br>{$message}</p>
        ";

        $mail->send();
        header('Location: contact.php?status=success'); // Gửi xong thì quay về form
        exit;
    } catch (Exception $e) {
        header('Location: contact.php?status=error');
        exit;
    }
}
?>
