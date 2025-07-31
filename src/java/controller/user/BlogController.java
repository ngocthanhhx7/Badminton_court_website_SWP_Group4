/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.user;

import dal.BlogPostDAO;
import dal.BlogTagDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import models.BlogPostDTO;
import models.BlogTagDTO;

@WebServlet(name = "BlogController", urlPatterns = { "/blog" })
public class BlogController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Blog</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Blog at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String search = request.getParameter("search");
            String sort = request.getParameter("sort"); // "date" hoặc "views"

            String pageStr = request.getParameter("page");
            int currentPage = 1;
            if (pageStr != null && !pageStr.isEmpty()) {
                currentPage = Integer.parseInt(pageStr);
            }

            int itemsPerPage = 5;
            BlogPostDAO blogPostDAO = new BlogPostDAO();

            // Lấy tổng số bài viết phù hợp
            int totalPosts = blogPostDAO.countPosts(search);
            int totalPages = (int) Math.ceil((double) totalPosts / itemsPerPage);

            List<BlogPostDTO> posts = blogPostDAO.getPostsByPage(currentPage, itemsPerPage, search, sort);

            request.setAttribute("posts", posts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("search", search);
            request.setAttribute("sort", sort);

            request.getRequestDispatcher("blog.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Blog Controller";
    }
}
