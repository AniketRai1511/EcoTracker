package com.ecotracker.servlet;

import com.ecotracker.dao.ProgressDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ProgressServlet")
public class ProgressServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {

            ProgressDAO dao = new ProgressDAO();

            double transport = dao.getTransport(userId);
            double food = dao.getFood(userId);
            double energy = dao.getEnergy(userId);

            int trackingDays = dao.getTrackingDays(userId);
            int transportCount = dao.getTransportCount(userId);

            double total = transport + food + energy;

            double monthlyAvg = total / 30.0;
            double weeklyAvg = total / 4.0;

            double transportPct = total == 0 ? 0 : (transport / total) * 100;
            double foodPct = total == 0 ? 0 : (food / total) * 100;
            double energyPct = total == 0 ? 0 : (energy / total) * 100;

            int trees = (int) Math.ceil(total / 20);
            double savedMoney = energy * 6.5;
            double reductionPercent = 15.0;

            request.setAttribute("totalEmissions", total);
            request.setAttribute("monthlyAverage", monthlyAvg);
            request.setAttribute("weeklyAverage", weeklyAvg);

            request.setAttribute("transport", transport);
            request.setAttribute("food", food);
            request.setAttribute("energy", energy);

            request.setAttribute("transportPct", transportPct);
            request.setAttribute("foodPct", foodPct);
            request.setAttribute("energyPct", energyPct);

            request.setAttribute("treesEquivalent", trees);
            request.setAttribute("savedMoney", savedMoney);
            request.setAttribute("reductionPercent", reductionPercent);

            request.setAttribute("trackingDays", trackingDays);
            request.setAttribute("transportCount", transportCount);

            request.setAttribute("weekComplete", trackingDays >= 7);
            request.setAttribute("ecoBeginner", reductionPercent >= 10);
            request.setAttribute("greenCommuter", transportCount >= 10);
            request.setAttribute("sustainabilityChampion", reductionPercent >= 25);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("progress.jsp").forward(request, response);
    }
}