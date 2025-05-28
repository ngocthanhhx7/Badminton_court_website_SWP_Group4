/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;


import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Admins;
import model.Users;

/**
 *
 * @author PC - ACER
 */
public class DAO {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    public Admins login(String Username, String Password) {
        String query = "select * from Admins\n"
                + "where [Username] = ?\n"
                + "and Password = ?";
        try {
            conn = new DBContext().getConnection();//mo ket noi voi sql
            ps = conn.prepareStatement(query);
            ps.setString(1, Username);
            ps.setString(2, Password);
            rs = ps.executeQuery();
            while (rs.next()) {
                return new Admins(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getString(6),
                        rs.getTimestamp(7),
                        rs.getTimestamp(8));
       
            }
        } catch (Exception e) {
        }
        return null;
    }
        public Users login1(String Username, String Password) {
        String query = "select * from Users\n"
                + "where [Username] = ?\n"
                + "and Password = ?";
        try {
            conn = new DBContext().getConnection();//mo ket noi voi sql
            ps = conn.prepareStatement(query);
            ps.setString(1, Username);
            ps.setString(2, Password);
            rs = ps.executeQuery();
            while (rs.next()) {
                return new Users(rs.getInt(1),
                        rs.getString(2),
                        rs.getString(3),
                        rs.getString(4),
                        rs.getString(5),
                        rs.getDate(6),
                        rs.getString(7),
                        rs.getString(8),
                        rs.getString(9),
                        rs.getString(10),
                        rs.getString(11),
                        rs.getString(12),
                        rs.getInt(13),
                        rs.getTimestamp(14),
                        rs.getTimestamp(15));
       
            }
        } catch (Exception e) {
        }
        return null;
    }
}
