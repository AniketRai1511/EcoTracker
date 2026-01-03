import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/FoodConsumptionServlet")
public class FoodConsumptionServlet extends HttpServlet {

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
        String[] foods = request.getParameterValues("foodType[]");
        String[] quantities = request.getParameterValues("quantity[]");

        double totalEmission = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO food_consumption_logs(user_id, user_name, routine_type, food_type, quantity, emission_kg)VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            for (int i = 0; i < foods.length; i++) {
                double qty = Double.parseDouble(quantities[i]);
                double factor = getFoodEmissionFactor(foods[i]);
                double emission = qty * factor;

                totalEmission += emission;

                ps.setInt(1, userId);
                ps.setString(2, userName);
                ps.setString(3, routine);
                ps.setString(4, foods[i]);
                ps.setDouble(5, qty);
                ps.setDouble(6, emission);
                ps.addBatch();
            }

            ps.executeBatch();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        double standard = routine.equals("daily") ? 7.0 : 200.0;
        String message = totalEmission > standard
                ? "⚠ High food emissions. Reduce meat, dairy, and food waste."
                : "✅ Great job! Your food emissions are within a sustainable range.";

        request.setAttribute("emission", Math.round(totalEmission * 100.0) / 100.0);
        request.setAttribute("message", message);
        request.getRequestDispatcher("Food.jsp").forward(request, response);
    }

    private double getFoodEmissionFactor(String food) {
        switch (food) {
            case "Rice / Wheat (Staples)": return 1.2;
            case "Vegetables": return 0.4;
            case "Fruits": return 0.5;
            case "Milk / Curd": return 1.9;
            case "Paneer / Cheese": return 5.9;
            case "Eggs": return 4.5;
            case "Chicken": return 6.9;
            case "Mutton / Goat Meat": return 20.0;
            case "Fish": return 5.0;
            case "Processed / Packaged Food": return 3.5;
            case "Restaurant / Fast Food": return 4.0;
            default: return 1.0;
        }
    }
}
