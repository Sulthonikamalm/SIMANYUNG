<%@page import="model.User" %>
    <%@page import="java.util.List" %>
        <%@page import="model.Device" %>
            <%@page contentType="text/html" pageEncoding="UTF-8" %>
                <% User user=(User) request.getSession().getAttribute("user"); if (user==null) {
                    response.sendRedirect("../UserServlet?action=invalid"); return; } List<Device> devices = (List
                    <Device>) request.getSession().getAttribute("selectedDevices");
                        %>
                        <!DOCTYPE html>
                        <html lang="en">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Compare Devices - Manyung</title>
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                            <style>
                                .page-wrapper {
                                    min-height: 100vh;
                                    display: flex;
                                    flex-direction: column;
                                    background: var(--neutral-100);
                                }

                                .main-content {
                                    flex: 1;
                                    padding: var(--space-6);
                                }

                                .back-link {
                                    display: inline-flex;
                                    align-items: center;
                                    gap: var(--space-2);
                                    color: var(--neutral-600);
                                    font-size: 0.9375rem;
                                    text-decoration: none;
                                    margin-bottom: var(--space-6);
                                    transition: color var(--transition-fast);
                                }

                                .back-link:hover {
                                    color: var(--primary-600);
                                }

                                .compare-card {
                                    background: var(--white);
                                    border-radius: var(--radius-2xl);
                                    box-shadow: var(--shadow-md);
                                    overflow: hidden;
                                }

                                .compare-header {
                                    background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                                    padding: var(--space-6);
                                    text-align: center;
                                }

                                .compare-header h1 {
                                    font-size: 1.5rem;
                                    font-weight: 700;
                                    color: var(--white);
                                    margin: 0;
                                }

                                .compare-header p {
                                    color: rgba(255, 255, 255, 0.8);
                                    margin: var(--space-2) 0 0;
                                }

                                /* Products Row */
                                .products-row {
                                    display: grid;
                                    grid-template-columns: 180px repeat(<%=devices !=null ? devices.size() : 2 %>, 1fr);
                                    border-bottom: 1px solid var(--neutral-100);
                                }

                                .products-row.header {
                                    background: var(--neutral-50);
                                }

                                .product-header-cell {
                                    padding: var(--space-6);
                                    text-align: center;
                                    border-right: 1px solid var(--neutral-100);
                                }

                                .product-header-cell:last-child {
                                    border-right: none;
                                }

                                .product-image {
                                    width: 120px;
                                    height: 120px;
                                    object-fit: contain;
                                    margin: 0 auto var(--space-4);
                                    display: block;
                                }

                                .product-name {
                                    font-size: 0.9375rem;
                                    font-weight: 600;
                                    color: var(--neutral-900);
                                    margin-bottom: var(--space-2);
                                    line-height: 1.4;
                                }

                                .product-price {
                                    font-size: 1.125rem;
                                    font-weight: 700;
                                    color: var(--primary-600);
                                }

                                /* Specs Table */
                                .spec-row {
                                    display: grid;
                                    grid-template-columns: 180px repeat(<%=devices !=null ? devices.size() : 2 %>, 1fr);
                                    border-bottom: 1px solid var(--neutral-100);
                                }

                                .spec-row:last-child {
                                    border-bottom: none;
                                }

                                .spec-row:hover {
                                    background: var(--neutral-50);
                                }

                                .spec-label {
                                    padding: var(--space-4);
                                    font-weight: 600;
                                    color: var(--neutral-700);
                                    background: var(--neutral-50);
                                    border-right: 1px solid var(--neutral-100);
                                    font-size: 0.875rem;
                                }

                                .spec-value {
                                    padding: var(--space-4);
                                    color: var(--neutral-600);
                                    font-size: 0.875rem;
                                    line-height: 1.5;
                                    text-align: center;
                                    border-right: 1px solid var(--neutral-100);
                                }

                                .spec-value:last-child {
                                    border-right: none;
                                }

                                /* Empty State */
                                .empty-state {
                                    text-align: center;
                                    padding: var(--space-16);
                                }

                                .empty-state-title {
                                    font-size: 1.25rem;
                                    font-weight: 600;
                                    color: var(--neutral-700);
                                    margin-bottom: var(--space-3);
                                }

                                .empty-state-text {
                                    color: var(--neutral-500);
                                    margin-bottom: var(--space-6);
                                }

                                @media (max-width: 768px) {

                                    .products-row,
                                    .spec-row {
                                        grid-template-columns: 120px repeat(<%=devices !=null ? devices.size() : 2 %>, 1fr);
                                    }

                                    .product-image {
                                        width: 80px;
                                        height: 80px;
                                    }

                                    .spec-label,
                                    .spec-value {
                                        padding: var(--space-3);
                                        font-size: 0.8125rem;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <div class="page-wrapper">
                                <%@include file="header.jsp" %>

                                    <main class="main-content">
                                        <div class="container">
                                            <a href="${pageContext.request.contextPath}/Pages/rekomendasiDevice.jsp"
                                                class="back-link">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                    fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                                                </svg>
                                                Back to Recommendations
                                            </a>

                                            <div class="compare-card">
                                                <div class="compare-header">
                                                    <h1>Perbandingan Device</h1>
                                                    <p>Bandingkan spesifikasi secara berdampingan</p>
                                                </div>

                                                <% if (devices !=null && !devices.isEmpty()) { %>

                                                    <!-- Products Header -->
                                                    <div class="products-row header">
                                                        <div class="product-header-cell">
                                                            <p style="font-weight: 600; color: var(--neutral-700);">
                                                                Devices</p>
                                                        </div>
                                                        <% for (Device device : devices) { String
                                                            posterUrl=device.getPoster_url(); String
                                                            finalUrl=posterUrl.contains("images_device") ?
                                                            request.getContextPath() + "/" + posterUrl : posterUrl; %>
                                                            <div class="product-header-cell">
                                                                <img src="<%= finalUrl %>" alt="<%= device.getName() %>"
                                                                    class="product-image">
                                                                <p class="product-name">
                                                                    <%= device.getName() %>
                                                                </p>
                                                                <p class="product-price">Rp <%= String.format("%,d",
                                                                        device.getPrice()) %>
                                                                </p>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <!-- Specs -->
                                                    <div class="spec-row">
                                                        <div class="spec-label">Operating System</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getOperatingSystem() !=null ?
                                                                    device.getOperatingSystem() : "-" %>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <div class="spec-row">
                                                        <div class="spec-label">Processor</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getProcessor() !=null ? device.getProcessor()
                                                                    : "-" %>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <div class="spec-row">
                                                        <div class="spec-label">Memory (RAM)</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getMemory() %> GB
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <div class="spec-row">
                                                        <div class="spec-label">Graphics Card</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getGraphicsCard() !=null ?
                                                                    device.getGraphicsCard() : "-" %>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <div class="spec-row">
                                                        <div class="spec-label">Graphics Type</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getGraphicsCardType() !=null ?
                                                                    device.getGraphicsCardType() : "-" %>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <div class="spec-row">
                                                        <div class="spec-label">Storage</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getStorage() !=null ? device.getStorage()
                                                                    : "-" %>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <div class="spec-row">
                                                        <div class="spec-label">Display</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getDisplay() !=null ? device.getDisplay()
                                                                    : "-" %>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <div class="spec-row">
                                                        <div class="spec-label">Battery</div>
                                                        <% for (Device device : devices) { %>
                                                            <div class="spec-value">
                                                                <%= device.getBattery() !=null ? device.getBattery()
                                                                    : "-" %>
                                                            </div>
                                                            <% } %>
                                                    </div>

                                                    <% } else { %>

                                                        <div class="empty-state">
                                                            <h3 class="empty-state-title">Tidak Ada Device Dipilih</h3>
                                                            <p class="empty-state-text">Pilih 2-3 device dari halaman
                                                                rekomendasi untuk dibandingkan.</p>
                                                            <a href="${pageContext.request.contextPath}/UserServlet?action=rekomendasiDevice"
                                                                class="btn btn-primary">
                                                                Browse Devices
                                                            </a>
                                                        </div>

                                                        <% } %>
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