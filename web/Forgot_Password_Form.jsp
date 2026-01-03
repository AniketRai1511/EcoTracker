<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - EcoTrack</title>
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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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
            width: 100%;
            font-size: 1rem;
            padding: 0.875rem 1.5rem;
        }
        .btn-green:hover { 
            background-color: var(--green-700);
            transform: translateY(-2px);
        }

        /* Header */
        .header {
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

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
        }

        .form-container {
            width: 100%;
            max-width: 480px;
            background: white;
            padding: 3rem;
            border-radius: 1rem;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1);
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-icon {
            width: 5rem;
            height: 5rem;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, var(--green-600), var(--green-700));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
        }

        .form-header h1 {
            font-size: 2rem;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: var(--gray-600);
            font-size: 1rem;
            line-height: 1.5;
        }

        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
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

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            color: var(--gray-800);
            font-weight: 600;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }

        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid #e5e7eb;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.3s;
            background-color: white;
        }

        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: var(--green-600);
            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
        }

        .password-requirements {
            margin-top: 0.5rem;
            padding: 0.75rem;
            background-color: var(--gray-50);
            border-radius: 0.5rem;
            font-size: 0.75rem;
            color: var(--gray-600);
        }

        .password-requirements ul {
            margin: 0.5rem 0 0 1.25rem;
            padding: 0;
        }

        .password-requirements li {
            margin-bottom: 0.25rem;
        }

        .back-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .back-link a {
            color: var(--green-600);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .back-link a:hover {
            color: var(--green-700);
            text-decoration: underline;
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 1.5rem 0;
            color: var(--gray-600);
            font-size: 0.875rem;
        }

        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #e5e7eb;
        }

        .divider span {
            padding: 0 1rem;
        }

        /* Footer */
        .footer {
            background-color: var(--gray-800);
            color: #d1d5db;
            padding: 2rem 0;
        }

        .footer-content {
            text-align: center;
            font-size: 0.875rem;
        }

        .footer-links {
            margin-top: 1rem;
            display: flex;
            justify-content: center;
            gap: 2rem;
        }

        .footer-links a {
            color: #d1d5db;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: #4ade80;
        }

        /* Responsive */
        @media (max-width: 640px) {
            .form-container {
                padding: 2rem 1.5rem;
            }

            .form-header h1 {
                font-size: 1.5rem;
            }

            .form-icon {
                width: 4rem;
                height: 4rem;
                font-size: 2rem;
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
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="form-container">
            <div class="form-header">
                <div class="form-icon">🔒</div>
                <h1>Reset Password</h1>
                <p>Enter your registered email and create a new password to regain access to your account</p>
            </div>

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

            <form action="ForgotPasswordServlet" method="post" id="resetForm">
                <div class="form-group">
                    <label for="email">Registered Email Address</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        placeholder="Enter your email"
                        required 
                    />
                </div>

                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input 
                        type="password" 
                        id="newPassword" 
                        name="newPassword" 
                        placeholder="Create a strong password"
                        minlength="8"
                        required 
                    />
                    <div class="password-requirements">
                        <strong>Password must contain:</strong>
                        <ul>
                            <li>At least 8 characters</li>
                            <li>One uppercase letter (A-Z)</li>
                            <li>One lowercase letter (a-z)</li>
                            <li>One number (0-9)</li>
                        </ul>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        name="confirmPassword" 
                        placeholder="Re-enter your password"
                        minlength="8"
                        required 
                    />
                </div>

                <button type="submit" class="btn btn-green">Reset Password</button>
            </form>

            <div class="divider">
                <span>or</span>
            </div>

            <div class="back-link">
                Remember your password? <a href="Login_Form.jsp">Back to Login</a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <p>&copy; 2025 EcoTrack. All Rights Reserved.</p>
                <div class="footer-links">
                    <a href="#">Privacy Policy</a>
                    <a href="#">Terms of Service</a>
                    <a href="#">Help Center</a>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // Form validation
        const resetForm = document.getElementById('resetForm');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');

        resetForm.addEventListener('submit', function(e) {
            // Check if passwords match
            if (newPassword.value !== confirmPassword.value) {
                e.preventDefault();
                alert('Passwords do not match! Please make sure both passwords are identical.');
                confirmPassword.focus();
                return false;
            }

            // Validate password strength
            const password = newPassword.value;
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumber = /[0-9]/.test(password);
            const hasMinLength = password.length >= 8;

            if (!hasUpperCase || !hasLowerCase || !hasNumber || !hasMinLength) {
                e.preventDefault();
                alert('Password does not meet the requirements. Please ensure it contains:\n' +
                      '- At least 8 characters\n' +
                      '- One uppercase letter\n' +
                      '- One lowercase letter\n' +
                      '- One number');
                newPassword.focus();
                return false;
            }
        });

        // Real-time password match indicator
        confirmPassword.addEventListener('input', function() {
            if (this.value === newPassword.value && this.value !== '') {
                this.style.borderColor = 'var(--green-600)';
            } else if (this.value !== '') {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#e5e7eb';
            }
        });

        // Password strength indicator
        newPassword.addEventListener('input', function() {
            const password = this.value;
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumber = /[0-9]/.test(password);
            const hasMinLength = password.length >= 8;

            if (hasUpperCase && hasLowerCase && hasNumber && hasMinLength) {
                this.style.borderColor = 'var(--green-600)';
            } else if (password.length > 0) {
                this.style.borderColor = '#fbbf24';
            } else {
                this.style.borderColor = '#e5e7eb';
            }
        });
    </script>
</body>
</html>