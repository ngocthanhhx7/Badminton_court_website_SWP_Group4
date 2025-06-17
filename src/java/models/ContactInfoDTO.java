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
public class ContactInfoDTO {
    private int contactID;
    private String message;
    private String phoneNumber;
    private boolean isActive;
    
    public boolean isActive() {
    return this.isActive;
}
}