<%@page import="model.User" %>
    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <% User user=(User) request.getSession().getAttribute("user"); if (user==null) {
            response.sendRedirect("../UserServlet?action=invalid"); return; } %>
            <!DOCTYPE html>
            <html lang="id">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Atur Preferensi - Manyung</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .page-wrapper {
                        min-height: 100vh;
                        display: flex;
                        flex-direction: column;
                    }

                    .main-content {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: var(--space-8);
                        background: linear-gradient(135deg, var(--neutral-100) 0%, var(--neutral-50) 100%);
                    }

                    .preference-card {
                        background: var(--white);
                        border-radius: var(--radius-2xl);
                        box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
                        width: 100%;
                        max-width: 520px;
                        overflow: hidden;
                    }

                    .preference-header {
                        background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                        padding: var(--space-10) var(--space-6);
                        text-align: center;
                        position: relative;
                    }

                    .preference-header::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
                    }

                    .preference-icon {
                        width: 80px;
                        height: 80px;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: var(--radius-full);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto var(--space-5);
                        position: relative;
                        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                    }

                    .preference-icon svg {
                        width: 40px;
                        height: 40px;
                        color: var(--white);
                    }

                    .preference-header h1 {
                        color: var(--white);
                        font-size: 1.75rem;
                        font-weight: 700;
                        margin-bottom: var(--space-2);
                        position: relative;
                    }

                    .preference-header p {
                        color: rgba(255, 255, 255, 0.85);
                        font-size: 1rem;
                        margin: 0;
                        position: relative;
                        line-height: 1.6;
                    }

                    .preference-body {
                        padding: var(--space-8) var(--space-6);
                    }

                    .form-group {
                        margin-bottom: var(--space-6);
                    }

                    .form-group:last-of-type {
                        margin-bottom: var(--space-8);
                    }

                    .form-label {
                        display: block;
                        font-size: 0.9375rem;
                        font-weight: 600;
                        color: var(--neutral-700);
                        margin-bottom: var(--space-2);
                    }

                    .form-hint {
                        font-size: 0.8125rem;
                        color: var(--neutral-500);
                        margin-top: var(--space-1);
                    }

                    .form-select {
                        width: 100%;
                        padding: var(--space-4);
                        font-size: 1rem;
                        color: var(--neutral-800);
                        background: var(--neutral-50);
                        border: 2px solid var(--neutral-200);
                        border-radius: var(--radius-lg);
                        cursor: pointer;
                        transition: all var(--transition-fast);
                        appearance: none;
                        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%23737373' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                        background-repeat: no-repeat;
                        background-position: right 12px center;
                        background-size: 20px;
                    }

                    .form-select:focus {
                        outline: none;
                        border-color: var(--primary-500);
                        background-color: var(--white);
                        box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1);
                    }

                    .btn-submit {
                        width: 100%;
                        padding: var(--space-4);
                        background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                        color: var(--white);
                        font-size: 1.0625rem;
                        font-weight: 600;
                        border: none;
                        border-radius: var(--radius-lg);
                        cursor: pointer;
                        transition: all var(--transition-base);
                        box-shadow: 0 10px 30px rgba(220, 38, 38, 0.35);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: var(--space-2);
                    }

                    .btn-submit:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 15px 40px rgba(220, 38, 38, 0.45);
                    }

                    .form-note {
                        text-align: center;
                        margin-top: var(--space-6);
                        font-size: 0.9375rem;
                        color: var(--neutral-500);
                    }

                    .form-note a {
                        color: var(--primary-600);
                        text-decoration: none;
                        font-weight: 600;
                    }

                    .form-note a:hover {
                        text-decoration: underline;
                    }
                </style>
            </head>

            <body>
                <div class="page-wrapper">
                    <%@include file="header.jsp" %>

                        <main class="main-content">
                            <div class="preference-card">
                                <div class="preference-header">
                                    <div class="preference-icon">
                                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                                            stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                                        </svg>
                                    </div>
                                    <h1>Atur Preferensimu</h1>
                                    <p>Kasih tau kami spesifikasi laptop yang kamu cari, <br>biar kami kasih rekomendasi
                                        terbaik!</p>
                                </div>

                                <div class="preference-body">
                                    <form action="${pageContext.request.contextPath}/UserServlet" method="post">
                                        <input type="hidden" name="action" value="InsertPreference">

                                        <div class="form-group">
                                            <label class="form-label" for="processor">Processor</label>
                                            <select id="processor" name="processor" class="form-select">
                                                <option value="i3">Intel Core i3 (Budget)</option>
                                                <option value="i5">Intel Core i5 (Mid-Range)</option>
                                                <option value="i7" selected>Intel Core i7 (High Performance)</option>
                                                <option value="i9">Intel Core i9 (Extreme)</option>
                                                <option value="Ryzen 3">AMD Ryzen 3 (Budget)</option>
                                                <option value="Ryzen 5">AMD Ryzen 5 (Mid-Range)</option>
                                                <option value="Ryzen 7">AMD Ryzen 7 (High Performance)</option>
                                                <option value="Ryzen 9">AMD Ryzen 9 (Extreme)</option>
                                            </select>
                                            <p class="form-hint">Pilih sesuai kebutuhan: i5/Ryzen 5 untuk office,
                                                i7/Ryzen 7 untuk gaming</p>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label" for="graphics">Graphics Card</label>
                                            <select id="graphics" name="graphics" class="form-select">
                                                <option value="Dedicated">Dedicated (Gaming/Creator)</option>
                                                <option value="Integrated">Integrated (Office/Mahasiswa)</option>
                                            </select>
                                            <p class="form-hint">Dedicated untuk gaming & editing, Integrated untuk
                                                kerja kantoran</p>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label" for="memory">Memory (RAM)</label>
                                            <select id="memory" name="memory" class="form-select">
                                                <option value="8">8 GB (Standard)</option>
                                                <option value="16" selected>16 GB (Recommended)</option>
                                                <option value="32">32 GB (Power User)</option>
                                            </select>
                                            <p class="form-hint">16 GB cocok untuk hampir semua kebutuhan sehari-hari
                                            </p>
                                        </div>

                                        <button type="submit" class="btn-submit">
                                            Find My Laptop
                                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                                                viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                                            </svg>
                                        </button>
                                    </form>

                                    <p class="form-note">
                                        Mau lihat semua device? <a
                                            href="${pageContext.request.contextPath}/UserServlet?action=rekomendasiDevice">Browse
                                            All Devices</a>
                                    </p>
                                </div>
                            </div>
                        </main>

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