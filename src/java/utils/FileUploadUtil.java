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
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; 
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    
    public static String uploadFile(Part filePart, String contextPath) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IOException("File size exceeds maximum limit of 5MB");
        }
        
        String fileName = getSubmittedFileName(filePart);
        String fileExtension = getFileExtension(fileName);
        
        if (!isValidExtension(fileExtension)) {
            throw new IOException("Invalid file type. Allowed types: " + String.join(", ", ALLOWED_EXTENSIONS));
        }
        
        String uniqueFileName = generateUniqueFileName(fileExtension);
        
        String uploadPath = contextPath + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        String filePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(filePath);
        
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
            return false; 
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
        
        if (filePart.getSize() > MAX_FILE_SIZE) {
            return false;
        }
        
        String fileName = getSubmittedFileName(filePart);
        String fileExtension = getFileExtension(fileName);
        return isValidExtension(fileExtension);
    }
} 