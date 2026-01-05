import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/plain");
        PrintWriter out = resp.getWriter();

        try (Connection con = getConnection()) {
            out.println("DB CONNECTION SUCCESS");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("DB CONNECTION FAILED");
        }
    }

    private Connection getConnection() throws Exception {

        String host = System.getenv("DB_HOST");
        String port = System.getenv("DB_PORT");
        String db   = System.getenv("DB_NAME");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASSWORD");

        String url =
            "jdbc:mysql://" + host + ":" + port + "/" + db +
            "?useUnicode=true" +
            "&characterEncoding=UTF-8" +
            "&serverTimezone=UTC" +
            "&allowPublicKeyRetrieval=true" +
            "&useSSL=false";

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, user, pass);
    }
}
