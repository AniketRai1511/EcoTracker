import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TransportationServlet")
public class TransportationServlet extends HttpServlet {

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/carbon_tracker?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "15112004"; // change

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String insertSql = "INSERT INTO transportation_logs(user_id, user_name, routine_type, transport_mode, distance_km, emission_kg)VALUES (?, ?, ?, ?, ?, ?) ";

            PreparedStatement ps = con.prepareStatement(insertSql);

            for (int i = 0; i < modes.length; i++) {
                if (distances[i] == null || distances[i].isEmpty()) continue;

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
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        String message;
        double standard = routine.equals("daily") ? 15.0 : 400.0;

        if (totalEmission > standard) {
            message = "⚠ Your emissions are higher than recommended. Consider public transport, carpooling, or non-motorized travel.";
        } else {
            message = "✅ Great job! Your transportation emissions are within the sustainable range.";
        }

        request.setAttribute("emission", Math.round(totalEmission * 100.0) / 100.0);
        request.setAttribute("message", message);

        request.getRequestDispatcher("Transportation.jsp").forward(request, response);
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
