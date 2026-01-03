<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("Login_Form.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String bio = (String) session.getAttribute("bio");
    String location = (String) session.getAttribute("location");

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings - EcoTrack</title>
    <style>
        :root {
            --green-600: #16a34a;
            --green-700: #15803d;
            --gray-50: #f9fafb;
            --gray-600: #4b5563;
            --gray-800: #1f2937;
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            margin: 0;
            background-color: var(--gray-50);
            color: var(--gray-800);
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .container {
            max-width: 1280px;
            margin-left: auto;
            margin-right: auto;
            padding-left: 1.5rem;
            padding-right: 1.5rem;
        }

        h1, h2, h3, h4 { font-weight: 700; margin: 0; padding: 0; }
        p { margin: 0; padding: 0; }

        .btn {
            display: inline-block;
            font-weight: 600;
            text-align: center;
            border-radius: 9999px;
            padding: 0.75rem 1.5rem;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }
        .btn:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1);
        }
        .btn-green {
            background-color: var(--green-600);
            color: #fff;
        }
        .btn-green:hover { background-color: var(--green-700); }
        .btn-secondary {
            background-color: #6c757d;
            color: #fff;
        }
        .btn-secondary:hover { background-color: #5a6268; }
        .btn-danger {
            background-color: #dc3545;
            color: #fff;
        }
        .btn-danger:hover { background-color: #c82333; }
        .btn-outline {
            background-color: transparent;
            color: var(--green-600);
            border: 2px solid var(--green-600);
        }
        .btn-outline:hover {
            background-color: var(--green-600);
            color: white;
        }

        /* Header */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 50;
            background-color: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .header .container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 0.75rem;
            padding-bottom: 0.75rem;
        }
        .logo {
            display: flex;
            align-items: center;
            text-decoration: none;
            gap: 0.5rem;
        }
        .logo span {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        .logo svg {
            width: 2rem;
            height: 2rem;
            color: var(--green-600);
        }
        .nav-links a {
            color: var(--gray-600);
            text-decoration: none;
            font-weight: 500;
            margin-left: 2rem;
            transition: color 0.3s ease;
        }
        .nav-links a:hover { color: var(--green-600); }

        .profile-menu-container {
            position: relative;
            display: flex;
            align-items: center;
            margin-left: 1rem;
        }
        .profile-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: transparent;
            border: none;
            padding: 0;
            cursor: pointer;
            font-weight: 500;
            color: var(--gray-800);
        }
        .user-avatar {
            width: 2rem;
            height: 2rem;
            border-radius: 9999px;
            background-color: #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
        }
        .profile-dropdown {
            position: absolute;
            right: 0;
            top: 120%;
            width: 220px;
            background-color: #fff;
            border-radius: 0.75rem;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1);
            padding: 0.5rem 0;
            display: none;
            z-index: 60;
        }
        .profile-dropdown.open { display: block; }
        .profile-dropdown-header {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 0.25rem;
        }
        .profile-name {
            font-weight: 600;
            color: var(--gray-800);
            font-size: 0.95rem;
        }
        .profile-meta {
            font-size: 0.75rem;
            color: var(--gray-600);
        }
        .profile-item {
            display: flex;
            align-items: center;
            padding: 0.6rem 1rem;
            font-size: 0.9rem;
            text-decoration: none;
            color: var(--gray-800);
            transition: background-color 0.2s ease;
        }
        .profile-item:hover { background-color: #f3f4f6; }
        .profile-item-danger {
            color: #b91c1c;
        }
        .profile-item-danger:hover { background-color: #fee2e2; }
        .profile-separator {
            height: 1px;
            background-color: #e5e7eb;
            margin: 0.25rem 0;
        }

        /* Main Content */
        .main-content {
            padding-top: 6rem;
            padding-bottom: 4rem;
        }

        .page-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        .page-header h1 {
            font-size: 2.5rem;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }
        .page-header p {
            font-size: 1.125rem;
            color: var(--gray-600);
            max-width: 48rem;
            margin: 0 auto;
        }

        .settings-container {
            max-width: 900px;
            margin: 0 auto;
        }

        .card {
            background: white;
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .card h2 {
            color: var(--green-600);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            border-bottom: 2px solid var(--green-600);
            padding-bottom: 0.75rem;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .alert-success {
            background-color: #d1fae5;
            border: 1px solid var(--green-600);
            color: var(--green-700);
        }
        .alert-error {
            background-color: #fee2e2;
            border: 1px solid #dc3545;
            color: #b91c1c;
        }

        .profile-photo-section {
            display: flex;
            align-items: center;
            gap: 2rem;
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid #e5e7eb;
        }
        .profile-photo {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--green-600), var(--green-700));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .profile-photo-info {
            flex: 1;
        }
        .profile-photo-info h3 {
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }
        .profile-photo-info p {
            color: var(--gray-600);
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }
        label {
            display: block;
            color: var(--gray-800);
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 1rem;
        }
        .label-description {
            font-weight: 400;
            font-size: 0.875rem;
            color: var(--gray-600);
            margin-top: 0.25rem;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="file"],
        select,
        textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="password"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: var(--green-600);
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 24px;
        }
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.4s;
            border-radius: 24px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.4s;
            border-radius: 50%;
        }
        input:checked + .slider {
            background-color: var(--green-600);
        }
        input:checked + .slider:before {
            transform: translateX(26px);
        }

        .preference-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .preference-item:last-child {
            border-bottom: none;
        }
        .preference-info h4 {
            color: var(--gray-800);
            font-size: 1rem;
            margin-bottom: 0.25rem;
        }
        .preference-info p {
            color: var(--gray-600);
            font-size: 0.875rem;
        }

        .danger-zone {
            border: 2px solid #fee2e2;
            background-color: #fef2f2;
            padding: 1.5rem;
            border-radius: 0.75rem;
        }
        .danger-zone h3 {
            color: #b91c1c;
            margin-bottom: 0.5rem;
        }
        .danger-zone p {
            color: var(--gray-600);
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        /* Footer */
        .footer {
            background-color: var(--gray-800);
            color: #d1d5db;
            padding-top: 3rem;
            padding-bottom: 3rem;
            margin-top: 4rem;
        }
        .footer-grid { display: grid; gap: 2rem; }
        .footer .logo-column { grid-column: 1 / -1; }
        .footer .logo-column .logo span { color: #fff; }
        .footer .logo-column p {
            color: #9ca3af;
            max-width: 28rem;
            margin-top: 1rem;
            line-height: 1.6;
        }
        .footer h4 {
            font-weight: 600;
            color: #fff;
            margin-bottom: 1rem;
        }
        .footer ul { list-style: none; padding: 0; margin: 0; }
        .footer li { margin-bottom: 0.5rem; }
        .footer a {
            color: inherit;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        .footer a:hover { color: #4ade80; }
        .footer-bottom {
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #374151;
            text-align: center;
            color: #6b7280;
            font-size: 0.875rem;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .profile-photo-section {
                flex-direction: column;
                text-align: center;
            }
        }

        @media (min-width: 768px) {
            .footer-grid {
                grid-template-columns: repeat(4, 1fr);
            }
            .footer .logo-column {
                grid-column: span 2;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <a href="HomeServlet" class="logo">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="0.5">
                    <path d="M17 8C8 10 5.5 17.5 9.5 22C15.5 18 18.5 11.5 17 8Z" />
                    <path d="M15 2C13.3 4.8 11.2 7.3 9 9" />
                </svg>
                <span>EcoTrack</span>
            </a>
            <nav class="nav-links">
                <a href="Transportation.jsp">Transportation</a>
                <a href="Food.jsp">Food</a>
                <a href="Energy.jsp">Energy</a>
            </nav>

            <div class="profile-menu-container">
                <button class="profile-btn" type="button" id="profileBtn">
                    <span><%= userName %></span>
                    <div class="user-avatar">
<%
    String headerPhoto = (String) session.getAttribute("profilePhoto");
    if (headerPhoto != null) {
%>
    <img src="<%= headerPhoto %>"
         style="width:100%;height:100%;border-radius:50%;object-fit:cover;">
<%
    } else {
%>
    👤
<%
    }
%>
</div>

                </button>

                <div class="profile-dropdown" id="profileDropdown">
                    <div class="profile-dropdown-header">
                        <div class="profile-name"><%= userName %></div>
                        <div class="profile-meta">EcoTrack user</div>
                    </div>
                    <a href="DashboardServlet" class="profile-item">Dashboard</a>
                    <a href="ProgressServlet" class="profile-item">Progress</a>
                    <a href="StreakServlet" class="profile-item">Streak</a>
                    <a href="settings.jsp" class="profile-item">Settings</a>
                    <div class="profile-separator"></div>
                    <a href="LogoutServlet" class="profile-item profile-item-danger">Log out</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="page-header">
                <h1>⚙️ Account Settings</h1>
                <p>Manage your profile, preferences, and account security</p>
            </div>

            <div class="settings-container">
                <!-- Success/Error Messages -->
                <% if (successMessage != null) { %>
                    <div class="alert alert-success">
                        ✓ <%= successMessage %>
                    </div>
                <% } %>
                <% if (errorMessage != null) { %>
                    <div class="alert alert-error">
                        ✗ <%= errorMessage %>
                    </div>
                <% } %>

                <!-- Profile Information -->
                <div class="card">
                    <h2>👤 Profile Information</h2>
                    
                    <div class="profile-photo-section">
<div class="profile-photo">
<%
    String profilePhoto = (String) session.getAttribute("profilePhoto");
    if (profilePhoto != null) {
%>
    <img src="<%= profilePhoto %>" style="width:100%;height:100%;border-radius:50%;object-fit:cover;">
<%
    } else {
%>
    <%= userName.substring(0,1).toUpperCase() %>
<%
    }
%>
</div>

                        <div class="profile-photo-info">
                            <h3>Profile Photo</h3>
                            <p>Upload a new profile picture or use your initials</p>
                            <form action="UpdateProfilePhotoServlet" method="post" enctype="multipart/form-data">
                                <input type="file" name="profilePhoto" accept="image/*" style="margin-bottom: 0.5rem;">
                                <button type="submit" class="btn btn-outline">Upload Photo</button>
                            </form>
                        </div>
                    </div>

  <form action="UpdateProfileServlet" method="post">
    <div class="form-grid">
        <div class="form-group">
            <label for="userName">Full Name</label>
            <input type="text"
                   id="userName"
                   name="userName"
                   value="<%= userName %>"
                   required>
        </div>

        <div class="form-group">
            <label for="userEmail">Email Address</label>
            <input type="email"
                   id="userEmail"
                   name="userEmail"
                   value="<%= userEmail != null ? userEmail : "" %>"
                   required>
        </div>
    </div>

    <div class="form-group">
        <label for="location">Location</label>
        <input type="text"
               id="location"
               name="location"
               value="<%= location != null ? location : "" %>"
               placeholder="e.g., Mumbai, India">
        <p class="label-description">
            Help us provide more accurate local data and recommendations
        </p>
    </div>

    <div class="form-group">
        <label for="bio">Bio</label>
        <textarea id="bio"
                  name="bio"
                  placeholder="Tell us about your sustainability journey..."><%= 
            bio != null ? bio : "" 
        %></textarea>
    </div>

    <button type="submit" class="btn btn-green">
        Save Changes
    </button>
</form>

                </div>

                <!-- Security Settings -->
                <div class="card">
                    <h2>🔒 Security</h2>
                    
                    <form action="UpdatePasswordServlet" method="post">
                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" minlength="8" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" minlength="8" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-green">Update Password</button>
                    </form>
                </div>

                <!-- Data & Privacy -->
                <div class="card">
                    <h2>📊 Data & Privacy</h2>
                    
                    <div class="preference-item">
                        <div class="preference-info">
                            <h4>Download Your Data</h4>
                            <p>Get a copy of all your carbon tracking data</p>
                        </div>
                        <a href="DownloadDataServlet" class="btn btn-outline">Download</a>
                    </div>

                <!-- Danger Zone -->
                <div class="card">
                    <h2>⚠️ Danger Zone</h2>
                    
                    <div class="danger-zone">
                        <h3>Delete Account</h3>
                        <p>
                            Once you delete your account, there is no going back. All your data, 
                            including carbon tracking history, achievements, and preferences will be 
                            permanently deleted.
                        </p>
                        <button type="button" class="btn btn-danger" onclick="confirmDelete()">
                            Delete My Account
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="logo-column">
                    <a href="HomeServlet" class="logo">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="0.5">
                            <path d="M17 8C8 10 5.5 17.5 9.5 22C15.5 18 18.5 11.5 17 8Z" />
                            <path d="M15 2C13.3 4.8 11.2 7.3 9 9" />
                        </svg>
                        <span>EcoTrack</span>
                    </a>
                    <p>Making sustainability accessible for everyone through easy-to-use tools that empower conscious choices.</p>
                </div>
                <div>
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="Transportation.jsp">Transportation</a></li>
                        <li><a href="Food.jsp">Food</a></li>
                        <li><a href="Energy.jsp">Energy</a></li>
                    </ul>
                </div>
                <div>
                    <h4>Resources</h4>
                    <ul>
                        <li><a href="DashboardServlet">Dashboard</a></li>
                        <li><a href="ProgressServlet">Progress</a></li>
                        <li><a href="StreakServlet">Streak</a></li>
                    </ul>
                </div>
                <div>
                    <h4>Legal</h4>
                    <ul>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                &copy; 2025 EcoTrack. All Rights Reserved.
            </div>
        </div>
    </footer>

    <script>
        // Profile dropdown
        const profileBtn = document.getElementById('profileBtn');
        const profileDropdown = document.getElementById('profileDropdown');

        if (profileBtn && profileDropdown) {
            profileBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                profileDropdown.classList.toggle('open');
            });

            document.addEventListener('click', function () {
                profileDropdown.classList.remove('open');
            });

            profileDropdown.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        }

        // Password confirmation
        const passwordForm = document.querySelector('form[action="UpdatePasswordServlet"]');
        if (passwordForm) {
            passwordForm.addEventListener('submit', function(e) {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
                
                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('New passwords do not match!');
                }
            });
        }

        // Delete account confirmation
        function confirmDelete() {
            const confirmation = confirm(
                'Are you sure you want to delete your account?\n\n' +
                'This action cannot be undone and all your data will be permanently deleted.'
            );
            
            if (confirmation) {
                const doubleCheck = prompt(
                    'Type "DELETE" to confirm account deletion:'
                );
                
                if (doubleCheck === 'DELETE') {
                    window.location.href = 'DeleteAccountServlet';
                } else {
                    alert('Account deletion cancelled.');
                }
            }
        }

        // Profile photo preview
        const photoInput = document.querySelector('input[type="file"]');
        if (photoInput) {
            photoInput.addEventListener('change', function(e) {
                const file = e.target.files[0];
                if (file) {
                    if (file.size > 5 * 1024 * 1024) {
                        alert('File size must be less than 5MB');
                        e.target.value = '';
                    }
                }
            });
        }
    </script>
</body>
</html>