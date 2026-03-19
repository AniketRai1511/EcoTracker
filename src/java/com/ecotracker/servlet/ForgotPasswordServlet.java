package com.ecotracker.servlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");


        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");


        if (email == null || newPassword == null || confirmPassword == null ||
            email.trim().isEmpty() ||
            newPassword.trim().isEmpty() ||
            confirmPassword.trim().isEmpty()) {

            response.sendRedirect("Forgot_Password_Form.jsp?error=missing");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("Forgot_Password_Form.jsp?error=nomatch");
            return;
        }

        try (Connection con = getConnection()) {

            String checkSql = "SELECT id FROM users WHERE email=?";
            try (PreparedStatement psCheck = con.prepareStatement(checkSql)) {

                psCheck.setString(1, email);
                ResultSet rs = psCheck.executeQuery();

                if (!rs.next()) {
                    response.sendRedirect("Forgot_Password_Form.jsp?error=notfound");
                    return;
                }
            }

            String updateSql = "UPDATE users SET password=? WHERE email=?";
            try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {

                psUpdate.setString(1, newPassword);
                psUpdate.setString(2, email);
                psUpdate.executeUpdate();
            }

            response.sendRedirect("Login_Form.jsp?reset=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Forgot_Password_Form.jsp?error=db");
        }
    }

    private Connection getConnection() throws Exception {

        String url = "jdbc:mysql://" +
                System.getenv("DB_HOST") + ":" +
                System.getenv("DB_PORT") + "/" +
                System.getenv("DB_NAME") +
                "?useSSL=false&serverTimezone=UTC";

        Class.forName("com.mysql.cj.jdbc.Driver");

        return DriverManager.getConnection(
                url,
                System.getenv("DB_USER"),
                System.getenv("DB_PASSWORD")
        );
    }
}
