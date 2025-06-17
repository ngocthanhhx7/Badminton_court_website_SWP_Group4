package controllerUser;

import java.io.*;
import java.net.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/ChatGPTServlet")
public class ChatGPTServlet extends HttpServlet {
    
    private static final String OPENAI_API_KEY = "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";

//    private static final String OPENAI_API_KEY = System.getenv("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"); // Get API key from environment variable
    private static final String API_URL = "https://api.openai.com/v1/chat/completions";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");
        
        System.out.println("API Key: " + (OPENAI_API_KEY != null ? "Configured" : "Not configured"));
        
        if (OPENAI_API_KEY == null || OPENAI_API_KEY.trim().isEmpty()) {
            System.out.println("API Key is missing or empty");
            resp.getWriter().write("{\"error\":\"API key not configured\"}");
            return;
        }

        String userMessage = req.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            System.out.println("User message is empty");
            resp.getWriter().write("{\"error\":\"Message is required\"}");
            return;
        }

        try {
            System.out.println("Calling OpenAI API with message: " + userMessage);
            String response = callOpenAI(userMessage);
            System.out.println("OpenAI API Response: " + response);
            resp.getWriter().write(response);
        } catch (Exception e) {
            System.out.println("Error calling OpenAI API: " + e.getMessage());
            e.printStackTrace();
            resp.getWriter().write("{\"error\":\"Error processing request: " + e.getMessage() + "\"}");
        }
    }

    private String callOpenAI(String message) throws IOException {
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");
        
        JSONArray messages = new JSONArray();
        JSONObject userMessage = new JSONObject();
        userMessage.put("role", "user");
        userMessage.put("content", message);
        messages.put(userMessage);
        
        requestBody.put("messages", messages);

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        System.out.println("OpenAI API Response Code: " + responseCode);
        
        if (responseCode != HttpURLConnection.HTTP_OK) {
            String errorMessage = "";
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    errorMessage += responseLine.trim();
                }
            }
            System.out.println("OpenAI API Error Response: " + errorMessage);
            throw new IOException("HTTP error code: " + responseCode + ", Error message: " + errorMessage);
        }

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            StringBuilder response = new StringBuilder();
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            return response.toString();
        }
    }
}
