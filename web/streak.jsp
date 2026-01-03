<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("Login_Form.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    
Integer currentStreak = (Integer) request.getAttribute("currentStreak");
Integer longestStreak = (Integer) request.getAttribute("longestStreak");
Integer totalDays = (Integer) request.getAttribute("totalDays");
Boolean loggedToday = (Boolean) request.getAttribute("loggedToday");

if (currentStreak == null) currentStreak = 0;
if (longestStreak == null) longestStreak = 0;
if (totalDays == null) totalDays = 0;
if (loggedToday == null) loggedToday = false;



%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Streak - EcoTrack</title>
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
    border-radius: 50%;
    overflow: hidden;
    background-color: #e5e7eb;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
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
        .profile-item-danger { color: #b91c1c; }
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
        }

        /* Streak Hero Section */
        .streak-hero {
            background: linear-gradient(135deg, var(--green-600), var(--green-700));
            color: white;
            padding: 3rem;
            border-radius: 1rem;
            text-align: center;
            margin-bottom: 3rem;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
        }
        .streak-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
            animation: flame 1.5s ease-in-out infinite;
        }
        @keyframes flame {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        .streak-number {
            font-size: 4rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .streak-label {
            font-size: 1.5rem;
            opacity: 0.9;
            margin-bottom: 1rem;
        }
        .streak-message {
            font-size: 1.125rem;
            opacity: 0.85;
            max-width: 600px;
            margin: 0 auto;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .stat-card-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }
        .stat-card-label {
            color: var(--gray-600);
            font-size: 1rem;
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Calendar */
        .calendar {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 0.5rem;
        }
        .calendar-day {
            aspect-ratio: 1;
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            font-weight: 600;
            background: #e5e7eb;
            color: var(--gray-600);
        }
        .calendar-day.logged {
            background: var(--green-600);
            color: white;
        }
        .calendar-day.today {
            border: 3px solid var(--green-700);
        }
        .calendar-day.missed {
            background: #fee2e2;
            color: #b91c1c;
        }
        .calendar-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--gray-600);
            text-align: center;
            font-size: 0.875rem;
        }

        .achievement-list {
            display: grid;
            gap: 1rem;
        }
        .achievement-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.5rem;
            background: var(--gray-50);
            border-radius: 0.75rem;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        .achievement-item:hover {
            border-color: var(--green-600);
            transform: translateX(5px);
        }
        .achievement-item.unlocked {
            background: #d1fae5;
        }
        .achievement-badge {
            width: 4rem;
            height: 4rem;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            flex-shrink: 0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .achievement-item.locked .achievement-badge {
            filter: grayscale(100%);
            opacity: 0.5;
        }
        .achievement-info {
            flex: 1;
        }
        .achievement-title {
            font-weight: 700;
            color: var(--gray-800);
            font-size: 1.125rem;
            margin-bottom: 0.25rem;
        }
        .achievement-desc {
            color: var(--gray-600);
            font-size: 0.875rem;
        }
        .achievement-status {
            font-weight: 600;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.875rem;
        }
        .achievement-status.unlocked {
            background: var(--green-600);
            color: white;
        }
        .achievement-status.locked {
            background: #e5e7eb;
            color: var(--gray-600);
        }

        .motivation-box {
            background: linear-gradient(135deg, #fef3c7, #fde68a);
            padding: 2rem;
            border-radius: 0.75rem;
            text-align: center;
            border: 2px solid #fbbf24;
        }
        .motivation-box h3 {
            color: #92400e;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .motivation-box p {
            color: #78350f;
            font-size: 1.125rem;
            line-height: 1.6;
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
    String profilePhoto = (String) session.getAttribute("profilePhoto");
    if (profilePhoto != null) {
%>
    <img src="<%= profilePhoto %>"
         style="width:100%;height:100%;object-fit:cover;">
<%
    } else {
%>
    <span><%= userName.substring(0,1).toUpperCase() %></span>
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
                <h1>🔥 Your Streak</h1>
                <p>Build healthy sustainability habits with daily tracking</p>
            </div>

            <!-- Streak Hero -->
            <div class="streak-hero">
                <div class="streak-icon">🔥</div>
                <div class="streak-number"><%= currentStreak %> Days</div>
                <div class="streak-label">Current Streak</div>
                <div class="streak-message">
                    <% if (loggedToday) { %>
                        You're on fire! You've logged your emissions today. Keep it going!
                    <% } else { %>
                        Don't break the chain! Log your emissions today to keep your streak alive.
                    <% } %>
                </div>
            </div>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-card-icon">🏆</div>
                    <div class="stat-card-value"><%= longestStreak %></div>
                    <div class="stat-card-label">Longest Streak</div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-icon">📅</div>
                    <div class="stat-card-value"><%= totalDays %></div>
                    <div class="stat-card-label">Total Days Logged</div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-icon">⭐</div>
                    <div class="stat-card-value"><%= (int)((totalDays / 45.0) * 100) %>%</div>
                    <div class="stat-card-label">Consistency Rate</div>
                </div>
            </div>

            <!-- Activity Calendar -->
            <div class="card">
                <h2>📆 Activity Calendar</h2>
                <div class="calendar-header">
                    <div>Sun</div>
                    <div>Mon</div>
                    <div>Tue</div>
                    <div>Wed</div>
                    <div>Thu</div>
                    <div>Fri</div>
                    <div>Sat</div>
                </div>
                <div class="calendar">
<%
    List<Map<String, Object>> calendarDays =
        (List<Map<String, Object>>) request.getAttribute("calendarDays");

    for (Map<String, Object> d : calendarDays) {
        boolean logged = (boolean) d.get("logged");
        boolean todayFlag = (boolean) d.get("today");

        String cls = "calendar-day";
        if (logged) cls += " logged";
        if (!logged && !todayFlag) cls += " missed";
        if (todayFlag) cls += " today";
%>
    <div class="<%= cls %>"><%= d.get("day") %></div>
<%
    }
%>
</div>

                <div style="display: flex; gap: 2rem; justify-content: center; margin-top: 1.5rem; font-size: 0.875rem;">
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <div style="width: 20px; height: 20px; background: var(--green-600); border-radius: 4px;"></div>
                        <span>Logged</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <div style="width: 20px; height: 20px; background: #fee2e2; border-radius: 4px;"></div>
                        <span>Missed</span>
                    </div>
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <div style="width: 20px; height: 20px; background: #e5e7eb; border-radius: 4px;"></div>
                        <span>Future</span>
                    </div>
                </div>
            </div>

            <!-- Achievements -->
            <div class="card">
                <h2>🏅 Streak Achievements</h2>
<div class="achievement-list">
<%
    Map<String, Boolean> achievements =
        (Map<String, Boolean>) request.getAttribute("achievements");

    for (Map.Entry<String, Boolean> a : achievements.entrySet()) {
        boolean unlocked = a.getValue();
%>
    <div class="achievement-item <%= unlocked ? "unlocked" : "locked" %>">
        <div class="achievement-badge">
            <%= unlocked ? "🏆" : "🔒" %>
        </div>

        <div class="achievement-info">
            <div class="achievement-title"><%= a.getKey() %></div>
            <div class="achievement-desc">
                <%= unlocked ? "Achievement unlocked" : "Keep your streak going!" %>
            </div>
        </div>

        <div class="achievement-status <%= unlocked ? "unlocked" : "locked" %>">
            <%= unlocked ? "Unlocked" : "Locked" %>
        </div>
    </div>
<%
    }
%>
</div>

            </div>

            <!-- Motivation -->
            <div class="motivation-box">
                <h3>💡 Why Streaks Matter</h3>
                <p>
                    Consistency is key to building sustainable habits. By tracking your emissions daily, 
                    you become more aware of your environmental impact and make better choices naturally. 
                    Each day logged is a step toward a more sustainable future!
                </p>
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
    </script>
</body>
</html>