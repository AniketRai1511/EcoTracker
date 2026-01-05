import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

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

        try (Connection con = getConnection()) {

            // ===== Insert user =====
String insertSql =
 "INSERT INTO users (name, email, password, role, bio, location, profile_photo, created_at) " +
 "VALUES (?, ?, ?, 'user', '', '', NULL, NOW())";

            PreparedStatement psInsert = con.prepareStatement(insertSql);
            psInsert.setString(1, name);
            psInsert.setString(2, email);
            psInsert.setString(3, password);
            psInsert.executeUpdate();

            // ===== Fetch inserted user =====
            String selectSql =
                "SELECT id, name, email, role FROM users WHERE email=?";
            PreparedStatement psSelect = con.prepareStatement(selectSql);
            psSelect.setString(1, email);
            ResultSet rs = psSelect.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession(true);

                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userRole", rs.getString("role"));

                // cache disable (important for back button issue)
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                response.sendRedirect("HomeServlet?from=signup");
            } else {
                response.sendRedirect("Signup_Form.jsp?error=failed");
            }

            rs.close();
            psSelect.close();
            psInsert.close();

        } catch (SQLIntegrityConstraintViolationException e) {
            // duplicate email
            response.sendRedirect("Signup_Form.jsp?error=exists");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DB_HOST=" + System.getenv("DB_HOST"));
            response.sendRedirect("Signup_Form.jsp?error=db");
        }
    }

    // ===== Render DB Connection =====
    private Connection getConnection() throws Exception {

        String url =
    "jdbc:mysql://" +
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
