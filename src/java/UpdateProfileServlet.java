import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // disable cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");
        String bio = request.getParameter("bio");
        String location = request.getParameter("location");

        try (Connection con = getConnection()) {

            String sql =
                "UPDATE users SET name=?, email=?, bio=?, location=? WHERE id=?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, bio);
                ps.setString(4, location);
                ps.setInt(5, userId);
                ps.executeUpdate();
            }

            // ✅ update session immediately
            session.setAttribute("userName", name);
            session.setAttribute("userEmail", email);
            session.setAttribute("bio", bio);
            session.setAttribute("location", location);

            request.setAttribute("successMessage", "Profile updated successfully");
            request.getRequestDispatcher("settings.jsp").forward(request, response);

        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("errorMessage", "Email already exists");
            request.getRequestDispatcher("settings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Profile update failed");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
    }

    // ==========================
    // Render DB connection
    // ==========================
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
