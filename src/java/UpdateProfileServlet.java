import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

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

        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");
        String bio = request.getParameter("bio");
        String location = request.getParameter("location");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

                String sql =
                    "UPDATE users SET name=?, email=?, bio=?, location=? WHERE id=?";

                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, bio);
                ps.setString(4, location);
                ps.setInt(5, userId);
                ps.executeUpdate();

                // ✅ UPDATE SESSION VALUES (THIS IS THE FIX)
                session.setAttribute("userName", name);
                session.setAttribute("userEmail", email);
                session.setAttribute("bio", bio);
                session.setAttribute("location", location);

                request.setAttribute("successMessage", "Profile updated successfully");
                request.getRequestDispatcher("settings.jsp").forward(request, response);
            }

        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("errorMessage", "Email already exists");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Profile update failed");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
    }
}
