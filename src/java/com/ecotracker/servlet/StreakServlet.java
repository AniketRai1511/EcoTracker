package com.ecotracker.servlet;

import com.ecotracker.dao.StreakDAO;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/StreakServlet")
public class StreakServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cache control
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // ===== DAO call =====
        StreakDAO dao = new StreakDAO();
        Set<LocalDate> loggedDates = dao.getUserLoggedDates(userId);

        // ===== Logic =====
        int totalDays = loggedDates.size();
        int currentStreak = 0;
        int longestStreak = 0;

        LocalDate today = LocalDate.now();
        boolean loggedToday = loggedDates.contains(today);

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

        // Current streak
        LocalDate cursor = today;
        while (loggedDates.contains(cursor)) {
            currentStreak++;
            cursor = cursor.minusDays(1);
        }

        // Calendar data (last 35 days)
        List<Map<String, Object>> calendarDays = new ArrayList<>();

        for (int i = 34; i >= 0; i--) {
            LocalDate date = today.minusDays(i);

            Map<String, Object> day = new HashMap<>();
            day.put("day", date.getDayOfMonth());
            day.put("logged", loggedDates.contains(date));
            day.put("today", date.equals(today));

            calendarDays.add(day);
        }

        // Achievements
        Map<String, Boolean> achievements = new LinkedHashMap<>();
        achievements.put("Week Warrior", currentStreak >= 7);
        achievements.put("Fortnight Fighter", currentStreak >= 14);
        achievements.put("Monthly Master", currentStreak >= 30);
        achievements.put("Century Champion", currentStreak >= 100);
        achievements.put("Year Legend", currentStreak >= 365);

        // ===== Send to JSP =====
        request.setAttribute("currentStreak", currentStreak);
        request.setAttribute("longestStreak", longestStreak);
        request.setAttribute("totalDays", totalDays);
        request.setAttribute("loggedToday", loggedToday);
        request.setAttribute("calendarDays", calendarDays);
        request.setAttribute("achievements", achievements);

        request.getRequestDispatcher("streak.jsp").forward(request, response);
    }
}