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

}
