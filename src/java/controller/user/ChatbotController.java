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

@WebServlet(name = "ChatbotController", urlPatterns = {"/chatbot-api"})
public class ChatbotController extends HttpServlet {
    
    private final CourtScheduleDAO courtScheduleDAO = new CourtScheduleDAO();
    private final CourtDAO courtDAO = new CourtDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Parse the request body
            JsonObject requestBody = gson.fromJson(request.getReader(), JsonObject.class);
            String action = requestBody.get("action").getAsString();
            
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
                    break;
            }
            
            response.getWriter().write(gson.toJson(result));
            
        } catch (Exception e) {
            JsonObject error = new JsonObject();
            error.addProperty("error", "Internal server error: " + e.getMessage());
            response.getWriter().write(gson.toJson(error));
        }
    }
    
    private void handleGetAvailableSchedules(JsonObject requestBody, JsonObject result) {
        try {
            String dateStr = requestBody.get("date").getAsString();
            LocalDate date = LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
            
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
            
        } catch (Exception e) {
            result.addProperty("error", "Error getting available schedules: " + e.getMessage());
        }
    }
    
    private void handleGetSchedulesByDate(JsonObject requestBody, JsonObject result) {
        try {
            String dateStr = requestBody.get("date").getAsString();
            LocalDate date = LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
            
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
            
        } catch (Exception e) {
            result.addProperty("error", "Error getting schedules by date: " + e.getMessage());
        }
    }
    
    private void handleGetSchedulesByCourt(JsonObject requestBody, JsonObject result) {
        try {
            Integer courtId = requestBody.get("courtId").getAsInt();
            String dateStr = requestBody.get("date").getAsString();
            LocalDate date = LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
            
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
            
        } catch (Exception e) {
            result.addProperty("error", "Error getting schedules by court: " + e.getMessage());
        }
    }
    
    private void handleGetAllCourts(JsonObject result) {
        try {
            System.out.println("ChatbotController: Starting getAllCourts...");
            List<CourtDTO> courts = courtDAO.getAllCourts();
            System.out.println("ChatbotController: Retrieved " + (courts != null ? courts.size() : 0) + " courts");
            
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
                System.out.println("ChatbotController: Successfully processed " + courtList.size() + " courts");
            } else {
                data.add("courts", gson.toJsonTree(new ArrayList<>()));
                System.out.println("ChatbotController: No courts found or null result");
            }
            
            result.addProperty("success", true);
            result.add("data", data);
            System.out.println("ChatbotController: getAllCourts completed successfully");
            
        } catch (Exception e) {
            System.err.println("ChatbotController: Error in getAllCourts: " + e.getMessage());
            e.printStackTrace();
            result.addProperty("error", "Error getting all courts: " + e.getMessage());
        }
    }
    
    private void handleGetCourtsByType(JsonObject requestBody, JsonObject result) {
        try {
            String courtType = requestBody.get("courtType").getAsString();
            System.out.println("ChatbotController: Starting getCourtsByType for type: " + courtType);
            
            List<CourtDTO> courts = courtDAO.getCourtsByType(courtType);
            System.out.println("ChatbotController: Retrieved " + (courts != null ? courts.size() : 0) + " courts for type: " + courtType);
            
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
                System.out.println("ChatbotController: Successfully processed " + courtList.size() + " courts for type: " + courtType);
            } else {
                data.add("courts", gson.toJsonTree(new ArrayList<>()));
                System.out.println("ChatbotController: No courts found for type: " + courtType);
            }
            
            result.addProperty("success", true);
            result.add("data", data);
            System.out.println("ChatbotController: getCourtsByType completed successfully");
            
        } catch (Exception e) {
            System.err.println("ChatbotController: Error in getCourtsByType: " + e.getMessage());
            e.printStackTrace();
            result.addProperty("error", "Error getting courts by type: " + e.getMessage());
        }
    }
    
    private void handleGetAllServices(JsonObject result) {
        try {
            List<ServiceDTO> services = serviceDAO.getAllActiveServices();
            
            JsonObject data = new JsonObject();
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
            
        } catch (Exception e) {
            result.addProperty("error", "Error getting all services: " + e.getMessage());
        }
    }
    
    private void handleGetServicesByType(JsonObject requestBody, JsonObject result) {
        try {
            String serviceType = requestBody.get("serviceType").getAsString();
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
            
        } catch (Exception e) {
            result.addProperty("error", "Error getting services by type: " + e.getMessage());
        }
    }
    
    private void handleGetCourtInfo(JsonObject requestBody, JsonObject result) {
        try {
            Integer courtId = requestBody.get("courtId").getAsInt();
            CourtDTO court = courtDAO.getCourtById(courtId);
            
            if (court == null) {
                result.addProperty("error", "Court not found");
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
            
        } catch (Exception e) {
            result.addProperty("error", "Error getting court info: " + e.getMessage());
        }
    }
    
    private void handleGetBookingInfo(JsonObject result) {
        JsonObject data = new JsonObject();
        data.addProperty("bookingSteps", "1. Chọn ngày đặt sân\n2. Chọn sân và khung giờ phù hợp\n3. Điền thông tin cá nhân\n4. Xác nhận đặt sân\n5. Thanh toán");
        data.addProperty("contactInfo", "Hotline: 0981944060 | Email: booking@badmintonhub.com");
        data.addProperty("workingHours", "Thứ 2 - Chủ nhật: 6:00 - 22:00");
        data.addProperty("cancellationPolicy", "Hủy đặt sân trước 24h được hoàn tiền 100%, trước 12h được hoàn tiền 50%");
        
        result.addProperty("success", true);
        result.add("data", data);
    }

    private void handleTestConnection(JsonObject result) {
        try {
            // Attempt to get all courts to test connection
            List<CourtDTO> courts = courtDAO.getAllCourts();
            if (courts != null && !courts.isEmpty()) {
                result.addProperty("success", true);
                result.addProperty("message", "Database connection successful. Retrieved " + courts.size() + " courts.");
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "Database connection failed or no courts found.");
            }
        } catch (Exception e) {
            result.addProperty("success", false);
            result.addProperty("message", "Database connection failed: " + e.getMessage());
        }
    }
} 