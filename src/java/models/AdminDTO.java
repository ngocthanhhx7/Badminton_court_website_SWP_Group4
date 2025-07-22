package models;

import java.sql.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminDTO {  
    private int AdminID;
    private String Username;
    private String Password;
    private String FullName;
    private String Email;
    private String Status;
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


    public AdminDTO(int AdminID, String Username, String Password, String FullName, String Email, String Status, Timestamp CreatedAt, Timestamp UpdatedAt) {
        this.AdminID = AdminID;
        this.Username = Username;
        this.Password = Password;
        this.FullName = FullName;
        this.Email = Email;
        this.Status = Status;
        this.CreatedAt = CreatedAt;
        this.UpdatedAt = UpdatedAt;
    }
    

}
