package com.ecotracker.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.ecotracker.dao.UserProfileDAO;

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

        // Disable cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Session check
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

        // Validate file type
        String contentType = filePart.getContentType();
        if (!contentType.startsWith("image/")) {
            request.setAttribute("errorMessage", "Only image files allowed");
            request.getRequestDispatcher("settings.jsp").forward(request, response);
            return;
        }

        // Safe filename handling
        String original = Paths.get(filePart.getSubmittedFileName())
                               .getFileName().toString();

        String ext = "";
        int dotIndex = original.lastIndexOf(".");
        if (dotIndex != -1) {
            ext = original.substring(dotIndex);
        }

        String newFileName = "user_" + userId + ext;

        // Save file
        String uploadPath = getServletContext().getRealPath("/") 
                            + File.separator + UPLOAD_DIR;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        filePart.write(uploadPath + File.separator + newFileName);

        String dbPath = UPLOAD_DIR + "/" + newFileName;

        try {
            UserProfileDAO dao = new UserProfileDAO();

            boolean updated = dao.updateProfilePhoto(userId, dbPath);

            if (updated) {
                session.setAttribute("profilePhoto", dbPath);
                request.setAttribute("successMessage", "Profile photo updated successfully");
            } else {
                request.setAttribute("errorMessage", "Photo update failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Photo upload failed");
        }

        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }
}