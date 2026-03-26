package com.ecotracker.servlet;

import com.ecotracker.dao.EnergyDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/EnergyConsumptionServlet")
public class EnergyConsumptionServlet extends HttpServlet {

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
        String[] types = request.getParameterValues("energyType[]");
        String[] units = request.getParameterValues("units[]");

        EnergyDAO dao = new EnergyDAO();
        double totalEmission = dao.saveBatch(userId, userName, routine, types, units);

        String message = totalEmission > 8
                ? "⚠ High energy usage. Try efficient appliances."
                : "✅ Energy usage is sustainable.";

        request.setAttribute("emission", totalEmission);
        request.setAttribute("message", message);

        request.getRequestDispatcher("Energy.jsp").forward(request, response);
    }
}