import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ProgressServlet")
public class ProgressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔒 Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        double transport = 0, food = 0, energy = 0;
        int trackingDays = 0;
        int transportCount = 0;

        try (Connection con = getConnection()) {

            transport = getSum(con,
                "SELECT IFNULL(SUM(emission_kg),0) FROM transportation_logs " +
                "WHERE user_id=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())",
                userId);

            food = getSum(con,
                "SELECT IFNULL(SUM(emission_kg),0) FROM food_consumption_logs " +
                "WHERE user_id=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())",
                userId);

            energy = getSum(con,
                "SELECT IFNULL(SUM(emission),0) FROM energy_consumption " +
                "WHERE user_id=? AND MONTH(created_at)=MONTH(CURDATE()) AND YEAR(created_at)=YEAR(CURDATE())",
                userId);

            // ===== Tracking days =====
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT COUNT(DISTINCT DATE(created_at)) FROM transportation_logs WHERE user_id=?");
            ps1.setInt(1, userId);
            ResultSet rs1 = ps1.executeQuery();
            if (rs1.next()) trackingDays = rs1.getInt(1);

            // ===== Transport count =====
            PreparedStatement ps2 = con.prepareStatement(
                "SELECT COUNT(*) FROM transportation_logs WHERE user_id=?");
            ps2.setInt(1, userId);
            ResultSet rs2 = ps2.executeQuery();
            if (rs2.next()) transportCount = rs2.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ===== Calculations =====
        double total = transport + food + energy;
        double monthlyAverage = total / 30.0;
        double weeklyAverage = total / 4.0;

        double transportPct = total == 0 ? 0 : (transport / total) * 100;
        double foodPct = total == 0 ? 0 : (food / total) * 100;
        double energyPct = total == 0 ? 0 : (energy / total) * 100;

        int treesEquivalent = (int) Math.ceil(total / 20);
        double savedMoney = energy * 6.5;
        double reductionPercent = 15.0; // placeholder

        // ===== Milestones =====
        boolean weekComplete = trackingDays >= 7;
        boolean ecoBeginner = reductionPercent >= 10;
        boolean greenCommuter = transportCount >= 10;
        boolean sustainabilityChampion = reductionPercent >= 25;

        // ===== JSP attributes =====
        request.setAttribute("totalEmissions", total);
        request.setAttribute("monthlyAverage", monthlyAverage);
        request.setAttribute("weeklyAverage", weeklyAverage);

        request.setAttribute("transport", transport);
        request.setAttribute("food", food);
        request.setAttribute("energy", energy);

        request.setAttribute("transportPct", transportPct);
        request.setAttribute("foodPct", foodPct);
        request.setAttribute("energyPct", energyPct);

        request.setAttribute("treesEquivalent", treesEquivalent);
        request.setAttribute("savedMoney", savedMoney);
        request.setAttribute("reductionPercent", reductionPercent);

        request.setAttribute("weekComplete", weekComplete);
        request.setAttribute("ecoBeginner", ecoBeginner);
        request.setAttribute("greenCommuter", greenCommuter);
        request.setAttribute("sustainabilityChampion", sustainabilityChampion);

        request.setAttribute("trackingDays", trackingDays);
        request.setAttribute("transportCount", transportCount);

        // ===== Chart.js dummy data =====
        request.setAttribute("dailyLabels",
            "['Mon','Tue','Wed','Thu','Fri','Sat','Sun']");
        request.setAttribute("dailyValues",
            "[" +
                weeklyAverage * 0.9 + "," +
                weeklyAverage * 0.8 + "," +
                weeklyAverage * 1.1 + "," +
                weeklyAverage * 1.0 + "," +
                weeklyAverage * 0.95 + "," +
                weeklyAverage * 1.2 + "," +
                weeklyAverage +
            "]");

        request.getRequestDispatcher("progress.jsp").forward(request, response);
    }

    // 🔗 Render DB connection
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

    private double getSum(Connection con, String sql, int userId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getDouble(1) : 0;
            }
        }
    }
}
