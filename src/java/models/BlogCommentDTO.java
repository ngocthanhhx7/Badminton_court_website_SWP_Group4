/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.sql.Timestamp;

public class BlogCommentDTO {
    private int commentID;
    private int postID;
    private int userID;
    private String content;
    private Timestamp createdAt;
    private Integer parentCommentID; // Cho phép null

    // Constructor cơ bản
    public BlogCommentDTO(int postID, int userID, String content, Integer parentCommentID) {
        this.postID = postID;
        this.userID = userID;
        this.content = content;
        this.parentCommentID = parentCommentID;
    }

    // Getters & setters (sinh bằng IDE)

    public int getCommentID() {
        return commentID;
    }

    public void setCommentID(int commentID) {
        this.commentID = commentID;
    }

    public int getPostID() {
        return postID;
    }

    public void setPostID(int postID) {
        this.postID = postID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getParentCommentID() {
        return parentCommentID;
    }

    public void setParentCommentID(Integer parentCommentID) {
        this.parentCommentID = parentCommentID;
    }
    
}
