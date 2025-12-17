<%@page import="model.User" %>
    <%@page import="model.Device" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <% User user=(User) request.getSession().getAttribute("user"); if (user==null) {
                response.sendRedirect("../UserServlet?action=invalid"); return; } Device device=(Device)
                request.getSession().getAttribute("singleDevice"); String posterUrl=device.getPoster_url(); String
                finalUrl=posterUrl.contains("images_device") ? ((HttpServletRequest) request).getContextPath() + "/" +
                posterUrl : posterUrl; %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <%= device.getName() %> - Manyung
                    </title>
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

                        .product-detail {
                            background: var(--white);
                            border-radius: var(--radius-2xl);
                            box-shadow: var(--shadow-md);
                            overflow: hidden;
                            max-width: 1000px;
                            margin: 0 auto;
                        }

                        .product-hero {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: var(--space-8);
                            padding: var(--space-8);
                        }

                        .product-image-container {
                            background: var(--neutral-100);
                            border-radius: var(--radius-xl);
                            overflow: hidden;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            padding: var(--space-6);
                        }

                        .product-image {
                            max-width: 100%;
                            max-height: 300px;
                            object-fit: contain;
                        }

                        .product-info h1 {
                            font-size: 1.75rem;
                            font-weight: 700;
                            color: var(--neutral-900);
                            line-height: 1.3;
                            margin-bottom: var(--space-4);
                        }

                        .product-brand {
                            display: inline-block;
                            padding: var(--space-1) var(--space-3);
                            background: var(--neutral-100);
                            color: var(--neutral-600);
                            border-radius: var(--radius-full);
                            font-size: 0.875rem;
                            font-weight: 500;
                            margin-bottom: var(--space-4);
                        }

                        .product-price {
                            font-size: 2rem;
                            font-weight: 700;
                            color: var(--primary-600);
                            margin-bottom: var(--space-4);
                        }

                        .product-category {
                            font-size: 0.9375rem;
                            color: var(--neutral-500);
                            margin-bottom: var(--space-6);
                        }

                        .btn-website {
                            display: inline-flex;
                            align-items: center;
                            gap: var(--space-2);
                            padding: var(--space-4) var(--space-6);
                            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                            color: var(--white);
                            font-size: 1rem;
                            font-weight: 600;
                            text-decoration: none;
                            border-radius: var(--radius-lg);
                            transition: all var(--transition-base);
                            box-shadow: 0 4px 14px rgba(220, 38, 38, 0.35);
                        }

                        .btn-website:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 20px rgba(220, 38, 38, 0.45);
                        }

                        /* Specifications Table */
                        .specs-section {
                            padding: var(--space-8);
                            border-top: 1px solid var(--neutral-100);
                        }

                        .specs-title {
                            font-size: 1.25rem;
                            font-weight: 600;
                            color: var(--neutral-900);
                            margin-bottom: var(--space-5);
                        }

                        .specs-table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        .specs-table tr {
                            border-bottom: 1px solid var(--neutral-100);
                        }

                        .specs-table tr:last-child {
                            border-bottom: none;
                        }

                        .specs-table th,
                        .specs-table td {
                            padding: var(--space-4);
                            text-align: left;
                        }

                        .specs-table th {
                            width: 200px;
                            font-weight: 600;
                            color: var(--neutral-700);
                            background: var(--neutral-50);
                        }

                        .specs-table td {
                            color: var(--neutral-600);
                            line-height: 1.6;
                        }

                        @media (max-width: 768px) {
                            .product-hero {
                                grid-template-columns: 1fr;
                            }

                            .specs-table th {
                                width: 120px;
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
                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                                            viewBox="0 0 24 24" stroke="currentColor">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                                        </svg>
                                        Back to Recommendations
                                    </a>

                                    <div class="product-detail">
                                        <div class="product-hero">
                                            <div class="product-image-container">
                                                <img src="<%= finalUrl %>" alt="<%= device.getName() %>"
                                                    class="product-image">
                                            </div>

                                            <div class="product-info">
                                                <span class="product-brand">
                                                    <%= device.getBrand() %>
                                                </span>
                                                <h1>
                                                    <%= device.getName() %>
                                                </h1>
                                                <p class="product-price">Rp <%= String.format("%,d", device.getPrice())
                                                        %>
                                                </p>
                                                <p class="product-category">Category: <%= device.getCategory() %>
                                                </p>

                                                <% if (device.getUrl() !=null && !device.getUrl().isEmpty()) { %>
                                                    <a href="<%= device.getUrl() %>" target="_blank" rel="noopener"
                                                        class="btn-website">
                                                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                            fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                            <path stroke-linecap="round" stroke-linejoin="round"
                                                                stroke-width="2"
                                                                d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                                                        </svg>
                                                        Visit Official Website
                                                    </a>
                                                    <% } %>
                                            </div>
                                        </div>

                                        <div class="specs-section">
                                            <h2 class="specs-title">Spesifikasi</h2>
                                            <table class="specs-table">
                                                <tr>
                                                    <th>Operating System</th>
                                                    <td>
                                                        <%= device.getOperatingSystem() !=null ?
                                                            device.getOperatingSystem() : "-" %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Processor</th>
                                                    <td>
                                                        <%= device.getProcessor() !=null ? device.getProcessor() : "-"
                                                            %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Memory (RAM)</th>
                                                    <td>
                                                        <%= device.getMemory() %> GB
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Graphics Card</th>
                                                    <td>
                                                        <%= device.getGraphicsCard() !=null ? device.getGraphicsCard()
                                                            : "-" %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Graphics Type</th>
                                                    <td>
                                                        <%= device.getGraphicsCardType() !=null ?
                                                            device.getGraphicsCardType() : "-" %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Storage</th>
                                                    <td>
                                                        <%= device.getStorage() !=null ? device.getStorage() : "-" %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Display</th>
                                                    <td>
                                                        <%= device.getDisplay() !=null ? device.getDisplay() : "-" %>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Battery</th>
                                                    <td>
                                                        <%= device.getBattery() !=null ? device.getBattery() : "-" %>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
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