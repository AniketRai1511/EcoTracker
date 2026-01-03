import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {
    "/dashboard.jsp",
    "/progress.jsp",
    "/streak.jsp",
    "/settings.jsp",
    "/Transportation.jsp",
    "/Food.jsp",
    "/Energy.jsp",
    "/DashboardServlet",
    "/ProgressServlet",
    "/StreakServlet"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no initialization needed
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // 🔒 Disable browser cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // cleanup not required
    }
}
