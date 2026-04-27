package com.ecotracker.servlet;

import com.ecotracker.dao.DownloadDAO;
import com.ecotracker.util.DBConnection;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import java.util.Map;

@WebServlet("/DownloadDataServlet")
public class DownloadDataServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=user_data.csv");

        try (
            Connection con = DBConnection.getConnection();
            PrintWriter out = response.getWriter()
        ) {

            DownloadDAO dao = new DownloadDAO();

            // ===== USER =====
            Map<String, String> user = dao.getUserProfile(userId);

            out.println("USER PROFILE");
            out.println("Name,Email,Bio,Location");

            if (user != null) {
                out.println(format(user.get("name")) + "," +
                            format(user.get("email")) + "," +
                            format(user.get("bio")) + "," +
                            format(user.get("location")));
            }

            // ===== TRANSPORT =====
            out.println("\nTRANSPORTATION LOGS");
            out.println("Mode,Distance,Emission,Date");

            printResultSet(out, dao.getTransportData(con, userId));

            // ===== FOOD =====
            out.println("\nFOOD CONSUMPTION LOGS");
            out.println("Food,Quantity,Emission,Date");

            printResultSet(out, dao.getFoodData(con, userId));

            // ===== ENERGY =====
            out.println("\nENERGY CONSUMPTION LOGS");
            out.println("Type,Units,Emission,Date");

            printResultSet(out, dao.getEnergyData(con, userId));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== COMMON CSV PRINTER =====
    private void printResultSet(PrintWriter out, ResultSet rs) throws Exception {

        ResultSetMetaData md = rs.getMetaData();

        while (rs.next()) {
            for (int i = 1; i <= md.getColumnCount(); i++) {
                out.print(format(rs.getString(i)));
                if (i < md.getColumnCount()) out.print(",");
            }
            out.println();
        }
    }

    // ===== SAFE CSV FORMAT =====
    private String format(String value) {
        if (value == null) return "\"\"";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
}