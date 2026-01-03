import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DownloadDataServlet")
public class DownloadDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // 🔒 Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        response.setContentType("text/csv");
        response.setHeader(
                "Content-Disposition",
                "attachment; filename=\"user_data.csv\""
        );

        try (
            Connection con = getConnection();
            PrintWriter out = response.getWriter()
        ) {

            /* ================= USER PROFILE ================= */
            out.println("USER PROFILE");
            out.println("Name,Email,Bio,Location");

            PreparedStatement ps = con.prepareStatement(
                "SELECT name,email,bio,location FROM users WHERE id=?"
            );
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                out.printf("\"%s\",\"%s\",\"%s\",\"%s\"%n",
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("bio"),
                        rs.getString("location"));
            }

            /* ================= TRANSPORT ================= */
            out.println();
            out.println("TRANSPORTATION LOGS");
            out.println("Mode,Distance,Emission,Date");

            dumpTable(out, con,
                "SELECT transport_mode,distance,emission_kg,created_at " +
                "FROM transportation_logs WHERE user_id=?",
                userId);

            /* ================= FOOD ================= */
            out.println();
            out.println("FOOD CONSUMPTION LOGS");
            out.println("Food Type,Quantity,Emission,Date");

            dumpTable(out, con,
                "SELECT food_type,quantity,emission_kg,created_at " +
                "FROM food_consumption_logs WHERE user_id=?",
                userId);

            /* ================= ENERGY ================= */
            out.println();
            out.println("ENERGY CONSUMPTION LOGS");
            out.println("Source,Units,Emission,Date");

            dumpTable(out, con,
                "SELECT energy_source,units,emission,created_at " +
                "FROM energy_consumption WHERE user_id=?",
                userId);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* ================= HELPER METHOD ================= */
    private void dumpTable(PrintWriter out, Connection con, String sql, int userId)
            throws SQLException {

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();
        ResultSetMetaData md = rs.getMetaData();

        while (rs.next()) {
            for (int i = 1; i <= md.getColumnCount(); i++) {
                out.print("\"" + rs.getString(i) + "\"");
                if (i < md.getColumnCount()) out.print(",");
            }
            out.println();
        }
    }

    /* ================= DB CONNECTION (Render ready) ================= */
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
