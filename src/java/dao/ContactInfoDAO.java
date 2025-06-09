package dao;

import models.ContactInfoDTO;
import utils.DBUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ContactInfoDAO {

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
}
