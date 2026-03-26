package com.ecotracker.dao;

import com.ecotracker.util.DBConnection;
import java.sql.*;

public class EnergyDAO {

    public double saveBatch(int userId, String userName, String routine,
                            String[] types, String[] unitsArr) {

        double totalEmission = 0;

        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO energy_consumption " +
                    "(user_id, username, routine, energy_type, units, emission) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < types.length; i++) {

                if (unitsArr[i] == null || unitsArr[i].trim().isEmpty()) continue;

                double units = Double.parseDouble(unitsArr[i]);
                double emission = units * getFactor(types[i]);

                totalEmission += emission;

                ps.setInt(1, userId);
                ps.setString(2, userName);
                ps.setString(3, routine);
                ps.setString(4, types[i]);
                ps.setDouble(5, units);
                ps.setDouble(6, emission);

                ps.addBatch();
            }

            ps.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalEmission;
    }

    private double getFactor(String type) {
        switch (type) {
            case "Electricity (Grid)": return 0.82;
            case "LPG (Cooking Gas)": return 2.98;
            case "Diesel Generator": return 2.68;
            case "Petrol Generator": return 2.31;
            case "Solar Power": return 0.05;
            default: return 1.0;
        }
    }
}