import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 🔒 Disable cache (very important)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Session optional (home is public)
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("userId") != null) {
            // logged in user → name already in session
            request.setAttribute("loggedIn", true);
        } else {
            request.setAttribute("loggedIn", false);
        }

        request.getRequestDispatcher("Home.jsp").forward(request, response);
    }
}
