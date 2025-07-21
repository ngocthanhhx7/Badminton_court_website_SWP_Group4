/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.time.LocalDateTime;
import lombok.Data;

/**
 *
 * @author Admin
 */
@Data
public class CartsDTO {
    private int CartID;
    private int UserID;
    private String Status;
    private LocalDateTime CreatedAt;
}
