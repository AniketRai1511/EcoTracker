package com.ecotracker.dao;

import com.ecotracker.util.DBConnection;
import java.sql.*;

public class ProgressDAO {

    public double getTransport(int userId) throws Exception {
        String sql = "SELECT IFNULL(SUM(emission_kg),0) FROM transportation_logs " +
                     "WHERE user_id=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())";
        return getValue(sql, userId);
    }

    public double getFood(int userId) throws Exception {
        String sql = "SELECT IFNULL(SUM(emission_kg),0) FROM food_consumption_logs " +
                     "WHERE user_id=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())";
        return getValue(sql, userId);
    }

    public double getEnergy(int userId) throws Exception {
        String sql = "SELECT IFNULL(SUM(emission),0) FROM energy_consumption " +
                     "WHERE user_id=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())";
        return getValue(sql, userId);
    }

    public int getTrackingDays(int userId) throws Exception {
        String sql = "SELECT COUNT(DISTINCT DATE(created_at)) FROM transportation_logs WHERE user_id=?";
        return getIntValue(sql, userId);
    }

    public int getTransportCount(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM transportation_logs WHERE user_id=?";
        return getIntValue(sql, userId);
    }

    private double getValue(String sql, int userId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0;
        }
    }

    private int getIntValue(String sql, int userId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}