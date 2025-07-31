package dal;

import java.sql.*;
import java.util.*;
import models.BlogCommentDTO;
import utils.DBUtils;

public class BlogCommentDAO {

    public void insert(BlogCommentDTO comment) {
        String sql = "INSERT INTO BlogComments (PostID, UserID, Content, CreatedAt, ParentCommentID) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, comment.getPostID());
            ps.setInt(2, comment.getUserID());
            ps.setString(3, comment.getContent());
            ps.setTimestamp(4, comment.getCreatedAt());

            if (comment.getParentCommentID() != null) {
                ps.setInt(5, comment.getParentCommentID());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<BlogCommentDTO> getByPostId(int postID) throws Exception {
        List<BlogCommentDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM BlogComments WHERE PostID = ? ORDER BY CreatedAt ASC";

        try (Connection conn = DBUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, postID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Integer parentID = rs.getObject("ParentCommentID") != null ? rs.getInt("ParentCommentID") : null;
                BlogCommentDTO c = new BlogCommentDTO(
                    rs.getInt("PostID"),
                    rs.getInt("UserID"),
                    rs.getString("Content"),
                    parentID
                );
                c.setCommentID(rs.getInt("CommentID"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(c);
            }
        }

        return list;
    }

    public Map<Integer, List<BlogCommentDTO>> getCommentTree(int postID) throws Exception {
        List<BlogCommentDTO> allComments = getByPostId(postID);
        Map<Integer, List<BlogCommentDTO>> tree = new HashMap<>();

        for (BlogCommentDTO comment : allComments) {
            int parentId = (comment.getParentCommentID() != null) ? comment.getParentCommentID() : 0;
            tree.computeIfAbsent(parentId, k -> new ArrayList<>()).add(comment);
        }

        return tree;
    }
}
