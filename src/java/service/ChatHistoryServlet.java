package service;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import com.google.gson.*;
import dao.ChatDAO;

public class ChatHistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sender = req.getParameter("sender");
        String receiver = req.getParameter("receiver");

        if (sender != null && receiver != null) {
            ChatDAO dao = new ChatDAO();
            var list = dao.getMessages(sender, receiver);
            String json = new Gson().toJson(list);

            resp.setContentType("application/json");
            resp.getWriter().write(json);
        }
    }
}
