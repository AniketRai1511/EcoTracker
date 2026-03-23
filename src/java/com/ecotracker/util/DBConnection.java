package com.ecotracker.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String host = System.getenv("DB_HOST");
            String port = System.getenv("DB_PORT");
            String db   = System.getenv("DB_NAME");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");

            // Validation check
            if (host == null || port == null || db == null || user == null || pass == null) {
                throw new RuntimeException("Database environment variables are not set properly.");
            }

            String url =
                "jdbc:mysql://" + host + ":" + port + "/" + db +
                "?useUnicode=true" +
                "&characterEncoding=UTF-8" +
                "&serverTimezone=UTC" +
                "&allowPublicKeyRetrieval=true" +
                "&useSSL=false";

            return DriverManager.getConnection(url, user, pass);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}