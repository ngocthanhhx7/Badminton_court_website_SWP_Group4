package models;

import java.sql.Timestamp;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SliderDTO {
    private int SliderID;
    private String Title;
    private String Subtitle;
    private String BackgroundImage;
    private int Position;
    private Boolean IsActive;
    private Timestamp CreatedAt;
}
