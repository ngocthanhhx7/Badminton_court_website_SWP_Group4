package dal;

import models.ContactInfoDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ContactInfoDAO {
    
    public List<ContactInfoDTO> getAllContactInfo() {
        String sql = "SELECT * FROM ContactInfo ORDER BY ContactID DESC";

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<ContactInfoDTO> contactList = new ArrayList<>();

            while (resultSet.next()) {
                ContactInfoDTO contact = ContactInfoDTO.builder()
                        .contactID(resultSet.getInt("ContactID"))
                        .message(resultSet.getString("Message"))
                        .phoneNumber(resultSet.getString("PhoneNumber"))
                        .isActive(resultSet.getBoolean("IsActive"))
                        .build();
                contactList.add(contact);
            }

            return contactList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<ContactInfoDTO> getAllActiveContactInfo() {
        String sql = "SELECT * FROM ContactInfo WHERE IsActive = 1 ORDER BY ContactID DESC";

        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();
            List<ContactInfoDTO> contactList = new ArrayList<>();

            while (resultSet.next()) {
                ContactInfoDTO contact = ContactInfoDTO.builder()
                        .contactID(resultSet.getInt("ContactID"))
                        .message(resultSet.getString("Message"))
                        .phoneNumber(resultSet.getString("PhoneNumber"))
                        .isActive(resultSet.getBoolean("IsActive"))
                        .build();
                contactList.add(contact);
            }

            return contactList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean addContactInfo(ContactInfoDTO contact) {
        String sql = "INSERT INTO ContactInfo (Message, PhoneNumber, IsActive) VALUES (?, ?, ?)";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            
            preparedStatement.setString(1, contact.getMessage());
            preparedStatement.setString(2, contact.getPhoneNumber());
            preparedStatement.setBoolean(3, contact.isActive());
            
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateContactInfo(ContactInfoDTO contact) {
        String sql = "UPDATE ContactInfo SET Message = ?, PhoneNumber = ? WHERE ContactID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            
            preparedStatement.setString(1, contact.getMessage());
            preparedStatement.setString(2, contact.getPhoneNumber());
            preparedStatement.setInt(3, contact.getContactID());
            
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteContactInfo(int contactId) {
        String sql = "DELETE FROM ContactInfo WHERE ContactID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            
            preparedStatement.setInt(1, contactId);
            
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean toggleContactStatus(int contactId) {
        // First get the current status
        ContactInfoDTO contact = getContactById(contactId);
        if (contact == null) {
            return false;
        }
        
        // Toggle the status
        boolean newStatus = !contact.isActive();
        String sql = "UPDATE ContactInfo SET IsActive = ? WHERE ContactID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            
            preparedStatement.setBoolean(1, newStatus);
            preparedStatement.setInt(2, contactId);
            
            int rowsAffected = preparedStatement.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public ContactInfoDTO getContactById(int contactId) {
        String sql = "SELECT * FROM ContactInfo WHERE ContactID = ?";
        
        try (Connection connection = DBUtils.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            
            preparedStatement.setInt(1, contactId);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                return ContactInfoDTO.builder()
                        .contactID(resultSet.getInt("ContactID"))
                        .message(resultSet.getString("Message"))
                        .phoneNumber(resultSet.getString("PhoneNumber"))
                        .isActive(resultSet.getBoolean("IsActive"))
                        .build();
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return null;
    }
}
