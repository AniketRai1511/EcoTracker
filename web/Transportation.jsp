<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.DecimalFormat" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("Login_Form.jsp");
        return;
    }
    
    String userName = (String) session.getAttribute("userName");
    Double emission = (Double) request.getAttribute("emission");
    String message = (String) request.getAttribute("message");
    boolean hasResult = emission != null;
    
    DecimalFormat df = new DecimalFormat("#,##0.00");
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transportation - EcoTrack</title>
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
        .btn-success {
            background-color: #28a745;
            color: #fff;
        }
        .btn-success:hover { background-color: #218838; }
        .btn-danger {
            background-color: #dc3545;
            color: #fff;
            padding: 8px 15px;
            font-size: 0.9em;
        }
        .btn-danger:hover { background-color: #c82333; }

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

        .content-grid {
            display: grid;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .card {
            background: white;
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
        }

        .card h2 {
            color: var(--green-600);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            border-bottom: 2px solid var(--green-600);
            padding-bottom: 0.75rem;
        }

        .result-card {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 2rem;
            border-radius: 0.75rem;
            text-align: center;
            margin-bottom: 2rem;
        }
        .result-card.warning {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .result-card h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }
        .result-card .emission-value {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 1rem 0;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1.5rem;
        }
        .stat-box {
            background: linear-gradient(135deg, var(--green-600) 0%, var(--green-700) 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 0.75rem;
            text-align: center;
        }
        .stat-box h4 {
            font-size: 0.875rem;
            margin-bottom: 0.5rem;
            opacity: 0.9;
        }
        .stat-box p {
            font-size: 1.5rem;
            font-weight: bold;
        }

        .info-section {
            background: var(--gray-50);
            padding: 1.5rem;
            border-radius: 0.75rem;
            margin-bottom: 1.5rem;
        }
        .info-section h3 {
            color: var(--green-700);
            margin-bottom: 1rem;
            font-size: 1.25rem;
        }
        .info-section p {
            color: var(--gray-600);
            line-height: 1.6;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }
        .info-item {
            background: white;
            padding: 1rem;
            border-radius: 0.5rem;
            border-left: 4px solid var(--green-600);
        }
        .info-item strong {
            color: var(--green-600);
            display: block;
            margin-bottom: 0.25rem;
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
        select, input[type="number"] {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        select:focus, input[type="number"]:focus {
            outline: none;
            border-color: var(--green-600);
        }

        .trip-entry {
            background: var(--gray-50);
            padding: 1.5rem;
            border-radius: 0.75rem;
            margin-bottom: 1rem;
            border: 2px solid #e5e7eb;
        }
        .trip-entry-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .trip-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1rem;
        }

        .tips-section {
            background: #fff3cd;
            border-left: 5px solid #ffc107;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-top: 1.5rem;
        }
        .tips-section h4 {
            color: #856404;
            margin-bottom: 1rem;
            font-size: 1.125rem;
        }
        .tips-section ul {
            list-style-position: inside;
            color: #856404;
        }
        .tips-section li {
            margin-bottom: 0.75rem;
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
            .content-grid {
                grid-template-columns: 1fr 1fr;
            }
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
                <h1>🚗 Transportation Footprint</h1>
                <p>Track your travel emissions and discover eco-friendly alternatives</p>
            </div>

            <% if (hasResult) { 
                boolean isHigh = emission > 5.0;
            %>
                <!-- Result Section -->
                <div class="<%= isHigh ? "result-card warning" : "result-card" %>">
                    <h3><%= isHigh ? "⚠️ High Emission Alert" : "✅ Great Job!" %></h3>
                    <div class="emission-value"><%= df.format(emission) %> kg CO₂</div>
                    <p style="font-size: 1.125rem;"><%= message %></p>
                </div>

                <div class="stats-grid">
                    <div class="stat-box">
                        <h4>Trees Needed</h4>
                        <p><%= Math.ceil(emission / 21.77) %></p>
                    </div>
                    <div class="stat-box">
                        <h4>Car Miles Equivalent</h4>
                        <p><%= df.format(emission * 2.5) %></p>
                    </div>
                    <div class="stat-box">
                        <h4>Annual Projection</h4>
                        <p><%= df.format(emission * 365) %> kg</p>
                    </div>
                </div>

                <div class="card" style="margin-top: 2rem;">
                    <div class="tips-section">
                        <h4>🌱 Sustainable Transport Tips</h4>
                        <ul>
                            <li><strong>Use public transport:</strong> Buses and trains emit 45% less CO₂ per passenger</li>
                            <li><strong>Carpool:</strong> Share rides to reduce emissions and save money</li>
                            <li><strong>Choose electric:</strong> EVs produce zero direct emissions</li>
                            <li><strong>Bike or walk:</strong> Zero emissions and great for health</li>
                            <li><strong>Plan efficient routes:</strong> Reduce unnecessary travel distance</li>
                            <li><strong>Maintain your vehicle:</strong> Proper maintenance improves fuel efficiency</li>
                        </ul>
                    </div>
                </div>
            <% } %>

            <div class="content-grid">
                <!-- Form Section -->
                <div class="card">
                    <h2>📊 Log Your Travel</h2>
                    <form action="TransportationServlet" method="post" id="transportForm">
                        <div class="form-group">
                            <label for="routine">Select Routine Type:</label>
                            <select name="routine" id="routine" required>
                                <option value="">-- Choose Period --</option>
                                <option value="daily">Daily Routine</option>
                                <option value="monthly">Monthly Routine</option>
                            </select>
                        </div>
                        
                        <div id="tripEntries">
                            <div class="trip-entry">
                                <div class="trip-entry-header">
                                    <strong>Trip #1</strong>
                                </div>
                                <div class="trip-grid">
                                    <div class="form-group">
                                        <label>Transport Mode:</label>
                                        <select name="mode[]" required>
                                            <option value="">-- Select Mode --</option>
                                            <option value="Bike / Scooter (Petrol)">Bike/Scooter (Petrol)</option>
                                            <option value="Electric Two-Wheeler">Electric Two-Wheeler</option>
                                            <option value="Car (Petrol)">Car (Petrol)</option>
                                            <option value="Car (Diesel)">Car (Diesel)</option>
                                            <option value="Car (CNG)">Car (CNG)</option>
                                            <option value="Electric Car">Electric Car</option>
                                            <option value="Auto Rickshaw">Auto Rickshaw</option>
                                            <option value="Bus">Bus</option>
                                            <option value="Metro / Local Train">Metro/Local Train</option>
                                            <option value="Indian Railways">Indian Railways</option>
                                            <option value="Flight (Domestic)">Flight (Domestic)</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Distance (km):</label>
                                        <input type="number" name="distance[]" step="0.1" min="0" placeholder="e.g., 10" required>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <button type="button" class="btn btn-success" onclick="addTrip()">+ Add Another Trip</button>
                        
                        <div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
                            <button type="submit" class="btn btn-green">Calculate Emissions</button>
                            <button type="reset" class="btn btn-secondary">Reset Form</button>
                        </div>
                    </form>
                </div>

                <!-- Information Section -->
                <div class="card">
                    <h2>📚 Transport Information</h2>
                    
                    <div class="info-section">
                        <h3>🌍 Why Track Transportation?</h3>
                        <p>
                            Transportation accounts for about 24% of global CO₂ emissions. By understanding your 
                            travel patterns and making conscious choices, you can significantly reduce your carbon 
                            footprint while often saving money.
                        </p>
                    </div>
                    
                    <div class="info-section">
                        <h3>🚗 Emission Factors (India)</h3>
                        <div class="info-grid">
                            <div class="info-item">
                                <strong>Petrol Bike</strong>
                                <span>~0.06 kg CO₂/km</span>
                            </div>
                            <div class="info-item">
                                <strong>Petrol Car</strong>
                                <span>~0.17 kg CO₂/km</span>
                            </div>
                            <div class="info-item">
                                <strong>Diesel Car</strong>
                                <span>~0.15 kg CO₂/km</span>
                            </div>
                            <div class="info-item">
                                <strong>Electric Car</strong>
                                <span>~0.05 kg CO₂/km</span>
                            </div>
                            <div class="info-item">
                                <strong>Bus</strong>
                                <span>~0.03 kg CO₂/km</span>
                            </div>
                            <div class="info-item">
                                <strong>Metro/Train</strong>
                                <span>~0.02 kg CO₂/km</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="info-section">
                        <h3>🎯 Sustainability Benchmarks</h3>
                        <div class="info-item" style="margin-bottom: 0.75rem;">
                            <strong>Daily Target</strong>
                            <span>Below 5.0 kg CO₂ per day</span>
                        </div>
                        <div class="info-item">
                            <strong>Monthly Target</strong>
                            <span>Below 120 kg CO₂ per month</span>
                        </div>
                    </div>
                    
                    <div class="info-section">
                        <h3>🌱 Transport Context</h3>
                        <p>
                            <strong>Did you know?</strong><br>
                            • Switching to public transport saves ~2.5 kg CO₂ daily<br>
                            • EVs emit 60-70% less than petrol vehicles<br>
                            • Carpooling cuts per-person emissions by 50-75%<br>
                            • Walking/cycling = zero emissions + health benefits
                        </p>
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
        let tripCount = 1;
        
        function addTrip() {
            tripCount++;
            const container = document.getElementById('tripEntries');
            const newEntry = document.createElement('div');
            newEntry.className = 'trip-entry';
            newEntry.innerHTML = `
                <div class="trip-entry-header">
                    <strong>Trip #${tripCount}</strong>
                    <button type="button" class="btn btn-danger" onclick="removeTrip(this)">Remove</button>
                </div>
                <div class="trip-grid">
                    <div class="form-group">
                        <label>Transport Mode:</label>
                        <select name="mode[]" required>
                            <option value="">-- Select Mode --</option>
                            <option value="Bike / Scooter (Petrol)">Bike/Scooter (Petrol)</option>
                            <option value="Electric Two-Wheeler">Electric Two-Wheeler</option>
                            <option value="Car (Petrol)">Car (Petrol)</option>
                            <option value="Car (Diesel)">Car (Diesel)</option>
                            <option value="Car (CNG)">Car (CNG)</option>
                            <option value="Electric Car">Electric Car</option>
                            <option value="Auto Rickshaw">Auto Rickshaw</option>
                            <option value="Bus">Bus</option>
                            <option value="Metro / Local Train">Metro/Local Train</option>
                            <option value="Indian Railways">Indian Railways</option>
                            <option value="Flight (Domestic)">Flight (Domestic)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Distance (km):</label>
                        <input type="number" name="distance[]" step="0.1" min="0" placeholder="e.g., 10" required>
                    </div>
                </div>
            `;
            container.appendChild(newEntry);
        }
        
        function removeTrip(button) {
            button.closest('.trip-entry').remove();
        }
        
        // Form validation
        document.getElementById('transportForm').addEventListener('submit', function(e) {
            const routine = document.getElementById('routine').value;
            if (!routine) {
                e.preventDefault();
                alert('Please select a routine type');
            }
        });

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