package models;

import java.sql.Timestamp;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AboutSectionDTO {
    private int AboutID;
    private String Title;
    private String Subtitle;
    private String Content;
    private String Image1;
    private String Image2;
    private String SectionType;
    private Boolean IsActive;
    private Timestamp CreatedAt;
}