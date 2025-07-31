package models;

import java.util.Date;

public class BlogPostDTO {
    private int postID;
    private String title;
    private String slug;
    private String content;
    private String summary;
    private String thumbnailUrl;
    private Date publishedAt;
    private int authorID;
    private int viewCount;
    private String status;
    private int commentCount; // ✅ Thêm dòng này

    // Constructor đầy đủ
    public BlogPostDTO(int postID, String title, String slug, String content, String summary, String thumbnailUrl, String status) {
        this.postID = postID;
        this.title = title;
        this.slug = slug;
        this.content = content;
        this.summary = summary;
        this.thumbnailUrl = thumbnailUrl;
        this.status = status;
    }

    // Constructor đầy đủ + commentCount (tuỳ nếu bạn có)
    public BlogPostDTO(int postID, String title, String slug, String content, String summary,
                       String thumbnailUrl, String status, int commentCount) {
        this(postID, title, slug, content, summary, thumbnailUrl, status);
        this.commentCount = commentCount;
    }

    // Constructor để thêm bài mới
    public BlogPostDTO(String title, String slug, String content, String summary,
                       String thumbnailUrl, int authorID, String status) {
        this.title = title;
        this.slug = slug;
        this.content = content;
        this.summary = summary;
        this.thumbnailUrl = thumbnailUrl;
        this.authorID = authorID;
        this.status = status;
    }

    // Constructor đơn giản để update bài viết
    public BlogPostDTO(int postID, String title, String slug, String content, String summary) {
        this.postID = postID;
        this.title = title;
        this.slug = slug;
        this.content = content;
        this.summary = summary;
    }

    // ➕ Getter
    public int getPostID() { return postID; }
    public String getTitle() { return title; }
    public String getSlug() { return slug; }
    public String getContent() { return content; }
    public String getSummary() { return summary; }
    public String getThumbnailUrl() { return thumbnailUrl; }
    public Date getPublishedAt() { return publishedAt; }
    public int getAuthorID() { return authorID; }
    public int getViewCount() { return viewCount; }
    public String getStatus() { return status; }
    public int getCommentCount() { return commentCount; } // ✅ Thêm getter

    // ➕ Setter
    public void setPostID(int postID) { this.postID = postID; }
    public void setTitle(String title) { this.title = title; }
    public void setSlug(String slug) { this.slug = slug; }
    public void setContent(String content) { this.content = content; }
    public void setSummary(String summary) { this.summary = summary; }
    public void setThumbnailUrl(String thumbnailUrl) { this.thumbnailUrl = thumbnailUrl; }
    public void setPublishedAt(Date publishedAt) { this.publishedAt = publishedAt; }
    public void setAuthorID(int authorID) { this.authorID = authorID; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    public void setStatus(String status) { this.status = status; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; } // ✅ Thêm setter
}
