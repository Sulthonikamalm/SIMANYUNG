<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manyung - Temukan Laptop Impianmu</title>
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

            /* Hero Section Override */
            .hero {
                padding: 100px 0 120px;
            }

            .hero-badge {
                display: inline-block;
                background: rgba(255, 255, 255, 0.2);
                color: var(--white);
                padding: var(--space-2) var(--space-4);
                border-radius: var(--radius-full);
                font-size: 0.875rem;
                font-weight: 500;
                margin-bottom: var(--space-5);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }

            .hero-title {
                font-size: 3.5rem;
                margin-bottom: var(--space-5);
                line-height: 1.1;
            }

            .hero-title span {
                background: linear-gradient(135deg, #fff 0%, #fecaca 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .hero-subtitle {
                font-size: 1.25rem;
                max-width: 540px;
                line-height: 1.8;
            }

            .hero-stats {
                display: flex;
                gap: var(--space-8);
                margin-top: var(--space-8);
                padding-top: var(--space-6);
                border-top: 1px solid rgba(255, 255, 255, 0.2);
            }

            .stat-item {
                text-align: left;
            }

            .stat-number {
                font-size: 2rem;
                font-weight: 800;
                color: var(--white);
            }

            .stat-label {
                font-size: 0.875rem;
                color: rgba(255, 255, 255, 0.8);
            }

            .hero-image img {
                max-width: 420px;
                filter: drop-shadow(0 30px 60px rgba(0, 0, 0, 0.3));
                animation: float 3s ease-in-out infinite;
            }

            @keyframes float {

                0%,
                100% {
                    transform: translateY(0);
                }

                50% {
                    transform: translateY(-15px);
                }
            }

            /* Features Section */
            .features {
                background: var(--white);
                padding: 100px 0;
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

            .section-heading {
                font-size: 2.5rem;
                color: var(--neutral-900);
                margin-bottom: var(--space-4);
                line-height: 1.2;
            }

            .section-subheading {
                color: var(--neutral-600);
                font-size: 1.125rem;
                max-width: 600px;
                margin: 0 auto var(--space-12);
            }

            .features-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
                gap: var(--space-8);
                max-width: 1100px;
                margin: 0 auto;
            }

            .feature-card {
                background: linear-gradient(135deg, var(--neutral-50) 0%, var(--white) 100%);
                border: 1px solid var(--neutral-200);
                border-radius: var(--radius-2xl);
                padding: var(--space-8);
                text-align: left;
                transition: all var(--transition-base);
                position: relative;
                overflow: hidden;
            }

            .feature-card::before {
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

            .feature-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
                border-color: var(--primary-200);
            }

            .feature-card:hover::before {
                opacity: 1;
            }

            .feature-icon {
                width: 64px;
                height: 64px;
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-500) 100%);
                border-radius: var(--radius-xl);
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: var(--space-5);
                box-shadow: 0 10px 30px rgba(220, 38, 38, 0.3);
            }

            .feature-icon svg {
                width: 32px;
                height: 32px;
                color: var(--white);
            }

            .feature-title {
                font-size: 1.25rem;
                font-weight: 700;
                color: var(--neutral-900);
                margin-bottom: var(--space-3);
            }

            .feature-desc {
                color: var(--neutral-600);
                line-height: 1.7;
                margin: 0;
                font-size: 0.9375rem;
            }

            /* CTA Section */
            .cta-section {
                background: linear-gradient(135deg, var(--neutral-900) 0%, var(--neutral-800) 100%);
                padding: 100px 0;
                text-align: center;
                position: relative;
                overflow: hidden;
            }

            .cta-section::before {
                content: '';
                position: absolute;
                top: -50%;
                left: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(220, 38, 38, 0.1) 0%, transparent 50%);
                animation: pulse-bg 4s ease-in-out infinite;
            }

            @keyframes pulse-bg {

                0%,
                100% {
                    transform: scale(1);
                    opacity: 0.5;
                }

                50% {
                    transform: scale(1.1);
                    opacity: 1;
                }
            }

            .cta-content {
                position: relative;
                z-index: 1;
            }

            .cta-title {
                font-size: 2.5rem;
                color: var(--white);
                margin-bottom: var(--space-4);
                line-height: 1.2;
            }

            .cta-text {
                color: var(--neutral-400);
                font-size: 1.25rem;
                margin-bottom: var(--space-8);
                max-width: 600px;
                margin-left: auto;
                margin-right: auto;
            }

            .btn-cta {
                display: inline-flex;
                align-items: center;
                gap: var(--space-3);
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-500) 100%);
                color: var(--white);
                padding: var(--space-5) var(--space-10);
                font-size: 1.125rem;
                font-weight: 600;
                border: none;
                border-radius: var(--radius-full);
                cursor: pointer;
                transition: all var(--transition-base);
                text-decoration: none;
                box-shadow: 0 10px 40px rgba(220, 38, 38, 0.4);
            }

            .btn-cta:hover {
                transform: translateY(-3px) scale(1.02);
                box-shadow: 0 15px 50px rgba(220, 38, 38, 0.5);
            }

            .btn-cta svg {
                transition: transform var(--transition-fast);
            }

            .btn-cta:hover svg {
                transform: translateX(4px);
            }

            /* Trust Section */
            .trust-section {
                background: var(--neutral-50);
                padding: var(--space-8) 0;
                text-align: center;
            }

            .trust-text {
                color: var(--neutral-500);
                font-size: 0.875rem;
                margin: 0;
            }

            @media (max-width: 1024px) {
                .hero-title {
                    font-size: 2.5rem;
                }

                .hero-stats {
                    justify-content: center;
                }
            }

            @media (max-width: 768px) {
                .hero {
                    padding: 60px 0 80px;
                }

                .hero-title {
                    font-size: 2rem;
                }

                .hero-stats {
                    flex-direction: column;
                    gap: var(--space-4);
                    align-items: center;
                }

                .stat-item {
                    text-align: center;
                }

                .section-heading {
                    font-size: 1.75rem;
                }

                .cta-title {
                    font-size: 1.75rem;
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
                        <a href="${pageContext.request.contextPath}/Pages/login.jsp" class="nav-link">Login</a>
                        <a href="${pageContext.request.contextPath}/Pages/registration.jsp"
                            class="btn btn-secondary btn-sm"
                            style="background: var(--white); color: var(--primary-600);">
                            Get Started
                        </a>
                    </div>
                </div>
            </nav>

            <main class="main-content">
                <!-- Hero Section -->
                <section class="hero">
                    <div class="container">
                        <div class="hero-container">
                            <div class="hero-content">
                                <span class="hero-badge">Rekomendasi Laptop Terbaik 2025</span>
                                <h1 class="hero-title">
                                    Temukan <span>Laptop Impianmu</span> dengan Mudah!
                                </h1>
                                <p class="hero-subtitle">
                                    Bingung pilih laptop? Tenang, kami bantu! Dapatkan rekomendasi laptop
                                    yang pas sesuai kebutuhanmu, entah kamu gamer, content creator,
                                    mahasiswa, atau profesional. Hemat waktu, hemat uang!
                                </p>
                                <div class="hero-actions">
                                    <a href="${pageContext.request.contextPath}/Pages/registration.jsp"
                                        class="btn btn-lg"
                                        style="background: var(--white); color: var(--primary-600); box-shadow: 0 10px 30px rgba(0,0,0,0.2);">
                                        Get Started Free
                                    </a>
                                    <a href="#features" class="btn btn-lg btn-outline"
                                        style="border-color: rgba(255,255,255,0.5); color: var(--white);">
                                        Learn More
                                    </a>
                                </div>
                            </div>
                            <div class="hero-image">
                                <img src="${pageContext.request.contextPath}/PagesAssets/laptop.png"
                                    alt="Laptop Illustration">
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Features Section -->
                <section class="features" id="features">
                    <div class="container">
                        <div class="text-center">
                            <span class="section-badge">Kenapa Harus Manyung?</span>
                            <h2 class="section-heading">
                                Cari Laptop Jadi Gampang Banget!
                            </h2>
                            <p class="section-subheading">
                                Nggak perlu pusing lagi riset berjam-jam. Kami sudah siapin semuanya buat kamu.
                            </p>
                        </div>

                        <div class="features-grid">
                            <div class="feature-card">
                                <div class="feature-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                        stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                                    </svg>
                                </div>
                                <h3 class="feature-title">Rekomendasi Cerdas</h3>
                                <p class="feature-desc">
                                    Sistem pintar kami menganalisis kebutuhanmu dan langsung kasih
                                    rekomendasi laptop yang paling cocok. Tinggal pilih, beres!
                                </p>
                            </div>

                            <div class="feature-card">
                                <div class="feature-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                        stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                                    </svg>
                                </div>
                                <h3 class="feature-title">Bandingkan Langsung</h3>
                                <p class="feature-desc">
                                    Mau bandingin 2-3 laptop sekaligus? Gampang! Lihat spesifikasi,
                                    harga, dan fitur dalam satu tampilan yang jelas dan mudah dipahami.
                                </p>
                            </div>

                            <div class="feature-card">
                                <div class="feature-icon">
                                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                        stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                </div>
                                <h3 class="feature-title">Harga Terbaik</h3>
                                <p class="feature-desc">
                                    Dapatkan laptop dengan performa maksimal sesuai budget kamu.
                                    Kami bantu cari yang paling worth it buat kantongmu!
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- CTA Section -->
                <section class="cta-section">
                    <div class="container">
                        <div class="cta-content">
                            <h2 class="cta-title">Siap Temukan Laptop Impianmu?</h2>
                            <p class="cta-text">
                                Ribuan pengguna sudah menemukan laptop ideal mereka dengan Manyung.
                                Giliran kamu sekarang!
                            </p>
                            <a href="${pageContext.request.contextPath}/Pages/registration.jsp" class="btn-cta">
                                Create Free Account
                                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none"
                                    viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 7l5 5m0 0l-5 5m5-5H6" />
                                </svg>
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