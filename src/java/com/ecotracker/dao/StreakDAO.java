package com.ecotracker.dao;

import com.ecotracker.util.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

public class StreakDAO {

    public Set<LocalDate> getUserLoggedDates(int userId) {

        Set<LocalDate> loggedDates = new HashSet<>();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                "SELECT created_at FROM (" +
                " SELECT created_at FROM transportation_logs WHERE user_id=? " +
                " UNION " +
                " SELECT created_at FROM food_consumption_logs WHERE user_id=? " +
                " UNION " +
                " SELECT created_at FROM energy_consumption WHERE user_id=? " +
                ") t";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                loggedDates.add(rs.getDate("created_at").toLocalDate());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return loggedDates;
    }
}