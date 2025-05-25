/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 *
 * @author nguye
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingNoteDTO {
    private Long noteId;
    private BookingDTO booking;
    private UserDTO customer;
    private String noteDetails;
    private String status;
}
