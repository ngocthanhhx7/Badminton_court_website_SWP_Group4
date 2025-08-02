package utils;

import models.BlogCommentDTO;
import java.util.List;
import java.util.Map;

public class CommentUtils {

    public static String renderComments(Map<Integer, List<BlogCommentDTO>> commentTree, int parentId, int level, int postID) {
        StringBuilder sb = new StringBuilder();
        List<BlogCommentDTO> replies = commentTree.get(parentId);

        if (replies != null) {
            for (BlogCommentDTO comment : replies) {
                // Bọc toàn bộ bình luận + reply form + replies con
                sb.append("<div style=\"margin-left:").append(level * 30).append("px; font-size:14px;\">");

                // Hiển thị thông tin người dùng
                if (level > 0) sb.append("↳ ");
                sb.append("<strong>User ").append(comment.getUserID()).append("</strong>: ")
                  .append(comment.getContent()).append("<br>");

                sb.append("<small>").append(comment.getCreatedAt()).append("</small>");

                // Nút để toggle hiện form trả lời và các comment con
                sb.append(" <a href=\"javascript:void(0);\" ")
                  .append("onclick=\"toggleReply(").append(comment.getCommentID()).append(")\" ")
                  .append("style=\"color:#1877f2; font-size:12px; margin-left:10px;\">↩ Trả lời</a>");

                // Div ẩn chứa cả form và replies con
                sb.append("<div id=\"replyBlock").append(comment.getCommentID()).append("\" style=\"display:none; margin-top:5px;\">");

                // Form trả lời
                sb.append("<form id=\"replyForm").append(comment.getCommentID()).append("\" class=\"comment-form\" ")
                  .append("method=\"post\" action=\"add-comment\" style=\"margin-bottom:10px;\">")
                  .append("<input type=\"hidden\" name=\"postID\" value=\"").append(postID).append("\"/>")
                  .append("<input type=\"hidden\" name=\"parentID\" value=\"").append(comment.getCommentID()).append("\"/>")
                  .append("<textarea name=\"content\" required placeholder=\"Phản hồi...\"></textarea>")
                  .append("<button type=\"submit\">Gửi</button>")
                  .append("</form>");

                // Gọi đệ quy hiển thị các replies con
                sb.append(renderComments(commentTree, comment.getCommentID(), level + 1, postID));

                sb.append("</div>"); // end replyBlock

                sb.append("</div>"); // end comment div
            }
        }

        return sb.toString();
    }
}
