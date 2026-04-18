package com.ecotracker.servlet;

import com.ecotracker.dao.DashboardDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {

            DashboardDAO dao = new DashboardDAO();

            double transport = dao.getTransportEmission(userId);
            double food = dao.getFoodEmission(userId);
            double energy = dao.getEnergyEmission(userId);

            double total = transport + food + energy;

            Map<String, List<?>> chart = dao.getLast7DaysData(userId);

            request.setAttribute("transportEmissions", transport);
            request.setAttribute("foodEmissions", food);
            request.setAttribute("energyEmissions", energy);
            request.setAttribute("totalEmissions", total);

            request.setAttribute("dailyAvg", total / 7.0);
            request.setAttribute("monthlyAvg", total / 30.0);

            request.setAttribute("last7DaysLabels", chart.get("labels"));
            request.setAttribute("last7DaysData", chart.get("data"));

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}