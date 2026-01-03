import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.sql.*;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/carbon_tracker?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "15112004"; // change if needed

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Basic validation
        if (email == null || newPassword == null || confirmPassword == null ||
            email.trim().isEmpty() || newPassword.trim().isEmpty() ||
            confirmPassword.trim().isEmpty()) {

            response.sendRedirect("Forgot_Password_Form.jsp?error=missing");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect("Forgot_Password_Form.jsp?error=nomatch");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Check if email exists
            String checkSql = "SELECT id FROM users WHERE email = ?";
            PreparedStatement psCheck = con.prepareStatement(checkSql);
            psCheck.setString(1, email);
            ResultSet rs = psCheck.executeQuery();

            if (!rs.next()) {
                // Email not found
                response.sendRedirect("Forgot_Password_Form.jsp?error=notfound");
                rs.close();
                psCheck.close();
                con.close();
                return;
            }

            // Update password
            String updateSql = "UPDATE users SET password = ? WHERE email = ?";
            PreparedStatement psUpdate = con.prepareStatement(updateSql);
            psUpdate.setString(1, newPassword);
            psUpdate.setString(2, email);
            psUpdate.executeUpdate();

            rs.close();
            psCheck.close();
            psUpdate.close();
            con.close();

            // Redirect to login after successful reset
            response.sendRedirect("Login_Form.jsp?reset=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Forgot_Password_Form.jsp?error=db");
        }
    }
}
