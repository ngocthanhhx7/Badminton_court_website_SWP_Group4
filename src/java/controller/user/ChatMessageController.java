package controller.user;

import com.google.gson.Gson;
import dal.ChatMessageDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ChatMessageDTO;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "ChatMessageController", urlPatterns = { "/chat-message" })
public class ChatMessageController extends HttpServlet {
    private final ChatMessageDAO chatMessageDAO = new ChatMessageDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        String userIdStr = request.getParameter("userId");
        PrintWriter out = response.getWriter();
        if (userIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing userId\"}");
            return;
        }
        int userId = Integer.parseInt(userIdStr);
        List<ChatMessageDTO> messages = chatMessageDAO.getMessagesByUser(userId);
        out.print(gson.toJson(messages));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        BufferedReader reader = request.getReader();
        ChatMessageDTO message = gson.fromJson(reader, ChatMessageDTO.class);
        if (message.getSentAt() == null) {
            message.setSentAt(new Timestamp(System.currentTimeMillis()));
        }
        int id = chatMessageDAO.createMessage(message);
        PrintWriter out = response.getWriter();
        if (id > 0) {
            out.print("{\"status\":\"ok\",\"id\":" + id + "}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"fail\"}");
        }
    }
} 