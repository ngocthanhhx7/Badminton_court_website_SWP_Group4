package controller.user;

import dao.CourtScheduleDAO;
import dao.CourtDAO;
import dao.ServiceDAO;
import models.CourtScheduleDTO;
import models.CourtDTO;
import models.ServiceDTO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.logging.Logger;
import java.util.logging.Level;
import utils.DBUtils;

@WebServlet(name = "ChatbotController", urlPatterns = {"/chatbot-api"})
public class ChatbotController extends HttpServlet {
    
    private final CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
    private final CourtDAO courtDAO = new CourtDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final Gson gson = new Gson();
    private static final Logger LOGGER = Logger.getLogger(ChatbotController.class.getName());
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Add CORS headers
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setHeader("Access-Control-Max-Age", "86400");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Parse the request body
            JsonObject requestBody = gson.fromJson(request.getReader(), JsonObject.class);
            String action = requestBody.get("action").getAsString();
            
            LOGGER.info("Chatbot API called with action: " + action);
            
            JsonObject result = new JsonObject();
            
            switch (action) {
                case "getAvailableSchedules":
                    handleGetAvailableSchedules(requestBody, result);
                    break;
                case "getSchedulesByDate":
                    handleGetSchedulesByDate(requestBody, result);
                    break;
                case "getSchedulesByCourt":
                    handleGetSchedulesByCourt(requestBody, result);
                    break;
                case "getBookingInfo":
                    handleGetBookingInfo(result);
                    break;
                case "getAllCourts":
                    handleGetAllCourts(result);
                    break;
                case "getCourtsByType":
                    handleGetCourtsByType(requestBody, result);
                    break;
                case "getAllServices":
                    handleGetAllServices(result);
                    break;
                case "getServicesByType":
                    handleGetServicesByType(requestBody, result);
                    break;
                case "getCourtInfo":
                    handleGetCourtInfo(requestBody, result);
                    break;
                case "testConnection":
                    handleTestConnection(result);
                    break;
                default:
                    result.addProperty("error", "Unknown action: " + action);
                    LOGGER.warning("Unknown action requested: " + action);
                    break;
            }
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in ChatbotController: " + e.getMessage(), e);
            JsonObject error = new JsonObject();
            error.addProperty("error", "Internal server error: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }
    
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle preflight requests
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setHeader("Access-Control-Max-Age", "86400");
        response.setStatus(HttpServletResponse.SC_OK);
    }
    
    private void handleGetAvailableSchedules(JsonObject requestBody, JsonObject result) {
        try {
            String dateStr = requestBody.get("date").getAsString();
            LocalDate date = LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
            
            LOGGER.info("Getting available schedules for date: " + dateStr);
            
            List<CourtScheduleDTO> schedules = courtScheduleDAO.getAllAvailableSchedules(date);
            
            JsonObject data = new JsonObject();
            data.addProperty("date", dateStr);
            data.addProperty("totalAvailable", schedules.size());
            
            // Group by court
            java.util.Map<String, java.util.List<CourtScheduleDTO>> courtGroups = 
                schedules.stream().collect(java.util.stream.Collectors.groupingBy(
                    schedule -> schedule.getCourtName() + " (" + schedule.getCourtType() + ")"
                ));
            
            JsonObject courts = new JsonObject();
            for (java.util.Map.Entry<String, java.util.List<CourtScheduleDTO>> entry : courtGroups.entrySet()) {
                JsonObject courtInfo = new JsonObject();
                courtInfo.addProperty("count", entry.getValue().size());
                
                java.util.List<String> timeSlots = entry.getValue().stream()
                    .map(schedule -> schedule.getStartTime().toString() + " - " + schedule.getEndTime().toString())
                    .collect(java.util.stream.Collectors.toList());
                courtInfo.add("timeSlots", gson.toJsonTree(timeSlots));
                
                courts.add(entry.getKey(), courtInfo);
            }
            data.add("courts", courts);
            
            result.addProperty("success", true);
            result.add("data", data);
            
            LOGGER.info("Successfully retrieved " + schedules.size() + " available schedules");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting available schedules: " + e.getMessage(), e);
            result.addProperty("error", "Error getting available schedules: " + e.getMessage());
        }
    }
    
