package com.ecotracker.dao;

import com.ecotracker.util.DBConnection;
import java.sql.*;

public class UserProfileDAO {

    // ===== CHECK CURRENT PASSWORD =====
    public boolean isCurrentPasswordValid(int userId, String currentPassword) {
        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT password FROM users WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("password").equals(currentPassword);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===== UPDATE PASSWORD =====
    public boolean updatePassword(int userId, String newPassword) {
        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE users SET password=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===== UPDATE PROFILE =====
    public boolean updateProfile(int userId, String name, String email,
                                 String bio, String location) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE users SET name=?, email=?, bio=?, location=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, bio);
            ps.setString(4, location);
            ps.setInt(5, userId);

            return ps.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            throw new RuntimeException("EMAIL_EXISTS");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===== UPDATE PROFILE PHOTO =====
    public boolean updateProfilePhoto(int userId, String photoPath) {

        try (Connection con = DBConnection.getConnection()) {

            String sql = "UPDATE users SET profile_photo=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, photoPath);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}