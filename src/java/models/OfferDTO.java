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
public class OfferDTO {
    private int OfferID;
    private String Title;
    private String Subtitle;
    private String Description;
    private String ImageUrl;
    private int Capacity;
    private Boolean IsVIP;
    private Boolean IsActive;
    private Timestamp CreatedAt;
}
