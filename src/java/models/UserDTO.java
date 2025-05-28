/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.sql.Timestamp;
import java.util.Date;

/**
 *
 * @author PC - ACER
 */
public class UserDTO {
    private int UserID;
    private String Username;
    private String Password;
    private String Email;
    private String FullName;
    private Date Dob;
    private String Gender;
    private String Phone;
    private String Address;
    private String SportLevel;
    private String Role;
    private String Status;
    private int CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;

    public UserDTO() {
    }

    public UserDTO(int UserID, String Username, String Password, String Email, String FullName, Date Dob, String Gender, String Phone, String Address, String SportLevel, String Role, String Status, int CreatedBy, Timestamp CreatedAt, Timestamp UpdatedAt) {
        this.UserID = UserID;
        this.Username = Username;
        this.Password = Password;
        this.Email = Email;
        this.FullName = FullName;
        this.Dob = Dob;
        this.Gender = Gender;
        this.Phone = Phone;
        this.Address = Address;
        this.SportLevel = SportLevel;
        this.Role = Role;
        this.Status = Status;
        this.CreatedBy = CreatedBy;
        this.CreatedAt = CreatedAt;
        this.UpdatedAt = UpdatedAt;
    }

    
    
    public int getUserID() {
        return UserID;
    }

    public void setUserID(int UserID) {
        this.UserID = UserID;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String Username) {
        this.Username = Username;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getFullName() {
        return FullName;
    }

    public void setFullName(String FullName) {
        this.FullName = FullName;
    }

    public Date getDob() {
        return Dob;
    }

    public void setDob(Date Dob) {
        this.Dob = Dob;
    }

    public String getGendert() {
        return Gender;
    }

    public void setGender(String Gendert) {
        this.Gender = Gendert;
    }

    public String getPhone() {
        return Phone;
    }

    public void setPhone(String Phone) {
        this.Phone = Phone;
    }

    public String getAddress() {
        return Address;
    }

    public void setAddress(String Address) {
        this.Address = Address;
    }

    public String getSportLevel() {
        return SportLevel;
    }

    public void setSportLevel(String SportLevel) {
        this.SportLevel = SportLevel;
    }

    public String getRole() {
        return Role;
    }

    public void setRole(String Role) {
        this.Role = Role;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String Status) {
        this.Status = Status;
    }

    public int getCreatedBy() {
        return CreatedBy;
    }

    public void setCreatedBy(int CreatedBy) {
        this.CreatedBy = CreatedBy;
    }

    public Timestamp getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Timestamp CreatedAt) {
        this.CreatedAt = CreatedAt;
    }

    public Timestamp getUpdatedAt() {
        return UpdatedAt;
    }

    public void setUpdatedAt(Timestamp UpdatedAt) {
        this.UpdatedAt = UpdatedAt;
    }
    
    
    
}

