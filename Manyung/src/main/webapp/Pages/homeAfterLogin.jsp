<%@page import="model.Preference" %>
    <%@page import="dao.UserDAO" %>
        <%@page import="java.util.List" %>
            <%@page import="model.Device" %>
                <%@page import="model.User" %>
                    <%@page contentType="text/html" pageEncoding="UTF-8" %>
                        <!DOCTYPE html>
                        <% UserDAO userDAO=new UserDAO(); User user=(User) request.getSession().getAttribute("user"); if
                            (user==null) { response.sendRedirect("../UserServlet?action=invalid"); return; } int
                            id=user.getUser_id(); boolean validateAdmin=userDAO.validateAdmin(user.getEmail(),
                            user.getPassword()); Preference preference=user.getPreference(); String
                            username=user.getUsername(); %>
                            <html lang="id">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Dashboard - Manyung</title>
                                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                                <style>
                                    .page-wrapper {
                                        min-height: 100vh;
                                        display: flex;
                                        flex-direction: column;
                                    }

                                    .main-content {
                                        flex: 1;
                                    }

                                    /* Welcome Section */
                                    .welcome-section {
                                        background: linear-gradient(135deg, var(--primary-700) 0%, var(--primary-500) 50%, var(--primary-300) 100%);
                                        padding: 100px 0;
                                        position: relative;
                                        overflow: hidden;
                                    }

                                    .welcome-section::before {
                                        content: '';
                                        position: absolute;
                                        top: 0;
                                        left: 0;
                                        right: 0;
                                        bottom: 0;
                                        background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
                                    }

                                    .welcome-container {
                                        display: flex;
                                        align-items: center;
                                        gap: var(--space-12);
                                        position: relative;
                                        z-index: 1;
                                    }

                                    .welcome-avatar {
                                        width: 140px;
                                        height: 140px;
                                        background: rgba(255, 255, 255, 0.2);
                                        border-radius: var(--radius-full);
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        border: 4px solid rgba(255, 255, 255, 0.3);
                                        flex-shrink: 0;
                                        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
                                    }

                                    .welcome-avatar svg {
                                        width: 70px;
                                        height: 70px;
                                        color: var(--white);
                                    }

                                    .welcome-content {
                                        flex: 1;
                                    }

                                    .welcome-badge {
                                        display: inline-block;
                                        background: rgba(255, 255, 255, 0.2);
                                        color: var(--white);
                                        padding: var(--space-2) var(--space-4);
                                        border-radius: var(--radius-full);
                                        font-size: 0.875rem;
                                        font-weight: 500;
                                        margin-bottom: var(--space-4);
                                        backdrop-filter: blur(10px);
                                    }

                                    .welcome-name {
                                        font-size: 3rem;
                                        font-weight: 800;
                                        color: var(--white);
                                        margin-bottom: var(--space-3);
                                        line-height: 1.1;
                                    }

                                    .welcome-text {
                                        font-size: 1.25rem;
                                        color: rgba(255, 255, 255, 0.9);
                                        margin-bottom: var(--space-8);
                                        max-width: 500px;
                                        line-height: 1.7;
                                    }

                                    .welcome-actions {
                                        display: flex;
                                        gap: var(--space-4);
                                        flex-wrap: wrap;
                                    }

                                    .btn-hero {
                                        padding: var(--space-4) var(--space-6);
                                        font-size: 1rem;
                                        font-weight: 600;
                                        border: none;
                                        border-radius: var(--radius-lg);
                                        cursor: pointer;
                                        transition: all var(--transition-base);
                                        text-decoration: none;
                                        display: inline-flex;
                                        align-items: center;
                                        gap: var(--space-2);
                                    }

                                    .btn-hero-primary {
                                        background: var(--white);
                                        color: var(--primary-600);
                                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                                    }

                                    .btn-hero-primary:hover {
                                        transform: translateY(-3px);
                                        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.25);
                                    }

                                    .btn-hero-secondary {
                                        background: rgba(255, 255, 255, 0.15);
                                        color: var(--white);
                                        border: 2px solid rgba(255, 255, 255, 0.3);
                                    }

                                    .btn-hero-secondary:hover {
                                        background: rgba(255, 255, 255, 0.25);
                                    }

                                    .btn-hero-logout {
                                        background: transparent;
                                        color: rgba(255, 255, 255, 0.8);
                                        border: none;
                                        padding: var(--space-4) var(--space-5);
                                    }

                                    .btn-hero-logout:hover {
                                        color: var(--white);
                                    }

                                    /* Quick Actions Section */
                                    .quick-actions {
                                        padding: 80px 0;
                                        background: var(--white);
                                    }

                                    .section-badge {
                                        display: inline-block;
                                        background: var(--primary-100);
                                        color: var(--primary-700);
                                        padding: var(--space-2) var(--space-4);
                                        border-radius: var(--radius-full);
                                        font-size: 0.875rem;
                                        font-weight: 600;
                                        margin-bottom: var(--space-4);
                                    }

                                    .section-title {
                                        font-size: 2rem;
                                        font-weight: 700;
                                        color: var(--neutral-900);
                                        margin-bottom: var(--space-3);
                                    }

                                    .section-subtitle {
                                        color: var(--neutral-500);
                                        font-size: 1.0625rem;
                                        margin-bottom: var(--space-10);
                                    }

                                    .actions-grid {
                                        display: grid;
                                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                                        gap: var(--space-6);
                                        max-width: 1000px;
                                        margin: 0 auto;
                                    }

                                    .action-card {
                                        background: linear-gradient(135deg, var(--neutral-50) 0%, var(--white) 100%);
                                        border: 1px solid var(--neutral-200);
                                        border-radius: var(--radius-2xl);
                                        padding: var(--space-8);
                                        text-align: center;
                                        transition: all var(--transition-base);
                                        text-decoration: none;
                                        display: block;
                                        position: relative;
                                        overflow: hidden;
                                    }

                                    .action-card::before {
                                        content: '';
                                        position: absolute;
                                        top: 0;
                                        left: 0;
                                        right: 0;
                                        height: 4px;
                                        background: linear-gradient(90deg, var(--primary-500) 0%, var(--primary-300) 100%);
                                        opacity: 0;
                                        transition: opacity var(--transition-base);
                                    }

                                    .action-card:hover {
                                        border-color: var(--primary-200);
                                        background: var(--primary-50);
                                        transform: translateY(-8px);
                                        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                                    }

                                    .action-card:hover::before {
                                        opacity: 1;
                                    }

                                    .action-icon {
                                        width: 72px;
                                        height: 72px;
                                        background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-500) 100%);
                                        border-radius: var(--radius-2xl);
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        margin: 0 auto var(--space-5);
                                        box-shadow: 0 10px 30px rgba(220, 38, 38, 0.3);
                                    }

                                    .action-icon svg {
                                        width: 36px;
                                        height: 36px;
                                        color: var(--white);
                                    }

                                    .action-title {
                                        font-size: 1.25rem;
                                        font-weight: 700;
                                        color: var(--neutral-900);
                                        margin-bottom: var(--space-2);
                                    }

                                    .action-desc {
                                        font-size: 0.9375rem;
                                        color: var(--neutral-500);
                                        margin: 0;
                                        line-height: 1.6;
                                    }

                                    /* Hide elements based on user type */
                                    <% if (validateAdmin) {
                                        %>.customer-only {
                                            display: none !important;
                                        }

                                        <%
                                    }

                                    %><% if (preference==null) {
                                        %>.has-preference {
                                            display: none !important;
                                        }

                                        <%
                                    }

                                    %>@media (max-width: 768px) {
                                        .welcome-container {
                                            flex-direction: column;
                                            text-align: center;
                                        }

                                        .welcome-name {
                                            font-size: 2rem;
                                        }

                                        .welcome-text {
                                            margin-left: auto;
                                            margin-right: auto;
                                        }

                                        .welcome-actions {
                                            justify-content: center;
                                        }
                                    }
                                </style>
                            </head>

                            <body>
                                <div class="page-wrapper">
                                    <!-- Navigation -->
                                    <nav class="navbar">
                                        <div class="navbar-container">
                                            <div class="navbar-brand">
                                                <span class="navbar-logo">Manyung</span>
                                            </div>
                                            <div class="navbar-nav">
                                                <a href="${pageContext.request.contextPath}/Pages/homeAfterLogin.jsp"
                                                    class="nav-link">Dashboard</a>
                                                <% if (!validateAdmin) { %>
                                                    <a href="${pageContext.request.contextPath}/UserServlet?action=rekomendasiDevice"
                                                        class="nav-link has-preference">Devices</a>
                                                    <% } %>
                                            </div>
                                        </div>
                                    </nav>

                                    <main class="main-content">
                                        <!-- Welcome Section -->
                                        <section class="welcome-section">
                                            <div class="container">
                                                <div class="welcome-container">
                                                    <div class="welcome-avatar">
                                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                            viewBox="0 0 24 24" stroke="currentColor">
                                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                                stroke-width="1.5"
                                                                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                                        </svg>
                                                    </div>
                                                    <div class="welcome-content">
                                                        <span class="welcome-badge">Selamat Datang Kembali</span>
                                                        <h1 class="welcome-name">Hai, <%= username %>!</h1>
                                                        <p class="welcome-text">
                                                            Siap menemukan laptop impianmu hari ini? Yuk, mulai
                                                            eksplorasi
                                                            dan temukan device yang paling cocok buat kebutuhanmu!
                                                        </p>
                                                        <div class="welcome-actions">
                                                            <a href="${pageContext.request.contextPath}/Pages/Rekomendasi.jsp"
                                                                class="btn-hero btn-hero-primary customer-only">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="20"
                                                                    height="20" fill="none" viewBox="0 0 24 24"
                                                                    stroke="currentColor">
                                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                                        stroke-width="2"
                                                                        d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                                                                </svg>
                                                                Set Preferences
                                                            </a>

                                                            <a href="${pageContext.request.contextPath}/UserServlet?action=rekomendasiDevice"
                                                                class="btn-hero btn-hero-secondary customer-only has-preference">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="20"
                                                                    height="20" fill="none" viewBox="0 0 24 24"
                                                                    stroke="currentColor">
                                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                                        stroke-width="2"
                                                                        d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                                                                </svg>
                                                                View Recommendations
                                                            </a>

                                                            <form
                                                                action="${pageContext.request.contextPath}/UserServlet"
                                                                method="get" style="margin: 0;">
                                                                <button type="submit" name="action" value="logout"
                                                                    class="btn-hero btn-hero-logout">
                                                                    Sign Out
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </section>

                                        <!-- Quick Actions -->
                                        <section class="quick-actions customer-only">
                                            <div class="container text-center">
                                                <span class="section-badge">Menu Cepat</span>
                                                <h2 class="section-title">Mau ngapain hari ini?</h2>
                                                <p class="section-subtitle">Pilih menu di bawah untuk mulai eksplorasi
                                                </p>

                                                <div class="actions-grid">
                                                    <a href="${pageContext.request.contextPath}/Pages/Rekomendasi.jsp"
                                                        class="action-card">
                                                        <div class="action-icon">
                                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                                viewBox="0 0 24 24" stroke="currentColor">
                                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                                    stroke-width="2"
                                                                    d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                                                            </svg>
                                                        </div>
                                                        <h3 class="action-title">Atur Preferensi</h3>
                                                        <p class="action-desc">Kasih tau kami spesifikasi laptop
                                                            idamanmu</p>
                                                    </a>

                                                    <a href="${pageContext.request.contextPath}/UserServlet?action=rekomendasiDevice"
                                                        class="action-card has-preference">
                                                        <div class="action-icon">
                                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                                viewBox="0 0 24 24" stroke="currentColor">
                                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                                    stroke-width="2"
                                                                    d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                                                            </svg>
                                                        </div>
                                                        <h3 class="action-title">Lihat Rekomendasi</h3>
                                                        <p class="action-desc">Cek laptop yang cocok dengan kebutuhanmu
                                                        </p>
                                                    </a>

                                                    <a href="${pageContext.request.contextPath}/UserServlet?action=filterByCategory&category=Gaming"
                                                        class="action-card has-preference">
                                                        <div class="action-icon">
                                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none"
                                                                viewBox="0 0 24 24" stroke="currentColor">
                                                                <path stroke-linecap="round" stroke-linejoin="round"
                                                                    stroke-width="2"
                                                                    d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
                                                            </svg>
                                                        </div>
                                                        <h3 class="action-title">Jelajahi Kategori</h3>
                                                        <p class="action-desc">Gaming, Office, Creator, dan lainnya</p>
                                                    </a>
                                                </div>
                                            </div>
                                        </section>
                                    </main>

                                    <!-- Footer -->
                                    <footer class="footer">
                                        <div class="container">
                                            <div class="footer-content">
                                                <p class="footer-logo">Manyung</p>
                                                <p class="footer-text">2025 Manyung. All rights reserved.</p>
                                            </div>
                                        </div>
                                    </footer>
                                </div>
                            </body>

                            </html>