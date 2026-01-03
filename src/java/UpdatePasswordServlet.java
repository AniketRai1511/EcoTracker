import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Disable cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        if (currentPassword == null || newPassword == null ||
            currentPassword.trim().isEmpty() || newPassword.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All password fields are required");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
            return;
        }

        try (Connection con = getConnection()) {

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

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Password update failed");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
    }

    // =========================
    // Render DB connection
    // =========================
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
