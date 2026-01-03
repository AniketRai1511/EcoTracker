<h2>User ID = <%= session.getAttribute("userId") %></h2>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("Login_Form.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    
    // Data from servlet - you'll set these attributes in your DashboardServlet
    Double totalEmissions = (Double) request.getAttribute("totalEmissions");
    Double transportEmissions = (Double) request.getAttribute("transportEmissions");
    Double foodEmissions = (Double) request.getAttribute("foodEmissions");
    Double energyEmissions = (Double) request.getAttribute("energyEmissions");
    
    Double dailyAvg = (Double) request.getAttribute("dailyAvg");
    Double monthlyAvg = (Double) request.getAttribute("monthlyAvg");
    
    // For charts - lists of data points
    List<Double> last7DaysData = (List<Double>) request.getAttribute("last7DaysData");
    List<String> last7DaysLabels = (List<String>) request.getAttribute("last7DaysLabels");
    
    List<Double> last6MonthsData = (List<Double>) request.getAttribute("last6MonthsData");
    List<String> last6MonthsLabels = (List<String>) request.getAttribute("last6MonthsLabels");
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
    
    // Default values if data is null
    if (totalEmissions == null) totalEmissions = 0.0;
    if (transportEmissions == null) transportEmissions = 0.0;
    if (foodEmissions == null) foodEmissions = 0.0;
    if (energyEmissions == null) energyEmissions = 0.0;
    if (dailyAvg == null) dailyAvg = 0.0;
    if (monthlyAvg == null) monthlyAvg = 0.0;
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - EcoTrack</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
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

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1);
        }

        .stat-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }

        .stat-icon.transport {
            background: linear-gradient(135deg, #dbeafe 0%, #93c5fd 100%);
        }

        .stat-icon.food {
            background: linear-gradient(135deg, #fef3c7 0%, #fcd34d 100%);
        }

        .stat-icon.energy {
            background: linear-gradient(135deg, #fce7f3 0%, #f9a8d4 100%);
        }

        .stat-icon.total {
            background: linear-gradient(135deg, #d1fae5 0%, #6ee7b7 100%);
        }

        .stat-label {
            font-size: 0.875rem;
            color: var(--gray-600);
            font-weight: 500;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-top: 0.5rem;
        }

        .stat-value-small {
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .stat-trend {
            margin-top: 0.75rem;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .stat-trend.positive {
            color: #16a34a;
        }

        .stat-trend.negative {
            color: #dc2626;
        }

        /* Charts Section */
        .charts-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .chart-card {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
        }

        .chart-header {
            margin-bottom: 1.5rem;
        }

        .chart-header h2 {
            font-size: 1.5rem;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }

        .chart-header p {
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .chart-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #e5e7eb;
        }

        .chart-tab {
            padding: 0.75rem 1.5rem;
            background: none;
            border: none;
            cursor: pointer;
            font-weight: 600;
            color: var(--gray-600);
            border-bottom: 2px solid transparent;
            margin-bottom: -2px;
            transition: all 0.3s ease;
        }

        .chart-tab.active {
            color: var(--green-600);
            border-bottom-color: var(--green-600);
        }

        .chart-content {
            display: none;
        }

        .chart-content.active {
            display: block;
        }

        .chart-container {
            position: relative;
            height: 350px;
        }

        /* Category Breakdown */
        .breakdown-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .breakdown-card {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
        }

        .breakdown-card h3 {
            font-size: 1.25rem;
            color: var(--gray-800);
            margin-bottom: 1.5rem;
        }

        .breakdown-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem;
            background: var(--gray-50);
            border-radius: 0.5rem;
            margin-bottom: 0.75rem;
        }

        .breakdown-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .breakdown-icon {
            font-size: 1.5rem;
        }

        .breakdown-label {
            font-weight: 600;
            color: var(--gray-800);
        }

        .breakdown-percentage {
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .breakdown-value {
            font-weight: 700;
            color: var(--green-600);
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
            .charts-grid {
                grid-template-columns: 1fr 1fr;
            }
            .footer-grid {
                grid-template-columns: repeat(4, 1fr);
            }
            .footer .logo-column {
                grid-column: span 2;
            }
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
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
                <h1>📊 Carbon Footprint Dashboard</h1>
                <p>Track and analyze your environmental impact across all categories</p>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div class="stat-icon total">🌍</div>
                    </div>
                    <div class="stat-label">Total Emissions</div>
                    <div class="stat-value"><%= df.format(totalEmissions) %> <span class="stat-value-small">kg CO₂</span></div>
                    <div class="stat-trend positive">
                        ↓ Track all your emissions
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <div class="stat-icon transport">🚗</div>
                    </div>
                    <div class="stat-label">Transportation</div>
                    <div class="stat-value"><%= df.format(transportEmissions) %> <span class="stat-value-small">kg CO₂</span></div>
                    <div class="stat-trend">
                        <%= totalEmissions > 0 ? String.format("%.1f", (transportEmissions/totalEmissions)*100) : "0" %>% of total
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <div class="stat-icon food">🥗</div>
                    </div>
                    <div class="stat-label">Food Consumption</div>
                    <div class="stat-value"><%= df.format(foodEmissions) %> <span class="stat-value-small">kg CO₂</span></div>
                    <div class="stat-trend">
                        <%= totalEmissions > 0 ? String.format("%.1f", (foodEmissions/totalEmissions)*100) : "0" %>% of total
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-card-header">
                        <div class="stat-icon energy">⚡</div>
                    </div>
                    <div class="stat-label">Energy Usage</div>
                    <div class="stat-value"><%= df.format(energyEmissions) %> <span class="stat-value-small">kg CO₂</span></div>
                    <div class="stat-trend">
                        <%= totalEmissions > 0 ? String.format("%.1f", (energyEmissions/totalEmissions)*100) : "0" %>% of total
                    </div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-grid">
                <!-- Time-based Chart -->
                <div class="chart-card" style="grid-column: 1 / -1;">
                    <div class="chart-header">
                        <h2>Emissions Over Time</h2>
                        <p>Track your carbon footprint trends</p>
                    </div>

                    <div class="chart-tabs">
                        <button class="chart-tab active" onclick="switchTab('daily')">Daily (Last 7 Days)</button>
                        <button class="chart-tab" onclick="switchTab('monthly')">Monthly (Last 6 Months)</button>
                    </div>

                    <div class="chart-content active" id="dailyChart">
                        <div class="chart-container">
                            <canvas id="dailyCanvas"></canvas>
                        </div>
                    </div>

                    <div class="chart-content" id="monthlyChart">
                        <div class="chart-container">
                            <canvas id="monthlyCanvas"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Category Breakdown Pie Chart -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h2>Emissions by Category</h2>
                        <p>Distribution of your carbon footprint</p>
                    </div>
                    <div class="chart-container">
                        <canvas id="pieChart"></canvas>
                    </div>
                </div>

                <!-- Averages -->
                <div class="chart-card">
                    <div class="chart-header">
                        <h2>Average Emissions</h2>
                        <p>Your daily and monthly averages</p>
                    </div>
                    <div class="chart-container">
                        <canvas id="barChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Detailed Breakdown -->
            <div class="breakdown-grid">
                <div class="breakdown-card">
                    <h3>🎯 Sustainability Goals</h3>
                    <div class="breakdown-item">
                        <div class="breakdown-info">
                            <span class="breakdown-icon">🌳</span>
                            <div>
                                <div class="breakdown-label">Trees Needed</div>
                                <div class="breakdown-percentage">To offset annually</div>
                            </div>
                        </div>
                        <div class="breakdown-value"><%= Math.ceil((totalEmissions * 365) / 21.77) %></div>
                    </div>
                    <div class="breakdown-item">
                        <div class="breakdown-info">
                            <span class="breakdown-icon">📅</span>
                            <div>
                                <div class="breakdown-label">Daily Average</div>
                                <div class="breakdown-percentage">Per day</div>
                            </div>
                        </div>
                        <div class="breakdown-value"><%= df.format(dailyAvg) %> kg</div>
                    </div>
                    <div class="breakdown-item">
                        <div class="breakdown-info">
                            <span class="breakdown-icon">📊</span>
                            <div>
                                <div class="breakdown-label">Monthly Average</div>
                                <div class="breakdown-percentage">Per month</div>
                            </div>
                        </div>
                        <div class="breakdown-value"><%= df.format(monthlyAvg) %> kg</div>
                    </div>
                </div>

                <div class="breakdown-card">
                    <h3>💡 Quick Actions</h3>
                    <div class="breakdown-item" style="cursor: pointer;" onclick="location.href='Transportation.jsp'">
                        <div class="breakdown-info">
                            <span class="breakdown-icon">🚗</span>
                            <div>
                                <div class="breakdown-label">Log Transportation</div>
                                <div class="breakdown-percentage">Track your travel</div>
                            </div>
                        </div>
                        <span>→</span>
                    </div>
                    <div class="breakdown-item" style="cursor: pointer;" onclick="location.href='Food.jsp'">
                        <div class="breakdown-info">
                            <span class="breakdown-icon">🥗</span>
                            <div>
                                <div class="breakdown-label">Log Food</div>
                                <div class="breakdown-percentage">Monitor your diet</div>
                            </div>
                        </div>
                        <span>→</span>
                    </div>
                    <div class="breakdown-item" style="cursor: pointer;" onclick="location.href='Energy.jsp'">
                        <div class="breakdown-info">
                            <span class="breakdown-icon">⚡</span>
                            <div>
                                <div class="breakdown-label">Log Energy</div>
                                <div class="breakdown-percentage">Track consumption</div>
                            </div>
                        </div>
                        <span>→</span>
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

        // Tab switching
        function switchTab(tab) {
            const tabs = document.querySelectorAll('.chart-tab');
            const contents = document.querySelectorAll('.chart-content');

            tabs.forEach(t => t.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));

            if (tab === 'daily') {
                tabs[0].classList.add('active');
                document.getElementById('dailyChart').classList.add('active');
            } else {
                tabs[1].classList.add('active');
                document.getElementById('monthlyChart').classList.add('active');
            }
        }

        // Chart.js configurations
        Chart.defaults.font.family = '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif';

<%
if (last7DaysData != null && last7DaysLabels != null) {
%>
const dailyCtx = document.getElementById('dailyCanvas').getContext('2d');
new Chart(dailyCtx, {
    type: 'line',
    data: {
        labels: <%= last7DaysLabels.toString().replace("[", "['").replace("]", "']").replace(", ", "','") %>,
        datasets: [{
            label: 'Daily Emissions (kg CO₂)',
            data: <%= last7DaysData %>,
            borderColor: '#16a34a',
            backgroundColor: 'rgba(22, 163, 74, 0.15)',
            borderWidth: 3,
            tension: 0.4,
            fill: true,
            pointRadius: 5,
            pointHoverRadius: 8,
            pointBackgroundColor: '#16a34a'
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false }
        },
        scales: {
            y: {
                beginAtZero: true,
                title: { display: true, text: 'kg CO₂' }
            }
        }
    }
});
<%
}
%>
<%
if (last6MonthsData != null && last6MonthsLabels != null) {
%>
const monthlyCtx = document.getElementById('monthlyCanvas').getContext('2d');
new Chart(monthlyCtx, {
    type: 'line',
    data: {
        labels: <%= last6MonthsLabels.toString().replace("[", "['").replace("]", "']").replace(", ", "','") %>,
        datasets: [{
            label: 'Monthly Emissions (kg CO₂)',
            data: <%= last6MonthsData %>,
            borderColor: '#2563eb',
            backgroundColor: 'rgba(37, 99, 235, 0.15)',
            borderWidth: 3,
            tension: 0.4,
            fill: true,
            pointRadius: 5,
            pointHoverRadius: 8
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});
<%
}
%>
const pieCtx = document.getElementById('pieChart').getContext('2d');
new Chart(pieCtx, {
    type: 'pie',
    data: {
        labels: ['Transportation', 'Food', 'Energy'],
        datasets: [{
            data: [
                <%= transportEmissions %>,
                <%= foodEmissions %>,
                <%= energyEmissions %>
            ],
            backgroundColor: ['#3b82f6', '#facc15', '#ec4899']
        }]
    },
    options: {
        responsive: true
    }
});
const barCtx = document.getElementById('barChart').getContext('2d');
new Chart(barCtx, {
    type: 'bar',
    data: {
        labels: ['Daily Avg', 'Monthly Avg'],
        datasets: [{
            label: 'Average Emissions (kg CO₂)',
            data: [<%= dailyAvg %>, <%= monthlyAvg %>],
            backgroundColor: ['#16a34a', '#2563eb']
        }]
    },
    options: {
        responsive: true,
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});
    </script>
</body>
</html>