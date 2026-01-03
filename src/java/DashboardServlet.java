import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        double transportEmissions = 0;
        double foodEmissions = 0;
        double energyEmissions = 0;

        List<Double> last7DaysData = new ArrayList<>();
        List<String> last7DaysLabels = new ArrayList<>();

        List<Double> last6MonthsData = new ArrayList<>();
        List<String> last6MonthsLabels = new ArrayList<>();

        try (Connection con = getConnection()) {

            /* ================= TRANSPORT ================= */
            transportEmissions = getSingleValue(con,
                "SELECT IFNULL(SUM(emission_kg),0) FROM transportation_logs WHERE user_id=?",
                userId);

            /* ================= FOOD ================= */
            foodEmissions = getSingleValue(con,
                "SELECT IFNULL(SUM(emission_kg),0) FROM food_consumption_logs WHERE user_id=?",
                userId);

            /* ================= ENERGY ================= */
            energyEmissions = getSingleValue(con,
                "SELECT IFNULL(SUM(emission),0) FROM energy_consumption WHERE user_id=?",
                userId);

            /* ================= LAST 7 DAYS ================= */
            String dailySql =
                "SELECT DATE(created_at) d, " +
                "(SUM(t.emission_kg) + " +
                " IFNULL((SELECT SUM(f.emission_kg) FROM food_consumption_logs f WHERE f.user_id=? AND DATE(f.created_at)=d),0) + " +
                " IFNULL((SELECT SUM(e.emission) FROM energy_consumption e WHERE e.user_id=? AND DATE(e.created_at)=d),0)) total " +
                "FROM transportation_logs t " +
                "WHERE t.user_id=? AND created_at >= CURDATE() - INTERVAL 6 DAY " +
                "GROUP BY d ORDER BY d";

            PreparedStatement psDaily = con.prepareStatement(dailySql);
            psDaily.setInt(1, userId);
            psDaily.setInt(2, userId);
            psDaily.setInt(3, userId);

            ResultSet rsDaily = psDaily.executeQuery();
            while (rsDaily.next()) {
                last7DaysLabels.add(rsDaily.getDate("d").toString());
                last7DaysData.add(rsDaily.getDouble("total"));
            }

            /* ================= LAST 6 MONTHS ================= */
            String monthlySql =
                "SELECT DATE_FORMAT(created_at,'%b %Y') m, SUM(total) total FROM ( " +
                " SELECT created_at, emission_kg total FROM transportation_logs WHERE user_id=? " +
                " UNION ALL " +
                " SELECT created_at, emission_kg FROM food_consumption_logs WHERE user_id=? " +
                " UNION ALL " +
                " SELECT created_at, emission FROM energy_consumption WHERE user_id=? " +
                ") x GROUP BY m ORDER BY MIN(created_at) DESC LIMIT 6";

            PreparedStatement psMonth = con.prepareStatement(monthlySql);
            psMonth.setInt(1, userId);
            psMonth.setInt(2, userId);
            psMonth.setInt(3, userId);

            ResultSet rsMonth = psMonth.executeQuery();
            while (rsMonth.next()) {
                last6MonthsLabels.add(rsMonth.getString("m"));
                last6MonthsData.add(rsMonth.getDouble("total"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        double totalEmissions = transportEmissions + foodEmissions + energyEmissions;
        double dailyAvg = totalEmissions / 7.0;
        double monthlyAvg = totalEmissions / 30.0;

        /* ================= JSP ATTRIBUTES ================= */
        request.setAttribute("transportEmissions", transportEmissions);
        request.setAttribute("foodEmissions", foodEmissions);
        request.setAttribute("energyEmissions", energyEmissions);
        request.setAttribute("totalEmissions", totalEmissions);
        request.setAttribute("dailyAvg", dailyAvg);
        request.setAttribute("monthlyAvg", monthlyAvg);

        request.setAttribute("last7DaysData", last7DaysData);
        request.setAttribute("last7DaysLabels", last7DaysLabels);

        request.setAttribute("last6MonthsData", last6MonthsData);
        request.setAttribute("last6MonthsLabels", last6MonthsLabels);

        // 🔒 Cache disable (logout/back button fix)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
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

    private double getSingleValue(Connection con, String sql, int userId) throws SQLException {
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        return rs.next() ? rs.getDouble(1) : 0;
    }
}