    private void handleGetSchedulesByDate(JsonObject requestBody, JsonObject result) {
        try {
            String dateStr = requestBody.get("date").getAsString();
            LocalDate date = LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
            
            LOGGER.info("Getting schedules by date: " + dateStr);
            
            List<CourtScheduleDTO> schedules = courtScheduleDAO.getAllAvailableSchedules(date);
            
            JsonObject data = new JsonObject();
            data.addProperty("date", dateStr);
            data.addProperty("totalSchedules", schedules.size());
            
            java.util.List<JsonObject> scheduleList = schedules.stream()
                .map(schedule -> {
                    JsonObject scheduleObj = new JsonObject();
                    scheduleObj.addProperty("courtName", schedule.getCourtName());
                    scheduleObj.addProperty("courtType", schedule.getCourtType());
                    scheduleObj.addProperty("startTime", schedule.getStartTime().toString());
                    scheduleObj.addProperty("endTime", schedule.getEndTime().toString());
                    scheduleObj.addProperty("price", schedule.getPrice());
                    return scheduleObj;
                })
                .collect(java.util.stream.Collectors.toList());
            
            data.add("schedules", gson.toJsonTree(scheduleList));
            
            result.addProperty("success", true);
            result.add("data", data);
            
            LOGGER.info("Successfully retrieved " + schedules.size() + " schedules for date: " + dateStr);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting schedules by date: " + e.getMessage(), e);
            result.addProperty("error", "Error getting schedules by date: " + e.getMessage());
        }
    }
    
    private void handleGetSchedulesByCourt(JsonObject requestBody, JsonObject result) {
        try {
            Integer courtId = requestBody.get("courtId").getAsInt();
            String dateStr = requestBody.get("date").getAsString();
            LocalDate date = LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
            
            LOGGER.info("Getting schedules for court ID: " + courtId + " on date: " + dateStr);
            
            List<CourtScheduleDTO> schedules = courtScheduleDAO.getAvailableSchedules(courtId, date);
            
            JsonObject data = new JsonObject();
            data.addProperty("courtId", courtId);
            data.addProperty("date", dateStr);
            data.addProperty("totalAvailable", schedules.size());
            
            java.util.List<JsonObject> scheduleList = schedules.stream()
                .map(schedule -> {
                    JsonObject scheduleObj = new JsonObject();
                    scheduleObj.addProperty("startTime", schedule.getStartTime().toString());
                    scheduleObj.addProperty("endTime", schedule.getEndTime().toString());
                    scheduleObj.addProperty("price", schedule.getPrice());
                    return scheduleObj;
                })
                .collect(java.util.stream.Collectors.toList());
            
            data.add("schedules", gson.toJsonTree(scheduleList));
            
            result.addProperty("success", true);
            result.add("data", data);
            
            LOGGER.info("Successfully retrieved " + schedules.size() + " schedules for court ID: " + courtId);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting schedules by court: " + e.getMessage(), e);
            result.addProperty("error", "Error getting schedules by court: " + e.getMessage());
        }
    }
    
    private void handleGetAllCourts(JsonObject result) {
        try {
            LOGGER.info("Getting all courts...");
            
            // First test database connection
            if (!DBUtils.testConnection()) {
                result.addProperty("error", "Database connection failed");
                LOGGER.severe("Database connection test failed");
                return;
            }
            
            List<CourtDTO> courts = courtDAO.getAllCourts();
            LOGGER.info("Retrieved " + (courts != null ? courts.size() : 0) + " courts");
            
            JsonObject data = new JsonObject();
            data.addProperty("totalCourts", courts != null ? courts.size() : 0);
            
            if (courts != null && !courts.isEmpty()) {
                java.util.List<JsonObject> courtList = courts.stream()
                    .map(court -> {
                        JsonObject courtObj = new JsonObject();
                        courtObj.addProperty("courtId", court.getCourtId());
                        courtObj.addProperty("courtName", court.getCourtName());
                        courtObj.addProperty("courtType", court.getCourtType());
                        courtObj.addProperty("status", court.getStatus());
                        courtObj.addProperty("description", court.getDescription());
                        return courtObj;
                    })
                    .collect(java.util.stream.Collectors.toList());
                
                data.add("courts", gson.toJsonTree(courtList));
                LOGGER.info("Successfully processed " + courtList.size() + " courts");
            } else {
                data.add("courts", gson.toJsonTree(new ArrayList<>()));
                LOGGER.warning("No courts found or null result");
            }
            
            result.addProperty("success", true);
            result.add("data", data);
            LOGGER.info("getAllCourts completed successfully");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in getAllCourts: " + e.getMessage(), e);
            result.addProperty("error", "Error getting all courts: " + e.getMessage());
        }
    }
    
