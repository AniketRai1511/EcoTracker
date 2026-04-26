package com.ecotracker.servlet;

import com.ecotracker.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        UserDAO dao = new UserDAO();
        boolean deleted = dao.deleteUserAccount(userId);

        if (deleted) {

            session.invalidate();

            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

            response.sendRedirect("Login_Form.jsp?deleted=true");

        } else {
            response.sendRedirect("settings.jsp?error=delete_failed");
        }
    }
}