import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.time.temporal.ChronoUnit;


@WebServlet("/StreakServlet")
public class StreakServlet extends HttpServlet {

    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/carbon_tracker?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "15112004";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        Set<LocalDate> loggedDates = new HashSet<>();

        try (Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

            String sql =
                "SELECT created_at FROM (" +
                " SELECT created_at FROM transportation_logs WHERE user_id=? " +
                " UNION " +
                " SELECT created_at FROM food_consumption_logs WHERE user_id=? " +
                " UNION " +
                " SELECT created_at FROM energy_consumption WHERE user_id=? " +
                ") t";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                loggedDates.add(rs.getDate("created_at").toLocalDate());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ======================
        // Streak Calculations
        // ======================
        int totalDays = loggedDates.size();
        int currentStreak = 0;
        int longestStreak = 0;

        LocalDate today = LocalDate.now();
        boolean loggedToday = loggedDates.contains(today);

        // Sort dates
        List<LocalDate> sortedDates = new ArrayList<>(loggedDates);
        Collections.sort(sortedDates);

        int tempStreak = 0;
        LocalDate prev = null;

        for (LocalDate d : sortedDates) {
            if (prev == null || d.equals(prev.plusDays(1))) {
                tempStreak++;
            } else {
                longestStreak = Math.max(longestStreak, tempStreak);
                tempStreak = 1;
            }
            prev = d;
        }
        longestStreak = Math.max(longestStreak, tempStreak);

        // Current streak (count backwards from today)
        LocalDate cursor = today;
        while (loggedDates.contains(cursor)) {
            currentStreak++;
            cursor = cursor.minusDays(1);
        }

        // ======================
        // Send to JSP
        // ======================
        request.setAttribute("currentStreak", currentStreak);
        request.setAttribute("longestStreak", longestStreak);
        request.setAttribute("totalDays", totalDays);
        request.setAttribute("loggedToday", loggedToday);
        
        // ======================
// Calendar (last 35 days)
// ======================
List<Map<String, Object>> calendarDays = new ArrayList<>();

for (int i = 34; i >= 0; i--) {
    LocalDate date = LocalDate.now().minusDays(i);
    Map<String, Object> day = new HashMap<>();

    day.put("day", date.getDayOfMonth());
    day.put("logged", loggedDates.contains(date));
    day.put("today", date.equals(LocalDate.now()));

    calendarDays.add(day);
}

// ======================
// Achievements
// ======================
Map<String, Boolean> achievements = new LinkedHashMap<>();
achievements.put("Week Warrior", currentStreak >= 7);
achievements.put("Fortnight Fighter", currentStreak >= 14);
achievements.put("Monthly Master", currentStreak >= 30);
achievements.put("Century Champion", currentStreak >= 100);
achievements.put("Year Legend", currentStreak >= 365);


request.setAttribute("calendarDays", calendarDays);
request.setAttribute("achievements", achievements);


        request.getRequestDispatcher("streak.jsp").forward(request, response);
    }
}
