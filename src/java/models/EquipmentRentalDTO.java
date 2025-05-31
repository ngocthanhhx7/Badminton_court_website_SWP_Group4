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
public class EquipmentRentalDTO {
    private int EquipmentID;
    private String Name;
    private String Description;
    private String ImageUrl;
    private double Price;
    private Boolean IsAvailable;
    private Timestamp CreatedAt;
}
