import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TransportationServlet")
public class TransportationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Disable cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");

        String routine = request.getParameter("routine");
        String[] modes = request.getParameterValues("mode[]");
        String[] distances = request.getParameterValues("distance[]");

        double totalEmission = 0;

        try (Connection con = getConnection()) {

            String sql =
                "INSERT INTO transportation_logs " +
                "(user_id, user_name, routine_type, transport_mode, distance_km, emission_kg) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < modes.length; i++) {
                if (distances[i] == null || distances[i].trim().isEmpty()) continue;

                double distance = Double.parseDouble(distances[i]);
                double factor = getEmissionFactor(modes[i]);
                double emission = distance * factor;

                totalEmission += emission;

                ps.setInt(1, userId);
                ps.setString(2, userName);
                ps.setString(3, routine);
                ps.setString(4, modes[i]);
                ps.setDouble(5, distance);
                ps.setDouble(6, emission);

                ps.addBatch();
            }

            ps.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        }

        double standard = routine.equals("daily") ? 15.0 : 400.0;
        String message =
            totalEmission > standard
            ? "⚠ Your emissions are higher than recommended. Consider public transport, carpooling, or non-motorized travel."
            : "✅ Great job! Your transportation emissions are within the sustainable range.";

        request.setAttribute("emission", Math.round(totalEmission * 100.0) / 100.0);
        request.setAttribute("message", message);

        request.getRequestDispatcher("Transportation.jsp").forward(request, response);
    }

    // =========================
    // Render DB connection
    // =========================
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

    private double getEmissionFactor(String mode) {
        switch (mode) {
            case "Bike / Scooter (Petrol)": return 0.12;
            case "Electric Two-Wheeler": return 0.02;
            case "Car (Petrol)": return 0.21;
            case "Car (Diesel)": return 0.24;
            case "Car (CNG)": return 0.16;
            case "Electric Car": return 0.05;
            case "Auto Rickshaw": return 0.13;
            case "Bus": return 0.08;
            case "Metro / Local Train": return 0.04;
            case "Indian Railways": return 0.03;
            case "Flight (Domestic)": return 0.15;
            default: return 0.1;
        }
    }
}