    private void handleGetCourtsByType(JsonObject requestBody, JsonObject result) {
        try {
            String courtType = requestBody.get("courtType").getAsString();
            LOGGER.info("Getting courts by type: " + courtType);
            
            // First test database connection
            if (!DBUtils.testConnection()) {
                result.addProperty("error", "Database connection failed");
                LOGGER.severe("Database connection test failed");
                return;
            }
            
            List<CourtDTO> courts = courtDAO.getCourtsByType(courtType);
            LOGGER.info("Retrieved " + (courts != null ? courts.size() : 0) + " courts for type: " + courtType);
            
            JsonObject data = new JsonObject();
            data.addProperty("courtType", courtType);
            data.addProperty("totalCourts", courts != null ? courts.size() : 0);
            
            if (courts != null && !courts.isEmpty()) {
                java.util.List<JsonObject> courtList = courts.stream()
                    .map(court -> {
                        JsonObject courtObj = new JsonObject();
                        courtObj.addProperty("courtId", court.getCourtId());
                        courtObj.addProperty("courtName", court.getCourtName());
                        courtObj.addProperty("courtType", court.getCourtType());
                        courtObj.addProperty("status", court.getStatus());
                        courtObj.addProperty("description", court.getDescription());
                        return courtObj;
                    })
                    .collect(java.util.stream.Collectors.toList());
                
                data.add("courts", gson.toJsonTree(courtList));
                LOGGER.info("Successfully processed " + courtList.size() + " courts for type: " + courtType);
            } else {
                data.add("courts", gson.toJsonTree(new ArrayList<>()));
                LOGGER.warning("No courts found for type: " + courtType);
            }
            
            result.addProperty("success", true);
            result.add("data", data);
            LOGGER.info("getCourtsByType completed successfully");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in getCourtsByType: " + e.getMessage(), e);
            result.addProperty("error", "Error getting courts by type: " + e.getMessage());
        }
    }
    
    private void handleGetAllServices(JsonObject result) {
        try {
            LOGGER.info("Getting all services...");
            
            // First test database connection
            if (!DBUtils.testConnection()) {
                result.addProperty("error", "Database connection failed");
                LOGGER.severe("Database connection test failed");
                return;
            }
            
            List<ServiceDTO> services = serviceDAO.getAllActiveServices();
            LOGGER.info("Retrieved " + (services != null ? services.size() : 0) + " services");
            
            JsonObject data = new JsonObject();
            data.addProperty("totalServices", services != null ? services.size() : 0);
            
            if (services != null && !services.isEmpty()) {
                java.util.List<JsonObject> serviceList = services.stream()
                    .map(service -> {
                        JsonObject serviceObj = new JsonObject();
                        serviceObj.addProperty("serviceId", service.getServiceID());
                        serviceObj.addProperty("serviceName", service.getServiceName());
                        serviceObj.addProperty("serviceType", service.getServiceType());
                        serviceObj.addProperty("description", service.getDescription());
                        serviceObj.addProperty("unit", service.getUnit());
                        serviceObj.addProperty("price", service.getPrice());
                        serviceObj.addProperty("status", service.getStatus());
                        return serviceObj;
                    })
                    .collect(java.util.stream.Collectors.toList());
                
                data.add("services", gson.toJsonTree(serviceList));
                LOGGER.info("Successfully processed " + serviceList.size() + " services");
            } else {
                data.add("services", gson.toJsonTree(new ArrayList<>()));
                LOGGER.warning("No services found");
            }
            
            result.addProperty("success", true);
            result.add("data", data);
            LOGGER.info("getAllServices completed successfully");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all services: " + e.getMessage(), e);
            result.addProperty("error", "Error getting all services: " + e.getMessage());
        }
    }
    
