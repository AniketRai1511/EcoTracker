package com.ecotracker.servlet;

import com.ecotracker.dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // ===== Validation =====
        if (name == null || email == null || password == null || confirmPassword == null ||
            name.trim().isEmpty() || email.trim().isEmpty() ||
            password.trim().isEmpty() || confirmPassword.trim().isEmpty()) {

            response.sendRedirect("Signup_Form.jsp?error=missing");
            return;
        }

        if (!password.equals(confirmPassword)) {
            response.sendRedirect("Signup_Form.jsp?error=nomatch");
            return;
        }

        try {

            UserDAO dao = new UserDAO();

            // ===== Check duplicate email =====
            if (dao.emailExists(email)) {
                response.sendRedirect("Signup_Form.jsp?error=exists");
                return;
            }

            // ===== Register user =====
            int userId = dao.registerUser(name, email, password);

            if (userId != -1) {

                HttpSession session = request.getSession(true);

                session.setAttribute("userId", userId);
                session.setAttribute("userName", name);
                session.setAttribute("userEmail", email);
                session.setAttribute("userRole", "user");

                // Disable cache
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                response.sendRedirect("HomeServlet?from=signup");

            } else {
                response.sendRedirect("Signup_Form.jsp?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Signup_Form.jsp?error=db");
        }
    }
}