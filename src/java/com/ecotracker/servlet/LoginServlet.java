package com.ecotracker.servlet;

import com.ecotracker.dao.UserDAO;
import java.io.IOException;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // ===== Validation =====
        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {

            response.sendRedirect("Login_Form.jsp?error=missing");
            return;
        }

        try {

            // ===== Use DAO instead of DB code =====
            UserDAO dao = new UserDAO();
            ResultSet rs = dao.loginUser(email, password);

            if (rs != null && rs.next()) {

                HttpSession session = request.getSession(true);

                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userRole", rs.getString("role"));
                session.setAttribute("bio", rs.getString("bio"));
                session.setAttribute("location", rs.getString("location"));
                session.setAttribute("profilePhoto", rs.getString("profile_photo"));

                // Disable cache
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                response.sendRedirect("HomeServlet?from=login");

            } else {
                response.sendRedirect("Login_Form.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Login_Form.jsp?error=db");
        }
    }
}