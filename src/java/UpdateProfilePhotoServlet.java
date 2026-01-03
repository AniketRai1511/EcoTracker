import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/UpdateProfilePhotoServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize = 5 * 1024 * 1024,        // 5MB
    maxRequestSize = 10 * 1024 * 1024     // 10MB
)
public class UpdateProfilePhotoServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/profile";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String extension = fileName.substring(fileName.lastIndexOf("."));

        // Rename file → user_5.jpg
        String newFileName = "user_" + userId + extension;

String uploadPath =
    getServletContext().getRealPath("/") + File.separator + UPLOAD_DIR;

File uploadDir = new File(uploadPath);
if (!uploadDir.exists()) {
    uploadDir.mkdirs();   // 🔥 important
}

filePart.write(uploadPath + File.separator + newFileName);


        // Save file
        filePart.write(uploadPath + File.separator + newFileName);

        // Save path in DB
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/carbon_tracker?useSSL=false&serverTimezone=UTC",
                    "root",
                    "15112004")) {

                String sql = "UPDATE users SET profile_photo=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, UPLOAD_DIR + "/" + newFileName);
                ps.setInt(2, userId);
                ps.executeUpdate();

                session.setAttribute("profilePhoto", UPLOAD_DIR + "/" + newFileName);

                request.setAttribute("successMessage", "Profile photo updated successfully");
                request.getRequestDispatcher("settings.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Photo upload failed");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
        }
    }
}
