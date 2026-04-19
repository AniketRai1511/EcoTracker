package com.ecotracker.dao;

import com.ecotracker.util.DBConnection;
import java.sql.*;
import java.util.*;

public class DashboardDAO {

    public double getTransportEmission(int userId) throws Exception {
        String sql = "SELECT IFNULL(SUM(emission_kg),0) FROM transportation_logs WHERE user_id=?";
        return getSingleValue(sql, userId);
    }

    public double getFoodEmission(int userId) throws Exception {
        String sql = "SELECT IFNULL(SUM(emission_kg),0) FROM food_consumption_logs WHERE user_id=?";
        return getSingleValue(sql, userId);
    }

    public double getEnergyEmission(int userId) throws Exception {
        String sql = "SELECT IFNULL(SUM(emission),0) FROM energy_consumption WHERE user_id=?";
        return getSingleValue(sql, userId);
    }

    private double getSingleValue(String sql, int userId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0;
        }
    }

    public Map<String, List<?>> getLast7DaysData(int userId) throws Exception {

        List<Double> data = new ArrayList<>();
        List<String> labels = new ArrayList<>();

        String sql =
            "SELECT DATE(created_at) d, " +
            "(SUM(t.emission_kg) + " +
            " IFNULL((SELECT SUM(f.emission_kg) FROM food_consumption_logs f WHERE f.user_id=? AND DATE(f.created_at)=d),0) + " +
            " IFNULL((SELECT SUM(e.emission) FROM energy_consumption e WHERE e.user_id=? AND DATE(e.created_at)=d),0)) total " +
            "FROM transportation_logs t " +
            "WHERE t.user_id=? AND created_at >= CURDATE() - INTERVAL 6 DAY " +
            "GROUP BY d ORDER BY d";

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                labels.add(rs.getDate("d").toString());
                data.add(rs.getDouble("total"));
            }
        }

        Map<String, List<?>> map = new HashMap<>();
        map.put("labels", labels);
        map.put("data", data);

        return map;
    }
}