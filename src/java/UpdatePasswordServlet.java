import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/carbon_tracker?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "15112004";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        if (currentPassword == null || newPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty()) {

            request.setAttribute("errorMessage", "All password fields are required");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                // 1️⃣ Verify current password
                String checkSql = "SELECT password FROM users WHERE id = ?";
                try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
                    checkPs.setInt(1, userId);
                    try (ResultSet rs = checkPs.executeQuery()) {

                        if (!rs.next() || !rs.getString("password").equals(currentPassword)) {
                            request.setAttribute("errorMessage", "Current password is incorrect");
                            request.getRequestDispatcher("settings.jsp").forward(request, response);
                            return;
                        }
                    }
                }

                // 2️⃣ Update password
                String updateSql = "UPDATE users SET password = ? WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setString(1, newPassword);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }

                request.setAttribute("successMessage", "Password updated successfully");
                request.getRequestDispatcher("settings.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Password update failed");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
    }
}
