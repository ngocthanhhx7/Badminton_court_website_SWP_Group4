package models;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class User {
    private String username, password, email, fullName, dob,
                   gender, phone, address, sportLevel, role, createdBy, status;

    public User(String username, String password, String email, String fullName, String dob, String gender, String phone, String address, String sportLevel, String role, String createdBy, String status) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.dob = dob;
        this.gender = gender;
        this.phone = phone;
        this.address = address;
        this.sportLevel = sportLevel;
        this.role = role;
        this.createdBy = createdBy;
        this.status = status;
    }

    public User(String username, String password, String email, String fullName, String dob, String gender, String phone, String address, String sportLevel, String role, String createdBy) {
        this(username, password, email, fullName, dob, gender, phone, address, sportLevel, role, createdBy, "Active");
    }

    public User() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getEmail() { return email; }
    public String getFullName() { return fullName; }
    public String getDob() { return dob; }
    public String getGender() { return gender; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public String getSportLevel() { return sportLevel; }
    public String getRole() { return role; }
    public String getCreatedBy() { return createdBy; }
    public String getStatus() { return status; }

    public void setUsername(String username) { this.username = username; }
    public void setPassword(String password) { this.password = password; }
    public void setEmail(String email) { this.email = email; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setDob(String dob) { this.dob = dob; }
    public void setGender(String gender) { this.gender = gender; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setAddress(String address) { this.address = address; }
    public void setSportLevel(String sportLevel) { this.sportLevel = sportLevel; }
    public void setRole(String role) { this.role = role; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public void setStatus(String status) { this.status = status; }

    public void setId(int parseInt) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setBirthDate(LocalDate parse) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setUpdatedAt(LocalDateTime now) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public void setActive(boolean b) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}

