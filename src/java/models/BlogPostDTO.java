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
public class BlogPostDTO {
    private int PostID;
    private String Title;
    private String Slug;
    private String Content;
    private String Summary;
    private String ThumbnailUrl;
    private Timestamp PublishedAt;
    private int AuthorID;
    private int ViewCount;
    private String Status;
    private Timestamp CreatedAt;
    private Timestamp UpdatedAt;
    private int commentCount;

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }
}
