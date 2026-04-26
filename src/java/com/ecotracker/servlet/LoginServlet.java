package com.ecotracker.servlet;

import com.ecotracker.dao.UserDAO;
import com.ecotracker.model.User;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {

            response.sendRedirect("Login_Form.jsp?error=missing");
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, password);

        if (user != null) {

            HttpSession session = request.getSession(true);

            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("bio", user.getBio());
            session.setAttribute("location", user.getLocation());
            session.setAttribute("profilePhoto", user.getProfilePhoto());

            response.sendRedirect("HomeServlet?from=login");

        } else {
            response.sendRedirect("Login_Form.jsp?error=invalid");
        }
    }
}