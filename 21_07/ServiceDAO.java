package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.ServiceDTO;
import org.mindrot.jbcrypt.BCrypt;
public class ServiceDAO {

    private Connection conn;

    public ServiceDAO() {
        this.conn = DBUtils.getConnection();
    }




    public ServiceDTO getServiceByID(int serviceID) throws SQLException {
        String sql = "SELECT * FROM services WHERE ServiceID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToService(rs);
            }
        }
        return null;
    }

    private ServiceDTO mapResultSetToService(ResultSet rs) throws SQLException {
        ServiceDTO service = new ServiceDTO();
        service.setServiceID(rs.getInt("ServiceID"));
        service.setServiceName(rs.getString("ServiceName"));
        service.setServiceType(rs.getString("ServiceType"));
        service.setDescription(rs.getString("Description"));
        service.setUnit(rs.getString("Unit"));
        service.setPrice(rs.getDouble("Price"));
        service.setStatus(rs.getString("Status"));
        service.setCreatedAt(rs.getTimestamp("CreatedAt"));
        service.setCreatedBy(rs.getInt("CreatedBy"));
        service.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return service;
    }
//

    // Lấy tất cả 
    public List<ServiceDTO> getAllServices() throws SQLException {
        List<ServiceDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM services ORDER BY ServiceID ASC";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToService(rs));
            }
        }
        return list;
    }

    // Tìm kiếm name,
    public List<ServiceDTO> searchServices(String keyword) throws SQLException {
        List<ServiceDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM services WHERE servicename LIKE ? OR servicetype LIKE ? ORDER BY ServiceID ASC";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw);
            ps.setString(2, kw);
           
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToService(rs));
            }
        }
        return list;
    }

    // admin thêm 
    public boolean addServiceSimple(ServiceDTO service) throws SQLException {
        String sql = "INSERT INTO services (servicename, servicetype, description, unit, price, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setString(2, service.getServiceType());
            ps.setString(3, service.getDescription());
            ps.setString(4, service.getUnit());          
            ps.setDouble(5, service.getPrice());
            ps.setString(6, service.getStatus());

            return ps.executeUpdate() > 0;
        }
    }

    // admin sửa service
    public boolean updateServiceSimple(ServiceDTO service) throws SQLException {
        String sql = "UPDATE services SET ServiceName=?, ServiceType=?, Description=?, Unit=?, Price=?, Status=? WHERE ServiceID=?";
        try (PreparedStatement ps = DBUtils.getConnection().prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
           
            ps.setString(2, service.getServiceType());
            
            ps.setString(3, service.getDescription());
            ps.setString(4, service.getUnit());   
            ps.setDouble(5, service.getPrice());   
            ps.setString(6, service.getStatus());
            ps.setInt(7, service.getServiceID());
            return ps.executeUpdate() > 0;
        }
    }


 

}