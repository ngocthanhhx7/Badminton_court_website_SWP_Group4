package dao;

import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import models.AdminDTO;
import java.sql.Timestamp;

public class AdminDAO {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    public AdminDTO login(String Username, String Password) {
        String query = "select * from Admins\n"
                + "where [Username] = ?\n"
                + "and Password = ?";
        try {
            conn = new DBUtils().getConnection();//mo ket noi voi sql
            ps = conn.prepareStatement(query);
            ps.setString(1, Username);
            ps.setString(2, Password);
            rs = ps.executeQuery();
            while (rs.next()) {
                return new AdminDTO(rs.getInt(1),
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

}
