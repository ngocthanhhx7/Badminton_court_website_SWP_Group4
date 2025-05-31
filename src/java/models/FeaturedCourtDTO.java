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
public class FeaturedCourtDTO {
    private int CourtID;
    private String Name;
    private String Description;
    private double PricePerHour;
    private String ImageUrl;
    private int DisplayOrder;
    private Boolean IsActive;
    private Timestamp CreatedAt;
}
