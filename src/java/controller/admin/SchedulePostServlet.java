package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import utils.DBUtils;

@WebServlet("/schedule-post")
@MultipartConfig( // ✅ Cho phép upload file
    fileSizeThreshold = 1024 * 1024,  // 1MB
    maxFileSize = 5 * 1024 * 1024,    // 5MB
    maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class SchedulePostServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Integer userID = (Integer) session.getAttribute("userID");

        if (userID == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String slug = request.getParameter("slug");
        String summary = request.getParameter("summary");
        String content = request.getParameter("content");
        String scheduleTimeStr = request.getParameter("scheduleTime");

        // ✅ Kiểm tra dữ liệu bắt buộc
        if (title == null || slug == null || summary == null || content == null || scheduleTimeStr == null ||
            title.trim().isEmpty() || slug.trim().isEmpty()) {
            response.sendRedirect("new-post-schedule.jsp?msg=error&reason=missing");
            return;
        }

        try {
            // ✅ Parse thời gian hẹn giờ
            LocalDateTime scheduleTime = LocalDateTime.parse(scheduleTimeStr);

            // ✅ Xử lý ảnh thumbnail
            Part filePart = request.getPart("thumbnailFile");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            if (fileName == null || fileName.trim().isEmpty()) {
                response.sendRedirect("new-post-schedule.jsp?msg=error&reason=missing_thumbnail");
                return;
            }

            // ✅ Lưu ảnh vào thư mục /img/blog
            String uploadPath = getServletContext().getRealPath("/img/blog");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            filePart.write(uploadPath + File.separator + fileName);
            String thumbnailUrl = "img/blog/" + fileName;

            Connection conn = DBUtils.getConnection();

            // ✅ Kiểm tra slug trùng
            String checkSql = "SELECT COUNT(*) FROM BlogPosts WHERE Slug = ?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, slug);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                rs.close();
                checkPs.close();
                conn.close();
                response.sendRedirect("new-post-schedule.jsp?msg=error&reason=slug_exists");
                return;
            }
            rs.close();
            checkPs.close();

            // ✅ Insert bài viết vào DB
            String insertSql = "INSERT INTO BlogPosts (Title, Slug, Summary, Content, ThumbnailUrl, AuthorID, PublishedAt, Status, CreatedAt) "
                             + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
            PreparedStatement ps = conn.prepareStatement(insertSql);
            ps.setString(1, title);
            ps.setString(2, slug);
            ps.setString(3, summary);
            ps.setString(4, content);
            ps.setString(5, thumbnailUrl);
            ps.setInt(6, userID);
            ps.setTimestamp(7, Timestamp.valueOf(scheduleTime));
            ps.setString(8, "scheduled");

            ps.executeUpdate();
            ps.close();
            conn.close();

            response.sendRedirect("new-post-schedule.jsp?msg=success");

        } catch (DateTimeParseException dtpe) {
            response.sendRedirect("new-post-schedule.jsp?msg=error&reason=datetime");
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            response.sendRedirect("new-post-schedule.jsp?msg=error&reason=sql");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("new-post-schedule.jsp?msg=error&reason=unknown");
        }
    }
}
