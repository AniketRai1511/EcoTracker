import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/EnergyConsumptionServlet")
public class EnergyConsumptionServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/carbon_tracker?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "15112004";

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
        String[] energyTypes = request.getParameterValues("energyType[]");
        String[] unitsArr = request.getParameterValues("units[]");

        double totalEmission = 0.0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO energy_consumption (user_id, username, routine, energy_type, units, emission) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);

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
            con.close();

        } catch (Exception e) {
            throw new ServletException(e);
        }

        // Message logic
        String message;
        if (totalEmission > 8.0) {
            message = "Your energy emissions are higher than recommended. Consider using energy-efficient appliances and renewable sources.";
        } else {
            message = "Great work! Your energy consumption is within sustainable limits. Keep it up!";
        }

        request.setAttribute("emission", totalEmission);
        request.setAttribute("message", message);
        request.getRequestDispatcher("Energy.jsp").forward(request, response);
    }

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
}
