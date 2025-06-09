package models;

import java.sql.Timestamp;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VideoDTO {
    private int VideoID;
    private String Title;
    private String Subtitle;
    private String VideoUrl;
    private String ThumbnailUrl;
    private Boolean IsFeatured;
    private Timestamp CreatedAt;
}
