package utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {
    
    private static final String UPLOAD_DIRECTORY = "img/carousel";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    
    public static String uploadFile(Part filePart, String contextPath) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        // Validate file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds maximum limit of 5MB");
        }
        
        // Get file extension
        String fileName = getSubmittedFileName(filePart);
        String fileExtension = getFileExtension(fileName);
        
        // Validate file extension
        if (!isValidExtension(fileExtension)) {
            throw new IOException("Invalid file type. Allowed types: " + String.join(", ", ALLOWED_EXTENSIONS));
        }
        
        // Generate unique filename
        String uniqueFileName = generateUniqueFileName(fileExtension);
        
        // Create upload directory if it doesn't exist
        String uploadPath = contextPath + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Save file
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);
        
        // Return relative path for database storage
        return "/" + UPLOAD_DIRECTORY + "/" + uniqueFileName;
    }
    
    private static String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
    
    private static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1) {
            return "";
        }
        return fileName.substring(lastDotIndex).toLowerCase();
    }
    
    private static boolean isValidExtension(String extension) {
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (allowedExt.equals(extension)) {
                return true;
            }
        }
        return false;
    }
    
    private static String generateUniqueFileName(String extension) {
        return UUID.randomUUID().toString() + extension;
    }
    
    public static boolean deleteFile(String filePath, String contextPath) {
        if (filePath == null || filePath.isEmpty() || filePath.startsWith("http")) {
            return false; // Don't delete external URLs
        }
        
        try {
            String fullPath = contextPath + filePath;
            Path path = Paths.get(fullPath);
            return Files.deleteIfExists(path);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static boolean isValidImageFile(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            return false;
        }
        
        // Check file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            return false;
        }
        
        // Check file extension
        String fileName = getSubmittedFileName(filePart);
        String fileExtension = getFileExtension(fileName);
        return isValidExtension(fileExtension);
    }
} 