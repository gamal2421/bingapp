package mypackage.utl;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DataBase {
    private static HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();

        // بيانات الاتصال عندك
        config.setJdbcUrl("jdbc:postgresql://pg-204c693f-waleedgamal2821-a9bd.f.aivencloud.com:14381/defaultdb?sslmode=require");
        config.setUsername("avnadmin");
        config.setPassword("AVNS_4K6aK5QsXXUYxk4LVoY");

        // تعريف السائق (غالباً مش ضروري مع الإصدارات الحديثة، لكن يمكن إضافته)
        config.setDriverClassName("org.postgresql.Driver");

        // إعدادات Pool (تقدر تغيرها حسب احتياجك)
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
