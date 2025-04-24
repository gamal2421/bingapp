package mypackage.utl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBase {
    private static final String URL = "jdbc:postgresql://ballast.proxy.rlwy.net:33890/railway";
    private static final String USER = "postgres";
    private static final String PASSWORD = "DlETyzLBsPNeETaKhIcpzAdmlNHASjZc";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver"); // Optional in modern Java, but safe to include
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC Driver not found.", e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
