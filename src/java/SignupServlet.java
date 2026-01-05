import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

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
                "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'user')";

            PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password); // (hash later)

            ps.executeUpdate();

            // ===== Get inserted user id =====
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {

                HttpSession session = request.getSession(true);
                session.setAttribute("userId", rs.getInt(1));
                session.setAttribute("userName", name);
                session.setAttribute("userEmail", email);
                session.setAttribute("userRole", "user");

                // cache disable
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setDateHeader("Expires", 0);

                response.sendRedirect("Home.jsp");
            } else {
                response.sendRedirect("Signup_Form.jsp?error=failed");
            }

        } catch (SQLIntegrityConstraintViolationException e) {
            // duplicate email
            response.sendRedirect("Signup_Form.jsp?error=exists");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Signup_Form.jsp?error=db");
        }
    }

    // ===== Railway DB Connection =====
    private Connection getConnection() throws Exception {

        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String db   = System.getenv("DB_NAME");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");

        String url =
            "jdbc:mysql://" + host + ":" + port + "/" + db +
            "?useUnicode=true" +
            "&characterEncoding=UTF-8" +
            "&serverTimezone=UTC" +
            "&allowPublicKeyRetrieval=true" +
            "&useSSL=false";

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, pass);
    }
}
