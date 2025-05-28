package dao;

import java.sql.Connection;
import utils.DBUtils;

public class DBContext {
    private static DBContext instance;
    private Connection connection;

    private DBContext() {
        // Không khởi tạo kết nối ngay, chỉ khi cần
    }

    public static synchronized DBContext getInstance() {
        if (instance == null) {
            instance = new DBContext();
        }
        return instance;
    }

    public Connection getConnection() {
        if (connection == null) {
            connection = DBUtils.getConnection();
        }
        return connection;
    }
}
