import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/carbon_tracker?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "15112004"; // change if needed

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validation
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
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Insert user (role defaults to 'user')
            String insertSql =
                "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')";
            PreparedStatement psInsert = con.prepareStatement(insertSql);
            psInsert.setString(1, name);
            psInsert.setString(2, email);
            psInsert.setString(3, password);
            psInsert.executeUpdate();

            // Fetch user
            String selectSql =
                "SELECT id, name, email, role FROM users WHERE email = ?";
            PreparedStatement psSelect = con.prepareStatement(selectSql);
            psSelect.setString(1, email);
            ResultSet rs = psSelect.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userRole", rs.getString("role"));
                
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                // ✅ Redirect to HomeServlet after signup
                response.sendRedirect("HomeServlet?from=signup");
            } else {
                response.sendRedirect("Signup_Form.jsp?error=failed");
            }

            rs.close();
            psSelect.close();
            psInsert.close();
            con.close();

        } catch (SQLIntegrityConstraintViolationException e) {
            // Duplicate email
            response.sendRedirect("Signup_Form.jsp?error=exists");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Signup_Form.jsp?error=db");
        }
    }
}