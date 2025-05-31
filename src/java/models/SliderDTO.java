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
public class SliderDTO {
    private int SliderID;
    private String Title;
    private String Subtitle;
    private String BackgroundImage;
    private int Position;
    private Boolean IsActive;
    private Timestamp CreatedAt;
}
