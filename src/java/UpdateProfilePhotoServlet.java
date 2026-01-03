import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UpdateProfilePhotoServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class UpdateProfilePhotoServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/profile";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // disable cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("Login_Form.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        Part filePart = request.getPart("profilePhoto");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("errorMessage", "Please select an image");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
            return;
        }

        // ===== file name =====
        String original = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String ext = original.substring(original.lastIndexOf("."));
        String newFileName = "user_" + userId + ext;

        // ===== upload path =====
        String uploadPath = getServletContext().getRealPath("/") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // ===== save file (ONLY ONCE) =====
        filePart.write(uploadPath + File.separator + newFileName);

        String dbPath = UPLOAD_DIR + "/" + newFileName;

        // ===== DB update =====
        try (Connection con = getConnection()) {

            String sql = "UPDATE users SET profile_photo=? WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, dbPath);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            // update session
            session.setAttribute("profilePhoto", dbPath);

            request.setAttribute("successMessage", "Profile photo updated successfully");
            request.getRequestDispatcher("settings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Photo upload failed");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
    }

    // ==========================
    // Render DB connection
    // ==========================
    private Connection getConnection() throws Exception {
        String url = "jdbc:mysql://" +
                System.getenv("DB_HOST") + ":" +
                System.getenv("DB_PORT") + "/" +
                System.getenv("DB_NAME") +
                "?useSSL=false&serverTimezone=UTC";

        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                url,
                System.getenv("DB_USER"),
                System.getenv("DB_PASSWORD")
        );
    }
}
