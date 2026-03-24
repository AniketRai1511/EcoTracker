package com.ecotracker.dao;

import com.ecotracker.util.DBConnection;
import java.sql.*;

public class FoodDAO {

    public double saveBatch(int userId, String userName, String routine,
                            String[] foods, String[] quantities) {

        double totalEmission = 0;

        try (Connection con = DBConnection.getConnection()) {

            String sql = "INSERT INTO food_consumption_logs " +
                    "(user_id, user_name, routine_type, food_type, quantity, emission_kg) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < foods.length; i++) {

                if (quantities[i] == null || quantities[i].trim().isEmpty()) continue;

                double qty = Double.parseDouble(quantities[i]);
                double emission = qty * getFactor(foods[i]);

                totalEmission += emission;

                ps.setInt(1, userId);
                ps.setString(2, userName);
                ps.setString(3, routine);
                ps.setString(4, foods[i]);
                ps.setDouble(5, qty);
                ps.setDouble(6, emission);

                ps.addBatch();
            }

            ps.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return totalEmission;
    }

    private double getFactor(String food) {
        switch (food) {
            case "Vegetables": return 0.4;
            case "Chicken": return 6.9;
            case "Mutton / Goat Meat": return 20.0;
            case "Paneer / Cheese": return 5.9;
            case "Eggs": return 4.5;
            default: return 1.0;
        }
    }
}