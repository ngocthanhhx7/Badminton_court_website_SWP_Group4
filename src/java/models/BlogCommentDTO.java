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
public class BlogCommentDTO {
    private int CommentID;
    private int PostID;
    private String UserName;
    private String Email;
    private String Content;
    private Timestamp CreatedAt;
    private Integer ParentCommentID;
}
