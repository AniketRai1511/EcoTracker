<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("Login_Form.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    DecimalFormat df = new DecimalFormat("#,##0.00");
    
Double totalEmissions = (Double) request.getAttribute("totalEmissions");
Double monthlyAverage = (Double) request.getAttribute("monthlyAverage");
Double weeklyAverage = (Double) request.getAttribute("weeklyAverage");
Double reductionPercent = (Double) request.getAttribute("reductionPercent");
Integer treesEquivalent = (Integer) request.getAttribute("treesEquivalent");
Double savedMoney = (Double) request.getAttribute("savedMoney");



if (totalEmissions == null) totalEmissions = 0.0;
if (monthlyAverage == null) monthlyAverage = 0.0;
if (weeklyAverage == null) weeklyAverage = 0.0;
if (reductionPercent == null) reductionPercent = 0.0;
if (treesEquivalent == null) treesEquivalent = 0;
if (savedMoney == null) savedMoney = 0.0;

%>

<%
double transport = (double) request.getAttribute("transport");
double food = (double) request.getAttribute("food");
double energy = (double) request.getAttribute("energy");

double transportPct = (double) request.getAttribute("transportPct");
double foodPct = (double) request.getAttribute("foodPct");
double energyPct = (double) request.getAttribute("energyPct");

String dailyLabels = (String) request.getAttribute("dailyLabels");
String dailyValues = (String) request.getAttribute("dailyValues");
%>

<%
Boolean weekComplete = (Boolean) request.getAttribute("weekComplete");
Boolean ecoBeginner = (Boolean) request.getAttribute("ecoBeginner");
Boolean greenCommuter = (Boolean) request.getAttribute("greenCommuter");
Boolean sustainabilityChampion = (Boolean) request.getAttribute("sustainabilityChampion");

Integer trackingDays = (Integer) request.getAttribute("trackingDays");
Integer transportCount = (Integer) request.getAttribute("transportCount");

/* Null safety (VERY IMPORTANT) */
weekComplete = (weekComplete != null) ? weekComplete : false;
ecoBeginner = (ecoBeginner != null) ? ecoBeginner : false;
greenCommuter = (greenCommuter != null) ? greenCommuter : false;
sustainabilityChampion = (sustainabilityChampion != null) ? sustainabilityChampion : false;

trackingDays = (trackingDays != null) ? trackingDays : 0;
transportCount = (transportCount != null) ? transportCount : 0;
%>



<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Progress - EcoTrack</title>
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

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        .stat-icon.green { background: #d1fae5; }
        .stat-icon.blue { background: #dbeafe; }
        .stat-icon.yellow { background: #fef3c7; }
        .stat-icon.purple { background: #e9d5ff; }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 0.25rem;
        }
        .stat-label {
            color: var(--gray-600);
            font-size: 0.875rem;
        }
        .stat-change {
            margin-top: 0.5rem;
            font-size: 0.875rem;
            font-weight: 600;
        }
        .stat-change.positive { color: var(--green-600); }
        .stat-change.negative { color: #dc3545; }

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

        .chart-container {
            width: 100%;
            height: 300px;
            background: var(--gray-50);
            border-radius: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--gray-600);
            margin-bottom: 1rem;
        }

        .progress-bar-container {
            margin-bottom: 2rem;
        }
        .progress-bar-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
        }
        .progress-bar-label {
            font-weight: 600;
            color: var(--gray-800);
        }
        .progress-bar-value {
            font-weight: 600;
            color: var(--green-600);
        }
        .progress-bar {
            width: 100%;
            height: 1.5rem;
            background: #e5e7eb;
            border-radius: 9999px;
            overflow: hidden;
        }
        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--green-600), var(--green-700));
            border-radius: 9999px;
            transition: width 1s ease;
        }

        .milestone-list {
            display: grid;
            gap: 1rem;
        }
        .milestone-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            background: var(--gray-50);
            border-radius: 0.5rem;
            border-left: 4px solid var(--green-600);
        }
        .milestone-item.completed {
            background: #d1fae5;
        }
        .milestone-icon {
            width: 3rem;
            height: 3rem;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        .milestone-info {
            flex: 1;
        }
        .milestone-title {
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 0.25rem;
        }
        .milestone-desc {
            font-size: 0.875rem;
            color: var(--gray-600);
        }
        .milestone-status {
            font-weight: 600;
            font-size: 0.875rem;
        }
        .milestone-status.completed {
            color: var(--green-600);
        }
        .milestone-status.pending {
            color: var(--gray-600);
        }

        .comparison-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
        }
        .comparison-card {
            background: var(--gray-50);
            padding: 1.5rem;
            border-radius: 0.75rem;
            text-align: center;
        }
        .comparison-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .comparison-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }
        .comparison-label {
            color: var(--gray-600);
            font-size: 0.875rem;
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
            .comparison-grid {
                grid-template-columns: 1fr;
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
                <h1>📊 Your Progress</h1>
                <p>Track your journey towards a sustainable lifestyle</p>
            </div>

            <!-- Stats Overview -->
            <div class="stats-overview">
                <div class="stat-card">
                    <div class="stat-icon green">🌍</div>
                    <div class="stat-value"><%= df.format(totalEmissions) %> kg</div>
                    <div class="stat-label">Total CO₂ This Month</div>
                    <div class="stat-change positive">↓ <%= reductionPercent %>% vs last month</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon blue">📅</div>
                    <div class="stat-value"><%= df.format(monthlyAverage) %> kg</div>
                    <div class="stat-label">Monthly Average</div>
                    <div class="stat-change positive">↓ 15% improvement</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon yellow">🌳</div>
                    <div class="stat-value"><%= treesEquivalent %></div>
                    <div class="stat-label">Trees Needed to Offset</div>
                    <div class="stat-change positive">↓ 3 less than last month</div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon purple">💰</div>
                    <div class="stat-value">₹<%= df.format(savedMoney) %></div>
                    <div class="stat-label">Estimated Savings</div>
                    <div class="stat-change positive">↑ ₹450 this month</div>
                </div>
            </div>

            <!-- Emission Trends -->
 <div class="card">
    <h2>📈 Emission Trends</h2>
    <canvas id="lineChart" height="120"></canvas>
</div>

<div class="card">
    <h2>🎯 Emission Breakdown</h2>
    <canvas id="pieChart" height="120"></canvas>
</div>



<div class="card">
    <h2>🎯 Category Breakdown</h2>

    <div class="progress-bar-container">
        <div class="progress-bar-header">
            <span>🚗 Transportation</span>
            <span><%= df.format(transport) %> kg ( <%= df.format(transportPct) %>% )</span>
        </div>
        <div class="progress-bar">
            <div class="progress-bar-fill" style="width:<%= transportPct %>%"></div>
        </div>
    </div>

    <div class="progress-bar-container">
        <div class="progress-bar-header">
            <span>🍽️ Food</span>
            <span><%= df.format(food) %> kg ( <%= df.format(foodPct) %>% )</span>
        </div>
        <div class="progress-bar">
            <div class="progress-bar-fill" style="width:<%= foodPct %>%"></div>
        </div>
    </div>

    <div class="progress-bar-container">
        <div class="progress-bar-header">
            <span>⚡ Energy</span>
            <span><%= df.format(energy) %> kg ( <%= df.format(energyPct) %>% )</span>
        </div>
        <div class="progress-bar">
            <div class="progress-bar-fill" style="width:<%= energyPct %>%"></div>
        </div>
    </div>
</div>


            <!-- Milestones -->
<div class="milestone-list">

    <!-- First Week -->
    <div class="milestone-item <%= weekComplete ? "completed" : "" %>">
        <div class="milestone-icon">✅</div>
        <div class="milestone-info">
            <div class="milestone-title">First Week Complete</div>
            <div class="milestone-desc">Track emissions for 7 days</div>
        </div>
        <div class="milestone-status <%= weekComplete ? "completed" : "pending" %>">
            <%= weekComplete ? "Completed" : trackingDays + "/7 days" %>
        </div>
    </div>

    <!-- Eco Beginner -->
    <div class="milestone-item <%= ecoBeginner ? "completed" : "" %>">
        <div class="milestone-icon">🌱</div>
        <div class="milestone-info">
            <div class="milestone-title">Eco Beginner</div>
            <div class="milestone-desc">Reduce emissions by 10%</div>
        </div>
        <div class="milestone-status <%= ecoBeginner ? "completed" : "pending" %>">
            <%= ecoBeginner ? "Completed" : "In Progress" %>
        </div>
    </div>

    <!-- Green Commuter -->
    <div class="milestone-item <%= greenCommuter ? "completed" : "" %>">
        <div class="milestone-icon">🚴</div>
        <div class="milestone-info">
            <div class="milestone-title">Green Commuter</div>
            <div class="milestone-desc">Use transport 10 times</div>
        </div>
        <div class="milestone-status <%= greenCommuter ? "completed" : "pending" %>">
            <%= greenCommuter ? "Completed" : transportCount + "/10" %>
        </div>
    </div>

    <!-- Sustainability Champion -->
    <div class="milestone-item <%= sustainabilityChampion ? "completed" : "" %>">
        <div class="milestone-icon">🌟</div>
        <div class="milestone-info">
            <div class="milestone-title">Sustainability Champion</div>
            <div class="milestone-desc">Reduce emissions by 25%</div>
        </div>
        <div class="milestone-status <%= sustainabilityChampion ? "completed" : "pending" %>">
            <%= sustainabilityChampion ? "Completed" : "Locked" %>
        </div>
    </div>

</div>


            <!-- Impact Comparison -->
            <div class="card">
                <h2>🌍 Your Impact</h2>
                <div class="comparison-grid">
                    <div class="comparison-card">
                        <div class="comparison-icon">🌳</div>
                        <div class="comparison-value"><%= treesEquivalent %></div>
                        <div class="comparison-label">Trees planted equivalent</div>
                    </div>
                    <div class="comparison-card">
                        <div class="comparison-icon">💰</div>
                        <div class="comparison-value">₹<%= df.format(savedMoney) %></div>
                        <div class="comparison-label">Money saved</div>
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
    </script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
/* ---------- PIE CHART ---------- */
const pieCtx = document.getElementById('pieChart');

new Chart(pieCtx, {
    type: 'pie',
    data: {
        labels: ['Transportation', 'Food', 'Energy'],
        datasets: [{
            data: [
                <%= transportPct %>,
                <%= foodPct %>,
                <%= energyPct %>
            ],
            backgroundColor: [
                '#16a34a',
                '#2563eb',
                '#f59e0b'
            ]
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { position: 'bottom' }
        }
    }
});

/* ---------- LINE CHART ---------- */
const lineCtx = document.getElementById('lineChart');

new Chart(lineCtx, {
    type: 'line',
    data: {
        labels: <%= dailyLabels %>,
        datasets: [{
            label: 'CO₂ Emissions (kg)',
            data: <%= dailyValues %>,
            borderColor: '#16a34a',
            backgroundColor: 'rgba(22,163,74,0.2)',
            tension: 0.4,
            fill: true
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