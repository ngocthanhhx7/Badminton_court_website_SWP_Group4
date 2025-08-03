/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBUtils {
    
    private final static String serverName = "localhost";
    private final static String dbName = "BadmintonHub";
    private final static String portNumber = "1433";
    private final static String instance = "";//LEAVE THIS ONE EMPTY IF YOUR SQL IS A SINGLE INSTANCE
    private final static String userID = "sa";
    private final static String password = "123";
    
    private static final Logger LOGGER = Logger.getLogger(DBUtils.class.getName());

    public static Connection getConnection() {
        try {
            String url = "jdbc:sqlserver://" + serverName + ":" + portNumber + "\\" + instance + ";databaseName=" + dbName;
            if (instance == null || instance.trim().isEmpty()) {
                url = "jdbc:sqlserver://" + serverName + ":" + portNumber + ";databaseName=" + dbName;
            }
            
            LOGGER.info("Attempting to connect to database: " + url);
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection connection = DriverManager.getConnection(url, userID, password);
            
            if (connection != null && !connection.isClosed()) {
                LOGGER.info("Database connection established successfully");
                return connection;
            } else {
                LOGGER.severe("Failed to establish database connection - connection is null or closed");
                return null;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "SQL Connection error: " + ex.getMessage(), ex);
            System.err.println("SQL Connection error! " + ex.getMessage());
            ex.printStackTrace();
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "JDBC Driver not found: " + ex.getMessage(), ex);
            System.err.println("JDBC Driver not found! " + ex.getMessage());
            ex.printStackTrace();
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Unexpected error during database connection: " + ex.getMessage(), ex);
            System.err.println("Unexpected database connection error! " + ex.getMessage());
            ex.printStackTrace();
        }
        return null;
    }
    
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                LOGGER.info("Database connection test successful");
                return true;
            } else {
                LOGGER.warning("Database connection test failed - connection is null or closed");
                return false;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database connection test failed: " + e.getMessage(), e);
            return false;
        }
    }
    
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        System.out.println("Server: " + serverName);
        System.out.println("Database: " + dbName);
        System.out.println("Port: " + portNumber);
        System.out.println("User: " + userID);
        
        if(DBUtils.getConnection() != null) {
            System.out.println("Connect successfully");
        } else {
            System.out.println("Connect failed - please check:");
            System.out.println("1. SQL Server is running");
            System.out.println("2. Database 'BadmintonHub' exists");
            System.out.println("3. User 'sa' with password '123' has access");
            System.out.println("4. Port 1433 is open");
        }
    }
}
