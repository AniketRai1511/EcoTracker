import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/EnergyConsumptionServlet")
public class EnergyConsumptionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        // 🔒 Prevent cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        int userId = (int) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");

        String routine = request.getParameter("routine");
        String[] energyTypes = request.getParameterValues("energyType[]");
        String[] unitsArr = request.getParameterValues("units[]");

        double totalEmission = 0.0;

        try (Connection con = getConnection()) {

            String sql =
                "INSERT INTO energy_consumption " +
                "(user_id, username, routine, energy_type, units, emission) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                for (int i = 0; i < energyTypes.length; i++) {

                    double units = Double.parseDouble(unitsArr[i]);
                    double factor = getEmissionFactor(energyTypes[i]);
                    double emission = units * factor;

                    totalEmission += emission;

                    ps.setInt(1, userId);
                    ps.setString(2, userName);
                    ps.setString(3, routine);
                    ps.setString(4, energyTypes[i]);
                    ps.setDouble(5, units);
                    ps.setDouble(6, emission);
                    ps.addBatch();
                }

                ps.executeBatch();
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Energy consumption save failed", e);
        }

        // ================= MESSAGE LOGIC =================
        String message;
        if (totalEmission > 8.0) {
            message =
                "Your energy emissions are higher than recommended. " +
                "Consider using energy-efficient appliances and renewable sources.";
        } else {
            message =
                "Great work! Your energy consumption is within sustainable limits. Keep it up!";
        }

        request.setAttribute("emission", totalEmission);
        request.setAttribute("message", message);
        request.getRequestDispatcher("Energy.jsp").forward(request, response);
    }

    /* ================= EMISSION FACTOR ================= */
    private double getEmissionFactor(String type) {
        switch (type) {
            case "Electricity (Grid)": return 0.82;
            case "LPG (Cooking Gas)": return 2.98;
            case "Diesel Generator": return 2.68;
            case "Petrol Generator": return 2.31;
            case "Solar Power": return 0.05;
            default: return 0.0;
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
