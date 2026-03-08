<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        %>
<%
    String userName = (String) session.getAttribute("userName");
    String from = request.getParameter("from");
    boolean showWelcomePopup = (userName != null && "signup".equals(from));
%>
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>EcoTrack - Carbon Footprint Tracker</title>
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
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
            margin: 0;
            background-color: #fff;
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
        .btn-white {
            background-color: #fff;
            color: var(--green-700);
        }
        .btn-white:hover { background-color: #f3f4f6; }

        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 50;
            transition: all 0.3s ease;
            background-color: transparent;
        }
        .header.scrolled {
            background-color: rgba(255, 255, 255, 0.9);
            -webkit-backdrop-filter: blur(10px);
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
        .mobile-menu-btn { display: none; background: none; border: none; cursor: pointer; }

        /* user profile on right */
        .user-profile {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-left: 1rem;
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

        .hero {
            position: relative;
            background-image: url('https://picsum.photos/seed/nature/1600/900');
            background-size: cover;
            background-position: center;
            color: #fff;
            padding-top: 12rem;
            padding-bottom: 8rem;
            text-align: center;
        }
        .hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background-color: rgba(0, 0, 0, 0.6);
        }
        .hero-content {
            position: relative;
            z-index: 10;
        }
        .hero h1 {
            font-size: 2.5rem;
            line-height: 1.2;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
        }
        .hero p {
            font-size: 1.125rem;
            max-width: 48rem;
            margin: 0 auto 2rem auto;
            color: #e5e7eb;
            text-shadow: 0 1px 3px rgba(0,0,0,0.5);
        }
        .hero .btn {
            font-size: 1.125rem;
            padding: 1rem 2rem;
        }

        section { padding: 5rem 0; }
        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }
        .section-header h2 {
            font-size: 2.25rem;
            margin-bottom: 1rem;
        }
        .section-header p {
            font-size: 1.125rem;
            color: var(--gray-600);
            max-width: 42rem;
            margin: 0 auto;
            line-height: 1.6;
        }

        .features { background-color: var(--gray-50); }
        .features-grid { display: grid; gap: 2rem; }

        /* wrapper link for clickable cards (logged-in only) */
        .feature-link {
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .feature-card {
            background-color: #fff;
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        .feature-link .feature-card {
            cursor: pointer;
        }
        .feature-card:hover {
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 8px 10px -6px rgba(0,0,0,0.1);
            transform: translateY(-0.5rem);
        }
        .feature-card .icon-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 4rem;
            width: 4rem;
            border-radius: 9999px;
            background-color: #d1fae5;
            margin-bottom: 1.5rem;
        }
        .feature-card .icon-wrapper svg {
            width: 2rem;
            height: 2rem;
            color: var(--green-600);
        }
        .feature-card h3 { font-size: 1.5rem; margin-bottom: 0.75rem; }
        .feature-card p { color: var(--gray-600); line-height: 1.6; }

        .how-it-works .steps-container { max-width: 56rem; margin: 0 auto; }
        .how-it-works .steps-grid { display: grid; gap: 3rem; }
        .step { position: relative; padding-left: 3.5rem; }
        .step-number {
            position: absolute;
            left: 0;
            top: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 2.5rem;
            width: 2.5rem;
            border-radius: 9999px;
            background-color: var(--green-600);
            color: #fff;
            font-size: 1.25rem;
            font-weight: 700;
        }
        .step h3 { font-size: 1.25rem; margin-bottom: 0.5rem; }
        .step p { color: var(--gray-600); line-height: 1.6; }

        .testimonials { background-color: var(--gray-50); }
        .testimonials-grid { display: grid; gap: 2rem; }
        .testimonial-card {
            background-color: #fff;
            padding: 2rem;
            border-radius: 0.75rem;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1);
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .testimonial-card img {
            width: 5rem;
            height: 5rem;
            border-radius: 9999px;
            margin-bottom: 1rem;
            border: 4px solid #a7f3d0;
        }
        .testimonial-card .quote {
            color: var(--gray-600);
            font-style: italic;
            margin-bottom: 1rem;
            line-height: 1.6;
        }
        .testimonial-card .author { margin-top: auto; }
        .testimonial-card .name {
            font-weight: 700;
            color: var(--gray-800);
        }
        .testimonial-card .title {
            font-size: 0.875rem;
            color: var(--green-600);
        }

        .cta {
            background-color: var(--green-700);
            color: #fff;
            text-align: center;
        }
        .cta .container { padding-top: 5rem; padding-bottom: 5rem; }
        .cta h2 {
            font-size: 2.25rem;
            margin-bottom: 1rem;
        }
        .cta p {
            font-size: 1.125rem;
            max-width: 48rem;
            margin: 0 auto 2rem auto;
            color: #d1fae5;
            line-height: 1.6;
        }
        .cta .btn {
            font-size: 1.125rem;
            padding: 1rem 2rem;
        }

        .footer {
            background-color: var(--gray-800);
            color: #d1d5db;
            padding-top: 3rem;
            padding-bottom: 3rem;
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

        @media (max-width: 767px) {
            .nav-links, .header .btn-green {
                display: none;
            }
            .mobile-menu-btn { display: block; }
        }
        @media (min-width: 768px) {
            .hero h1 { font-size: 3.75rem; }
            .hero p { font-size: 1.25rem; }
            .features-grid { grid-template-columns: repeat(3, 1fr); }
            .how-it-works .steps-grid { grid-template-columns: repeat(3, 1fr); }
            .testimonials-grid { grid-template-columns: repeat(3, 1fr); }
            .footer-grid { grid-template-columns: repeat(4, 1fr); }
            .footer .logo-column { grid-column: span 2; }
        }
        /* profile dropdown */
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

.profile-btn:focus {
    outline: none;
}

.profile-dropdown {
    position: absolute;
    right: 0;
    top: 120%;
    width: 220px;
    background-color: #fff;
    border-radius: 0.75rem;
    box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1),
                0 8px 10px -6px rgba(0,0,0,0.1);
    padding: 0.5rem 0;
    display: none;
    z-index: 60;
}

.profile-dropdown.open {
    display: block;
}

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
    transition: background-color 0.2s ease, color 0.2s ease;
}

