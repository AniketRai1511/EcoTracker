<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>EcoTrack - Sign Up</title>

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
    }

    body {
      position: relative;
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: auto;
      background: linear-gradient(135deg, rgba(15, 32, 39, 0.9) 0%, rgba(32, 58, 67, 0.9) 50%, rgba(44, 83, 100, 0.9) 100%),
        url('https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1920&q=80');
      background-size: cover;
      background-position: center;
      background-attachment: fixed;
    }

    /* Animated Background Particles */
    .particles {
      position: absolute;
      width: 100%;
      height: 100%;
      overflow: hidden;
      pointer-events: none;
    }

    .particle {
      position: absolute;
      width: 4px;
      height: 4px;
      background: rgba(22, 163, 74, 0.6);
      border-radius: 50%;
      animation: float-particle 20s linear infinite;
    }

    @keyframes float-particle {
      0% { 
        transform: translateY(100vh) translateX(0) scale(0);
        opacity: 0;
      }
      10% { opacity: 1; }
      90% { opacity: 1; }
      100% { 
        transform: translateY(-100vh) translateX(100px) scale(1);
        opacity: 0;
      }
    }

    .particle:nth-child(1) { left: 10%; animation-delay: 0s; }
    .particle:nth-child(2) { left: 20%; animation-delay: 2s; animation-duration: 18s; }
    .particle:nth-child(3) { left: 30%; animation-delay: 4s; animation-duration: 22s; }
    .particle:nth-child(4) { left: 40%; animation-delay: 1s; animation-duration: 19s; }
    .particle:nth-child(5) { left: 50%; animation-delay: 3s; animation-duration: 21s; }
    .particle:nth-child(6) { left: 60%; animation-delay: 5s; animation-duration: 17s; }
    .particle:nth-child(7) { left: 70%; animation-delay: 2.5s; animation-duration: 20s; }
    .particle:nth-child(8) { left: 80%; animation-delay: 4.5s; animation-duration: 23s; }
    .particle:nth-child(9) { left: 90%; animation-delay: 1.5s; animation-duration: 18s; }
    .particle:nth-child(10) { left: 15%; animation-delay: 6s; animation-duration: 19s; }

    .signup-container {
  width: 100%;
  max-width: 560px;          /* ⬅ increased width */
  padding: 56px 56px;        /* ⬅ more breathing space */
  text-align: center;
  background: rgba(255, 255, 255, 0.96);
  backdrop-filter: blur(20px);
  border-radius: 26px;
  box-shadow: 
    0 25px 70px rgba(0, 0, 0, 0.35),
    0 0 120px rgba(22, 163, 74, 0.12);
  transform: translateY(20px);
  opacity: 0;
  animation: fadeUp 1s ease forwards;
  position: relative;
  z-index: 10;
  margin: 24px;
    }
    
    @media (min-width: 1024px) {
  .signup-container {
    max-width: 620px;
  }
}

    @keyframes fadeUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    .logo-section {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
      margin-bottom: 8px;
    }

    .logo-icon {
      width: 48px;
      height: 48px;
      color: #16a34a;
      animation: pulse 2s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { transform: scale(1); }
      50% { transform: scale(1.05); }
    }

    .app-header h1 {
      color: #1f2937;
      font-size: 32px;
      font-weight: 700;
      margin: 0;
    }

    .app-header p {
      color: #6b7280;
      font-size: 15px;
      margin-top: 8px;
      margin-bottom: 32px;
      font-weight: 400;
    }

    .welcome-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
      color: #065f46;
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      margin-bottom: 24px;
      animation: slideIn 0.8s ease forwards;
      animation-delay: 0.3s;
      opacity: 0;
    }

    @keyframes slideIn {
      from {
        opacity: 0;
        transform: translateX(-20px);
      }
      to {
        opacity: 1;
        transform: translateX(0);
      }
    }

    .signup-form {
      text-align: left;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .signup-form label {
      display: block;
      font-size: 14px;
      color: #374151;
      margin-bottom: 8px;
      font-weight: 600;
    }

    .input-wrapper {
      position: relative;
    }

    .input-icon {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 18px;
      pointer-events: none;
    }

    .signup-form input {
      width: 100%;
      border: 2px solid #e5e7eb;
      border-radius: 12px;
      padding: 12px 14px 12px 44px;
      font-size: 15px;
      outline: none;
      transition: all 0.3s ease;
      background: #fff;
    }

    .signup-form input:focus {
      border-color: #16a34a;
      box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
    }

    .signup-form input::placeholder {
      color: #9ca3af;
    }

    .password-strength {
      margin-top: 8px;
      font-size: 12px;
      color: #6b7280;
    }

    .strength-bar {
      height: 4px;
      background: #e5e7eb;
      border-radius: 2px;
      margin-top: 4px;
      overflow: hidden;
    }

    .strength-fill {
      height: 100%;
      width: 0%;
      transition: all 0.3s ease;
      border-radius: 2px;
    }

    .strength-weak { width: 33%; background: #ef4444; }
    .strength-medium { width: 66%; background: #f59e0b; }
    .strength-strong { width: 100%; background: #16a34a; }

    .terms-checkbox {
      display: flex;
      align-items: flex-start;
      gap: 8px;
      margin-bottom: 24px;
      text-align: left;
    }

    .terms-checkbox input[type="checkbox"] {
      width: 16px;
      height: 16px;
      cursor: pointer;
      margin-top: 2px;
      flex-shrink: 0;
    }

    .terms-checkbox label {
      font-size: 13px;
      color: #4b5563;
      cursor: pointer;
      margin: 0;
      font-weight: 400;
    }

    .terms-checkbox a {
      color: #16a34a;
      text-decoration: none;
      font-weight: 600;
    }

    .terms-checkbox a:hover {
      text-decoration: underline;
    }

    .signup-btn {
      width: 100%;
      background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
      color: #fff;
      border: none;
      padding: 14px;
      border-radius: 12px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      box-shadow: 0 4px 12px rgba(22, 163, 74, 0.3);
    }

    .signup-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(22, 163, 74, 0.4);
    }

    .signup-btn:active {
      transform: translateY(0);
    }

    .signup-btn:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
    }

    .login-text {
      margin-top: 24px;
      color: #6b7280;
      font-size: 14px;
      padding-top: 24px;
      border-top: 1px solid #e5e7eb;
    }

    .login-text a {
      color: #16a34a;
      font-weight: 600;
      text-decoration: none;
      transition: color 0.3s ease;
    }

    .login-text a:hover {
      color: #15803d;
      text-decoration: underline;
    }

    .features {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16px;
      margin-top: 24px;
      padding-top: 24px;
      border-top: 1px solid #e5e7eb;
    }

    .feature-item {
      text-align: center;
    }

    .feature-icon {
      font-size: 24px;
      margin-bottom: 6px;
    }

    .feature-text {
      font-size: 11px;
      color: #6b7280;
      font-weight: 500;
    }

    .error-message {
      background-color: #fee2e2;
      color: #991b1b;
      padding: 12px 16px;
      border-radius: 8px;
      font-size: 14px;
      margin-bottom: 20px;
      border: 1px solid #fecaca;
      animation: slideDown 0.5s ease;
    }

    @keyframes slideDown {
      from {
        opacity: 0;
        transform: translateY(-10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @media (max-width: 480px) {
      .signup-container {
        padding: 32px 24px;
        margin: 16px;
      }

      .app-header h1 {
        font-size: 28px;
      }

      .features {
        grid-template-columns: 1fr;
        gap: 12px;
      }
    }
  </style>
</head>
<body>

  <!-- Animated Background Particles -->
  <div class="particles">
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
  </div>

  <div class="signup-container">
    <div class="logo-section">
      <svg class="logo-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="0.5">
        <path d="M17 8C8 10 5.5 17.5 9.5 22C15.5 18 18.5 11.5 17 8Z" />
        <path d="M15 2C13.3 4.8 11.2 7.3 9 9" />
      </svg>
    </div>

    <div class="app-header">
      <h1>EcoTrack</h1>
      <p>Create your account and start tracking</p>
    </div>

    <div class="welcome-badge">
      🌱 Join the sustainability movement
    </div>

    <!-- Signup Form -->
    <form class="signup-form" action="SignupServlet" method="post" id="signupForm">
      <div class="form-group">
        <label for="name">Full Name</label>
        <div class="input-wrapper">
          <span class="input-icon">👤</span>
          <input type="text" id="name" name="name" placeholder="Enter your full name" required />
        </div>
      </div>

      <div class="form-group">
        <label for="email">Email Address</label>
        <div class="input-wrapper">
          <span class="input-icon">📧</span>
          <input type="email" id="email" name="email" placeholder="Enter your email" required />
        </div>
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <div class="input-wrapper">
          <span class="input-icon">🔒</span>
          <input type="password" id="password" name="password" placeholder="Create a password" required />
        </div>
        <div class="password-strength">
          <span id="strengthText">Password strength</span>
          <div class="strength-bar">
            <div class="strength-fill" id="strengthBar"></div>
          </div>
        </div>
      </div>

      <div class="form-group">
        <label for="confirmPassword">Confirm Password</label>
        <div class="input-wrapper">
          <span class="input-icon">🔑</span>
          <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter your password" required />
        </div>
      </div>

      <div class="terms-checkbox">
        <input type="checkbox" id="terms" name="terms" required />
        <label for="terms">
          I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
        </label>
      </div>

      <button type="submit" class="signup-btn">Create Account</button>
    </form>

    <div class="features">
      <div class="feature-item">
        <div class="feature-icon">🚗</div>
        <div class="feature-text">Track Transport</div>
      </div>
      <div class="feature-item">
        <div class="feature-icon">🥗</div>
        <div class="feature-text">Monitor Diet</div>
      </div>
      <div class="feature-item">
        <div class="feature-icon">⚡</div>
        <div class="feature-text">Energy Usage</div>
      </div>
    </div>

    <p class="login-text">
      Already have an account? <a href="Login_Form.jsp">Sign In</a>
    </p>
  </div>

  <script>
    // Password strength checker
    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');

    passwordInput.addEventListener('input', function() {
      const password = this.value;
      let strength = 0;

      if (password.length >= 8) strength++;
      if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
      if (password.match(/[0-9]/)) strength++;
      if (password.match(/[^a-zA-Z0-9]/)) strength++;

      strengthBar.className = 'strength-fill';
      
      if (strength === 0 || password.length === 0) {
        strengthText.textContent = 'Password strength';
        strengthBar.style.width = '0%';
      } else if (strength <= 2) {
        strengthText.textContent = 'Weak password';
        strengthBar.classList.add('strength-weak');
      } else if (strength === 3) {
        strengthText.textContent = 'Medium password';
        strengthBar.classList.add('strength-medium');
      } else {
        strengthText.textContent = 'Strong password';
        strengthBar.classList.add('strength-strong');
      }
    });

    // Password match validation
    const form = document.getElementById('signupForm');
    const confirmPassword = document.getElementById('confirmPassword');

    form.addEventListener('submit', function(e) {
      if (passwordInput.value !== confirmPassword.value) {
        e.preventDefault();
        alert('Passwords do not match!');
        confirmPassword.focus();
      }
    });
  </script>

</body>
</html>