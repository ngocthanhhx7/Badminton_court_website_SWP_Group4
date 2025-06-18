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
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", "API key not configured. Please contact support.");
            errorResponse.put("error_type", "configuration_error");
            errorResponse.put("error_code", 500);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(errorResponse.toString());
            return;
        }

        // Validate API key format
        if (!isValidApiKeyFormat(OPENAI_API_KEY)) {
            System.out.println("API Key format is invalid");
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", "API key format is invalid. Please contact support.");
            errorResponse.put("error_type", "configuration_error");
            errorResponse.put("error_code", 500);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(errorResponse.toString());
            return;
        }

        String userMessage = req.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            System.out.println("User message is empty");
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", "Message is required");
            errorResponse.put("error_type", "validation_error");
            errorResponse.put("error_code", 400);
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(errorResponse.toString());
            return;
        }

        try {
            System.out.println("Calling OpenAI API with message: " + userMessage);
            System.out.println("Message length: " + userMessage.length() + " characters");
            long startTime = System.currentTimeMillis();
            
            String response = callOpenAI(userMessage);
            
            long endTime = System.currentTimeMillis();
            System.out.println("OpenAI API call completed in " + (endTime - startTime) + "ms");
            System.out.println("OpenAI API Response: " + response);
            
            // Check if the response contains an error
            if (response.contains("\"error\"")) {
                System.out.println("OpenAI API returned an error response");
                resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            } else {
                System.out.println("OpenAI API call successful");
            }
            
            resp.getWriter().write(response);
        } catch (Exception e) {
            System.out.println("Error calling OpenAI API: " + e.getMessage());
            System.out.println("Exception type: " + e.getClass().getSimpleName());
            e.printStackTrace();
            
            JSONObject errorResponse = new JSONObject();
            errorResponse.put("error", "Internal server error. Please try again later.");
            errorResponse.put("error_type", "internal_error");
            errorResponse.put("error_code", 500);
            errorResponse.put("suggestion", "An unexpected error occurred. Please try again or contact support if the problem persists.");
            
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(errorResponse.toString());
        }
    }

    /**
     * Validates the format of the OpenAI API key
     * @param apiKey The API key to validate
     * @return true if the format is valid, false otherwise
     */
    private boolean isValidApiKeyFormat(String apiKey) {
        if (apiKey == null || apiKey.trim().isEmpty()) {
            return false;
        }
        
        // OpenAI API keys typically start with "sk-" and are 51 characters long
        // For newer models, they might start with "sk-proj-" and be longer
        String trimmedKey = apiKey.trim();
        return (trimmedKey.startsWith("sk-") && trimmedKey.length() >= 20) ||
               (trimmedKey.startsWith("sk-proj-") && trimmedKey.length() >= 30);
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
            
            // Handle specific error codes
            if (responseCode == 429) {
                // Quota exceeded or rate limited
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "API quota exceeded. Please try again later or contact support.");
                errorResponse.put("error_type", "quota_exceeded");
                errorResponse.put("error_code", 429);
                errorResponse.put("suggestion", "This error occurs when the API usage limit has been reached. Please wait a moment and try again, or contact support for assistance.");
                errorResponse.put("retry_after", "Please wait a few minutes before trying again.");
                return errorResponse.toString();
            } else if (responseCode == 401) {
                // Unauthorized - API key issue
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "API key is invalid or expired. Please contact support.");
                errorResponse.put("error_type", "unauthorized");
                errorResponse.put("error_code", 401);
                errorResponse.put("suggestion", "The API key may have expired or been revoked. Please contact support to update the configuration.");
                return errorResponse.toString();
            } else if (responseCode == 400) {
                // Bad request
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "Invalid request. Please check your input and try again.");
                errorResponse.put("error_type", "bad_request");
                errorResponse.put("error_code", 400);
                errorResponse.put("suggestion", "Please ensure your message is properly formatted and try again.");
                return errorResponse.toString();
            } else {
                // Other HTTP errors
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "Service temporarily unavailable. Please try again later.");
                errorResponse.put("error_type", "server_error");
                errorResponse.put("error_code", responseCode);
                errorResponse.put("suggestion", "The service is experiencing issues. Please try again in a few minutes.");
                return errorResponse.toString();
            }
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