.profile-item:hover {
    background-color: #f3f4f6;
}

.profile-item-danger {
    color: #b91c1c;
}

.profile-item-danger:hover {
    background-color: #fee2e2;
}

.profile-separator {
    height: 1px;
    background-color: #e5e7eb;
    margin: 0.25rem 0;
}

    </style>
</head>
<body>
    
    <header class="header" id="header">
      <div class="container">
        <a href="HomeServlet" class="logo">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="0.5">
            <path d="M17 8C8 10 5.5 17.5 9.5 22C15.5 18 18.5 11.5 17 8Z" />
            <path d="M15 2C13.3 4.8 11.2 7.3 9 9" />
          </svg>
          <span>EcoTrack</span>
        </a>
<nav class="nav-links">
<% if (userName == null) { %>
    <!-- Not logged in -->
    <a href="#features">Features</a>
    <a href="#how-it-works">How It Works</a>
    <a href="#testimonials">Testimonials</a>
<% } else { %>
    <!-- Logged in -->
    <a href="Transportation.jsp">Transportation</a>
    <a href="Food.jsp">Food</a>
    <a href="Energy.jsp">Energy</a>
<% } %>
</nav>


        <% if (userName == null) { %>
            <!-- Not logged in: show Get Started → login.jsp -->
            <a href="Login_Form.jsp" class="btn btn-green">
              Get Started
            </a>
            <% } else { %>
    <!-- Logged in: profile button + dropdown -->
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

            <!-- main items -->
            <a href="DashboardServlet" class="profile-item">Dashboard</a>
            <a href="ProgressServlet" class="profile-item">Progress</a>
            <a href="StreakServlet" class="profile-item">Streak</a>
            <a href="settings.jsp" class="profile-item">Settings</a>

            <div class="profile-separator"></div>

            <!-- logout -->
            <a href="LogoutServlet" class="profile-item profile-item-danger">
                Log out
            </a>
        </div>
    </div>
<% } %>


        <button class="mobile-menu-btn" aria-label="Open menu">
             <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2" style="width: 1.5rem; height: 1.5rem;">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16m-7 6h7" />
            </svg>
        </button>
      </div>
    </header>

    <main>
        <section class="hero" id="home">
            <div class="container hero-content">
                <h1>Understand & Reduce Your Carbon Footprint</h1>
                <p>Join the movement for a healthier planet. EcoTrack makes it simple to monitor your daily impact and discover sustainable alternatives.</p>
                <!-- Hero button -->
                <% if (userName == null) { %>
                    <a href="Login_Form.jsp" class="btn btn-green">Start Tracking for Free</a>
                <% } else { %>
                    <!-- Logged in: scroll to features/cards -->
                    <a href="#features" class="btn btn-green">Start Tracking for Free</a>
                <% } %>
            </div>
        </section>

        <section class="features" id="features">
            <div class="container">
                <div class="section-header">
                    <h2>Track What Matters Most</h2>
                    <p>Get a clear picture of your carbon emissions by focusing on the three key areas of your life.</p>
                </div>
                <div class="features-grid">

                    <!-- Transportation card -->
                    <% if (userName != null) { %>
                        <a href="Transportation.jsp" class="feature-link">
                    <% } %>
                        <div class="feature-card">
                            <div class="icon-wrapper">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                  <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C20.7 10.1 20 9 20 8c0-1.1-.9-2-2-2h-1" />
                                  <path d="M3 17h2" /><path d="M12 17h3" />
                                  <path d="M10 17H5.5c-1.4 0-2.5-1.1-2.5-2.5V12c0-1.4 1.1-2.5 2.5-2.5H12c1.4 0 2.5 1.1 2.5 2.5v2.5" />
                                  <circle cx="7.5" cy="17.5" r="2.5" /><circle cx="16.5" cy="17.5" r="2.5" />
                                </svg>
                            </div>
                            <h3>Transportation</h3>
                            <p>Log your travel by car, bus, plane, or bike to see how your commute and trips contribute to your footprint.</p>
                        </div>
                    <% if (userName != null) { %>
                        </a>
                    <% } %>

                    <!-- Food Consumption card -->
                    <% if (userName != null) { %>
                        <a href="Food.jsp" class="feature-link">
                    <% } %>
                        <div class="feature-card">
                            <div class="icon-wrapper">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                  <path d="M12 20.94c1.5 0 2.75 1.06 4 1.06 3 0 6-8 6-12.22A4.91 4.91 0 0 0 17 5c-2.22 0-4 1.44-5 2-1-.56-2.78-2-5-2a4.9 4.9 0 0 0-5 4.78C2 14 5 22 8 22c1.25 0 2.5-1.06 4-1.06Z"/>
                                  <path d="M10 2c1 .5 2 2 2 5"/>
                                </svg>
                            </div>
                            <h3>Food Consumption</h3>
                            <p>Understand the impact of your diet, from meat consumption to locally sourced produce, and find sustainable options.</p>
                        </div>
                    <% if (userName != null) { %>
                        </a>
                    <% } %>

                    <!-- Household Energy card -->
                    <% if (userName != null) { %>
                        <a href="Energy.jsp" class="feature-link">
                    <% } %>
                        <div class="feature-card">
                            <div class="icon-wrapper">
                                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                  <path d="M15 14c.2-1 .7-1.7 1.5-2.5C17.7 10.2 18 9 18 7.5c0-2.2-1.8-4-4-4-1.5 0-2.8.8-3.5 2-0.7-1.2-2-2-3.5-2-2.2 0-4 1.8-4 4 0 1.5.3 2.7 1.5 3.9.8.8 1.3 1.5 1.5 2.5" />
                                  <path d="M9 18h6" /><path d="M10 22h4" />
                                </svg>
                            </div>
                            <h3>Household Energy</h3>
                            <p>Monitor your electricity and heating usage to identify opportunities for conservation and renewable energy.</p>
                        </div>
                    <% if (userName != null) { %>
                        </a>
                    <% } %>

                </div>
            </div>
        </section>

        <section class="how-it-works" id="how-it-works">
            <div class="container">
                <div class="section-header">
                    <h2>Get Started in 3 Easy Steps</h2>
                    <p>Becoming carbon-conscious has never been easier. Follow these simple steps to begin your journey.</p>
                </div>
                <div class="steps-container">
                    <div class="steps-grid">
                        <div class="step">
                            <div class="step-number">1</div>
                            <h3>Create Your Profile</h3>
                            <p>Sign up for a free account in minutes. All we need is your name and email to get started.</p>
                        </div>
                        <div class="step">
                            <div class="step-number">2</div>
                            <h3>Log Your Activities</h3>
                            <p>Use our intuitive interface to easily input your daily transport, food, and energy data.</p>
                        </div>
                        <div class="step">
                            <div class="step-number">3</div>
                            <h3>Visualize Your Impact</h3>
                            <p>See your carbon footprint in real-time with beautiful charts and get personalized tips to reduce it.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="testimonials" id="testimonials">
            <div class="container">
                <div class="section-header">
                    <h2>Loved by Eco-Warriors Worldwide</h2>
                    <p>Don't just take our word for it. See what our users have to say about their journey with EcoTrack.</p>
                </div>
                <div class="testimonials-grid">
                    <div class="testimonial-card">
                        <img src="https://picsum.photos/seed/person1/100/100" alt="Sarah J.">
                        <p class="quote">"EcoTrack completely changed how I think about my daily choices. Seeing the numbers makes it real, and the tips are genuinely helpful!"</p>
                        <div class="author">
                            <div class="name">Sarah J.</div>
                            <div class="title">Urban Gardener</div>
                        </div>
                    </div>
                    <div class="testimonial-card">
                        <img src="https://picsum.photos/seed/person2/100/100" alt="Mike R.">
                        <p class="quote">"As a data-driven person, I love the charts and reports. It's motivating to see my footprint decrease over time. Highly recommended!"</p>
                        <div class="author">
                            <div class="name">Mike R.</div>
                            <div class="title">Software Engineer</div>
                        </div>
                    </div>
                    <div class="testimonial-card">
                        <img src="https://picsum.photos/seed/person3/100/100" alt="Chloe T.">
                        <p class="quote">"Finally, a carbon tracker that is easy to use and beautifully designed. It's become a daily habit for me and my family."</p>
                        <div class="author">
                            <div class="name">Chloe T.</div>
                            <div class="title">Small Business Owner</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <%-- CTA only when NOT logged in --%>
        <% if (userName == null) { %>
        <section class="cta" id="cta">
            <div class="container">
                <h2>Ready to Make a Difference?</h2>
                <p>Your journey towards a more sustainable lifestyle starts with a single step. Join thousands of others who are actively reducing their carbon footprint with EcoTrack.</p>
                <a href="Signup_Form.jsp" class="btn btn-white">Sign Up Now - It's Free!</a>
            </div>
        </section>
        <% } %>
    </main>
    
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
                        <li><a href="#features">Features</a></li>
                        <li><a href="#how-it-works">How It Works</a></li>
                        <li><a href="#testimonials">Testimonials</a></li>
                        <% if (userName == null) { %>
                            <li><a href="Signup_Form.jsp">Sign Up</a></li>
                        <% } %>
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
        const header = document.getElementById('header');
        window.addEventListener('scroll', () => {
            if (window.scrollY > 20) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    </script>

    <% if (showWelcomePopup) { %>
    <script>
        window.addEventListener('load', function () {
            alert('Welcome to EcoTrack, <%= userName %>!');
        });
    </script>
    <% } %>
    <script>
    const profileBtn = document.getElementById('profileBtn');
    const profileDropdown = document.getElementById('profileDropdown');

    if (profileBtn && profileDropdown) {
        // toggle on button click
        profileBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            profileDropdown.classList.toggle('open');
        });

        // close when clicking outside
        document.addEventListener('click', function () {
            profileDropdown.classList.remove('open');
        });

        // prevent closing when clicking inside the dropdown
        profileDropdown.addEventListener('click', function (e) {
            e.stopPropagation();
        });
    }
</script>


</body>
</html>
