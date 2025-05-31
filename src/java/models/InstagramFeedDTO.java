/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.sql.Timestamp;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InstagramFeedDTO {
    private int FeedID;
    private String ImageUrl;
    private String InstagramLink;
    private int DisplayOrder;
    private Boolean IsVisible;
    private Timestamp CreatedAt;
}