    private void handleGetServicesByType(JsonObject requestBody, JsonObject result) {
        try {
            String serviceType = requestBody.get("serviceType").getAsString();
            LOGGER.info("Getting services by type: " + serviceType);
            
            List<ServiceDTO> allServices = serviceDAO.getAllActiveServices();
            
            // Filter by service type
            List<ServiceDTO> services = allServices.stream()
                .filter(service -> service.getServiceType().equalsIgnoreCase(serviceType))
                .collect(java.util.stream.Collectors.toList());
            
            JsonObject data = new JsonObject();
            data.addProperty("serviceType", serviceType);
            data.addProperty("totalServices", services.size());
            
            java.util.List<JsonObject> serviceList = services.stream()
                .map(service -> {
                    JsonObject serviceObj = new JsonObject();
                    serviceObj.addProperty("serviceId", service.getServiceID());
                    serviceObj.addProperty("serviceName", service.getServiceName());
                    serviceObj.addProperty("serviceType", service.getServiceType());
                    serviceObj.addProperty("description", service.getDescription());
                    serviceObj.addProperty("unit", service.getUnit());
                    serviceObj.addProperty("price", service.getPrice());
                    serviceObj.addProperty("status", service.getStatus());
                    return serviceObj;
                })
                .collect(java.util.stream.Collectors.toList());
            
            data.add("services", gson.toJsonTree(serviceList));
            
            result.addProperty("success", true);
            result.add("data", data);
            
            LOGGER.info("Successfully retrieved " + services.size() + " services for type: " + serviceType);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting services by type: " + e.getMessage(), e);
            result.addProperty("error", "Error getting services by type: " + e.getMessage());
        }
    }
    
    private void handleGetCourtInfo(JsonObject requestBody, JsonObject result) {
        try {
            Integer courtId = requestBody.get("courtId").getAsInt();
            LOGGER.info("Getting court info for ID: " + courtId);
            
            CourtDTO court = courtDAO.getCourtById(courtId);
            
            if (court == null) {
                result.addProperty("error", "Court not found");
                LOGGER.warning("Court not found for ID: " + courtId);
                return;
            }
            
            JsonObject data = new JsonObject();
            data.addProperty("courtId", court.getCourtId());
            data.addProperty("courtName", court.getCourtName());
            data.addProperty("courtType", court.getCourtType());
            data.addProperty("status", court.getStatus());
            data.addProperty("description", court.getDescription());
            
            result.addProperty("success", true);
            result.add("data", data);
            
            LOGGER.info("Successfully retrieved court info for ID: " + courtId);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting court info: " + e.getMessage(), e);
            result.addProperty("error", "Error getting court info: " + e.getMessage());
        }
    }
    
    private void handleGetBookingInfo(JsonObject result) {
        try {
            LOGGER.info("Getting booking information...");
            
            JsonObject data = new JsonObject();
            data.addProperty("bookingSteps", "1. Chọn ngày đặt sân\n2. Chọn sân và khung giờ phù hợp\n3. Điền thông tin cá nhân\n4. Xác nhận đặt sân\n5. Thanh toán");
            data.addProperty("contactInfo", "Hotline: 0981944060 | Email: booking@badmintonhub.com");
            data.addProperty("workingHours", "Thứ 2 - Chủ nhật: 6:00 - 22:00");
            data.addProperty("cancellationPolicy", "Hủy đặt sân trước 24h được hoàn tiền 100%, trước 12h được hoàn tiền 50%");
            
            result.addProperty("success", true);
            result.add("data", data);
            
            LOGGER.info("Successfully retrieved booking information");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting booking info: " + e.getMessage(), e);
            result.addProperty("error", "Error getting booking info: " + e.getMessage());
        }
    }

    private void handleTestConnection(JsonObject result) {
        try {
            LOGGER.info("Testing database connection...");
            
            // Test database connection
            boolean connectionTest = DBUtils.testConnection();
            
            if (connectionTest) {
                // Attempt to get all courts to test full functionality
                List<CourtDTO> courts = courtDAO.getAllCourts();
                if (courts != null && !courts.isEmpty()) {
                    result.addProperty("success", true);
                    result.addProperty("message", "Database connection successful. Retrieved " + courts.size() + " courts.");
                    LOGGER.info("Database connection test successful. Retrieved " + courts.size() + " courts.");
                } else {
                    result.addProperty("success", false);
                    result.addProperty("message", "Database connection successful but no courts found.");
                    LOGGER.warning("Database connection successful but no courts found.");
                }
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "Database connection failed.");
                LOGGER.severe("Database connection test failed.");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database connection test failed: " + e.getMessage(), e);
            result.addProperty("success", false);
            result.addProperty("message", "Database connection failed: " + e.getMessage());
        }
    }
} 