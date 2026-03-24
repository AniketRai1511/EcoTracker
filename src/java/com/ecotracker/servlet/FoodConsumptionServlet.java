package com.ecotracker.servlet;

import com.ecotracker.dao.FoodDAO;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/FoodConsumptionServlet")
public class FoodConsumptionServlet extends HttpServlet {

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

        FoodDAO dao = new FoodDAO();
        double totalEmission = dao.saveBatch(userId, userName, routine, foods, quantities);

        String message = totalEmission > 7
                ? "⚠ High food emissions. Reduce meat consumption."
                : "✅ Good job! Sustainable eating.";

        request.setAttribute("emission", totalEmission);
        request.setAttribute("message", message);

        request.getRequestDispatcher("Food.jsp").forward(request, response);
    }
}