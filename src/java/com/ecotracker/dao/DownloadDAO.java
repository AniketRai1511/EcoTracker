package com.ecotracker.dao;

import com.ecotracker.util.DBConnection;
import java.sql.*;
import java.util.*;

public class DownloadDAO {

    public Map<String, String> getUserProfile(int userId) throws Exception {

        String sql = "SELECT name,email,bio,location FROM users WHERE id=?";

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("name", rs.getString("name"));
                map.put("email", rs.getString("email"));
                map.put("bio", rs.getString("bio"));
                map.put("location", rs.getString("location"));
                return map;
            }
        }

        return null;
    }

    public ResultSet getTransportData(Connection con, int userId) throws Exception {
        String sql = "SELECT transport_mode,distance_km,emission_kg,created_at FROM transportation_logs WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        return ps.executeQuery();
    }

    public ResultSet getFoodData(Connection con, int userId) throws Exception {
        String sql = "SELECT food_type,quantity,emission_kg,created_at FROM food_consumption_logs WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        return ps.executeQuery();
    }

    public ResultSet getEnergyData(Connection con, int userId) throws Exception {
        // ⚠ FIXED column name (your table uses energy_type, NOT energy_source)
        String sql = "SELECT energy_type,units,emission,created_at FROM energy_consumption WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        return ps.executeQuery();
    }
}