package com.ecotracker.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.ecotracker.dao.UserProfileDAO;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

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
        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");
        String bio = request.getParameter("bio");
        String location = request.getParameter("location");

        // Validation
        if (name == null || email == null ||
            name.trim().isEmpty() || email.trim().isEmpty()) {

            request.setAttribute("errorMessage", "Name and Email are required");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
            return;
        }

        try {
            UserProfileDAO dao = new UserProfileDAO();

            boolean updated = dao.updateProfile(userId, name, email, bio, location);

            if (updated) {
                // Update session
                session.setAttribute("userName", name);
                session.setAttribute("userEmail", email);
                session.setAttribute("bio", bio);
                session.setAttribute("location", location);

                request.setAttribute("successMessage", "Profile updated successfully");
            } else {
                request.setAttribute("errorMessage", "Profile update failed");
            }

        } catch (RuntimeException e) {
            if ("EMAIL_EXISTS".equals(e.getMessage())) {
                request.setAttribute("errorMessage", "Email already exists");
            } else {
                request.setAttribute("errorMessage", "Something went wrong");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error");
        }

        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }
}