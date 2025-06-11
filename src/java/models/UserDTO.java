package models;

import java.sql.Timestamp;
import java.util.Date;

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
    private Integer CreatedBy;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
    private String verifyCode;
    private boolean isVerified;
    public String getVerifyCode() {
        return verifyCode;
    }

    public void setVerifyCode(String verifyCode) {
        this.verifyCode = verifyCode;
    }


    public UserDTO() {
    }

    public UserDTO(int UserID, String Username, String Password, String Email, String FullName, Date Dob,
                 String Gender, String Phone, String Address, String SportLevel, String Role, String Status,
                 int CreatedBy, Timestamp CreatedAt, Timestamp UpdatedAt) {
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

    // Getters and Setters

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int userID) {
        this.UserID = userID;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String username) {
        this.Username = username;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String password) {
        this.Password = password;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String email) {
        this.Email = email;
    }

    public String getFullName() {
        return FullName;
    }

    public void setFullName(String fullName) {
        this.FullName = fullName;
    }

    public Date getDob() {
        return Dob;
    }

    public void setDob(Date dob) {
        this.Dob = dob;
    }

    public String getGender() {
        return Gender;
    }

    public void setGender(String gender) {
        this.Gender = gender;
    }

    public String getPhone() {
        return Phone;
    }

    public void setPhone(String phone) {
        this.Phone = phone;
    }

    public String getAddress() {
        return Address;
    }

    public void setAddress(String address) {
        this.Address = address;
    }

    public String getSportLevel() {
        return SportLevel;
    }

    public void setSportLevel(String sportLevel) {
        this.SportLevel = sportLevel;
    }

    public String getRole() {
        return Role;
    }

    public void setRole(String role) {
        this.Role = role;
    }

    public String getStatus() {
        return Status;
    }

    public void setStatus(String status) {
        this.Status = status;
    }

    public Integer getCreatedBy() {
        return CreatedBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.CreatedBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.CreatedAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return UpdatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.UpdatedAt = updatedAt;
    }
    

    @Override
    public String toString() {
        return "UserDTO{" +
                "UserID=" + UserID +
                ", Username='" + Username + '\'' +
                ", Password='" + Password + '\'' +
                ", Email='" + Email + '\'' +
                ", FullName='" + FullName + '\'' +
                ", Dob=" + Dob +
                ", Gender='" + Gender + '\'' +
                ", Phone='" + Phone + '\'' +
                ", Address='" + Address + '\'' +
                ", SportLevel='" + SportLevel + '\'' +
                ", Role='" + Role + '\'' +
                ", Status='" + Status + '\'' +
                ", CreatedBy=" + CreatedBy +
                ", CreatedAt=" + CreatedAt +
                ", UpdatedAt=" + UpdatedAt +
                '}';
    }
}
