package com.ecotracker.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.ecotracker.dao.UserProfileDAO;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Disable cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // Get parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        // Validation
        if (currentPassword == null || newPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
            return;
        }

        try {
            UserProfileDAO dao = new UserProfileDAO();

            // Check current password
            if (!dao.isCurrentPasswordValid(userId, currentPassword)) {
                request.setAttribute("errorMessage", "Current password is incorrect");
                request.getRequestDispatcher("settings.jsp").forward(request, response);
                return;
            }

            // Update password
            boolean updated = dao.updatePassword(userId, newPassword);

            if (updated) {
                request.setAttribute("successMessage", "Password updated successfully");
            } else {
                request.setAttribute("errorMessage", "Password update failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Something went wrong");
        }

        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }
}
