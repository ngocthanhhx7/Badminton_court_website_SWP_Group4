/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Mã hóa mật khẩu bằng BCrypt
    public static String hashPassword(String plainPassword) {
        // Số vòng lặp tăng độ mạnh của salt (10 là giá trị mặc định an toàn)
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(10));
    }

    // Kiểm tra mật khẩu gốc với hash đã lưu
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
