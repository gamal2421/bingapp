package mypackage.utl;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DataBase {
    private static HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();

        // ✅ New connection details from the URL
        config.setJdbcUrl("jdbc:postgresql://pg-7df2fd3-waleedgamal2821-a9bd.l.aivencloud.com:14381/PingBook?sslmode=require");
        config.setUsername("avnadmin");
        config.setPassword("AVNS_v6Of1LG2FuojSos4Hvk");

        config.setDriverClassName("org.postgresql.Driver");

        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);

        dataSource = new HikariDataSource(config);
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}
