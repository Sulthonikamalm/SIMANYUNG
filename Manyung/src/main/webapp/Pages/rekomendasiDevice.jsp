<%@page import="dao.UserDAO" %>
    <%@page import="model.User" %>
        <%@page import="java.util.ArrayList" %>
            <%@page import="java.util.List" %>
                <%@page import="model.Device" %>
                    <%@page contentType="text/html" pageEncoding="UTF-8" %>
                        <!DOCTYPE html>
                        <% User user=(User) request.getSession().getAttribute("user"); if (user==null) {
                            response.sendRedirect("../UserServlet?action=invalid"); return; } UserDAO userDAO=new
                            UserDAO(); boolean validateAdmin=userDAO.validateAdmin(user.getEmail(), user.getPassword());
                            List<Device> displayDevices = (List<Device>)
                                request.getSession().getAttribute("displayDevice");
                                %>
                                <html lang="en">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Device Recommendations - Manyung</title>
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

                                        .content-layout {
                                            display: grid;
                                            grid-template-columns: 280px 1fr;
                                            gap: var(--space-6);
                                            max-width: 1400px;
                                            margin: 0 auto;
                                        }

                                        /* Sidebar/Filter */
                                        .filter-sidebar {
                                            position: sticky;
                                            top: calc(70px + var(--space-6));
                                            height: fit-content;
                                        }

                                        .filter-card {
                                            background: var(--white);
                                            border-radius: var(--radius-xl);
                                            box-shadow: var(--shadow-sm);
                                            overflow: hidden;
                                        }

                                        .filter-header {
                                            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                                            color: var(--white);
                                            padding: var(--space-4) var(--space-5);
                                            font-weight: 600;
                                            font-size: 1rem;
                                        }

                                        .filter-body {
                                            padding: var(--space-4);
                                        }

                                        .filter-section-title {
                                            font-size: 0.75rem;
                                            font-weight: 600;
                                            color: var(--neutral-500);
                                            text-transform: uppercase;
                                            letter-spacing: 0.05em;
                                            margin-bottom: var(--space-3);
                                        }

                                        .filter-list {
                                            list-style: none;
                                            display: flex;
                                            flex-direction: column;
                                            gap: var(--space-2);
                                        }

                                        .filter-btn {
                                            width: 100%;
                                            padding: var(--space-3) var(--space-4);
                                            background: var(--neutral-50);
                                            color: var(--neutral-700);
                                            border: 1px solid var(--neutral-200);
                                            border-radius: var(--radius-lg);
                                            font-size: 0.9375rem;
                                            font-weight: 500;
                                            cursor: pointer;
                                            text-align: left;
                                            transition: all var(--transition-fast);
                                        }

                                        .filter-btn:hover {
                                            background: var(--primary-50);
                                            border-color: var(--primary-200);
                                            color: var(--primary-700);
                                        }

                                        .filter-btn.active {
                                            background: var(--primary-600);
                                            border-color: var(--primary-600);
                                            color: var(--white);
                                        }

                                        /* Main Content */
                                        .devices-section {
                                            min-width: 0;
                                        }

                                        .section-header {
                                            display: flex;
                                            align-items: center;
                                            justify-content: space-between;
                                            margin-bottom: var(--space-5);
                                            flex-wrap: wrap;
                                            gap: var(--space-4);
                                        }

                                        .section-title {
                                            font-size: 1.5rem;
                                            font-weight: 700;
                                            color: var(--neutral-900);
                                        }

                                        .section-subtitle {
                                            font-size: 0.875rem;
                                            color: var(--neutral-500);
                                            margin-top: var(--space-1);
                                        }

                                        .btn-back {
                                            display: inline-flex;
                                            align-items: center;
                                            gap: var(--space-2);
                                            padding: var(--space-2) var(--space-4);
                                            background: var(--neutral-200);
                                            color: var(--neutral-700);
                                            border: none;
                                            border-radius: var(--radius-lg);
                                            font-size: 0.875rem;
                                            font-weight: 500;
                                            cursor: pointer;
                                            text-decoration: none;
                                            transition: all var(--transition-fast);
                                        }

                                        .btn-back:hover {
                                            background: var(--neutral-300);
                                        }

                                        /* Compare Bar */
                                        .compare-bar {
                                            background: var(--white);
                                            border-radius: var(--radius-xl);
                                            padding: var(--space-4) var(--space-5);
                                            margin-bottom: var(--space-5);
                                            display: flex;
                                            align-items: center;
                                            justify-content: space-between;
                                            box-shadow: var(--shadow-sm);
                                        }

                                        .compare-info {
                                            font-size: 0.9375rem;
                                            color: var(--neutral-600);
                                        }

                                        .compare-count {
                                            font-weight: 600;
                                            color: var(--primary-600);
                                        }

                                        .btn-compare {
                                            padding: var(--space-3) var(--space-5);
                                            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                                            color: var(--white);
                                            border: none;
                                            border-radius: var(--radius-lg);
                                            font-weight: 600;
                                            cursor: pointer;
                                            transition: all var(--transition-base);
                                        }

                                        .btn-compare:hover:not(:disabled) {
                                            transform: translateY(-2px);
                                            box-shadow: 0 4px 14px rgba(220, 38, 38, 0.35);
                                        }

                                        .btn-compare:disabled {
                                            opacity: 0.5;
                                            cursor: not-allowed;
                                        }

                                        /* Products Grid */
                                        .products-grid {
                                            display: grid;
                                            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
                                            gap: var(--space-5);
                                        }

                                        .product-card {
                                            background: var(--white);
                                            border-radius: var(--radius-xl);
                                            overflow: hidden;
                                            box-shadow: var(--shadow-sm);
                                            transition: all var(--transition-base);
                                            position: relative;
                                        }

                                        .product-card:hover {
                                            transform: translateY(-4px);
                                            box-shadow: var(--shadow-lg);
                                        }

                                        .product-image {
                                            width: 100%;
                                            height: 180px;
                                            object-fit: cover;
                                            background: var(--neutral-100);
                                        }

                                        .product-body {
                                            padding: var(--space-4);
                                        }

                                        .product-name {
                                            font-size: 0.9375rem;
                                            font-weight: 600;
                                            color: var(--neutral-900);
                                            margin-bottom: var(--space-2);
                                            line-height: 1.4;
                                            display: -webkit-box;
                                            -webkit-line-clamp: 2;
                                            -webkit-box-orient: vertical;
                                            overflow: hidden;
                                            height: 2.8em;
                                        }

                                        .product-price {
                                            font-size: 1.125rem;
                                            font-weight: 700;
                                            color: var(--primary-600);
                                            margin-bottom: var(--space-4);
                                        }

                                        .product-actions {
                                            display: flex;
                                            flex-direction: column;
                                            gap: var(--space-3);
                                        }

                                        .btn-details {
                                            padding: var(--space-3);
                                            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                                            color: var(--white);
                                            border: none;
                                            border-radius: var(--radius-lg);
                                            font-size: 0.875rem;
                                            font-weight: 500;
                                            cursor: pointer;
                                            text-align: center;
                                            text-decoration: none;
                                            transition: all var(--transition-fast);
                                        }

                                        .btn-details:hover {
                                            transform: translateY(-1px);
                                        }

                                        .compare-checkbox-label {
                                            display: flex;
                                            align-items: center;
                                            gap: var(--space-2);
                                            padding: var(--space-2);
                                            background: var(--neutral-50);
                                            border-radius: var(--radius-md);
                                            cursor: pointer;
                                            font-size: 0.875rem;
                                            color: var(--neutral-600);
                                            transition: all var(--transition-fast);
                                        }

                                        .compare-checkbox-label:hover {
                                            background: var(--primary-50);
                                            color: var(--primary-700);
                                        }

                                        .compare-checkbox-label input {
                                            width: 18px;
                                            height: 18px;
                                            accent-color: var(--primary-600);
                                        }

                                        /* Empty State */
                                        .empty-state {
                                            text-align: center;
                                            padding: var(--space-16);
                                            background: var(--white);
                                            border-radius: var(--radius-xl);
                                        }

                                        .empty-state-title {
                                            font-size: 1.25rem;
                                            font-weight: 600;
                                            color: var(--neutral-700);
                                            margin-bottom: var(--space-2);
                                        }

                                        .empty-state-text {
                                            color: var(--neutral-500);
                                        }

                                        /* Query Info */
                                        .query-info {
                                            background: var(--info-100);
                                            color: #1e40af;
                                            padding: var(--space-3) var(--space-4);
                                            border-radius: var(--radius-lg);
                                            font-size: 0.875rem;
                                            margin-bottom: var(--space-5);
                                        }

                                        <% if (validateAdmin) {
                                            %>.customer-only {
                                                display: none !important;
                                            }

                                            <%
                                        }

                                        %>@media (max-width: 1024px) {
                                            .content-layout {
                                                grid-template-columns: 1fr;
                                            }

                                            .filter-sidebar {
                                                position: static;
                                            }

                                            .filter-list {
                                                flex-direction: row;
                                                flex-wrap: wrap;
                                            }

                                            .filter-btn {
                                                width: auto;
                                            }
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="page-wrapper">
                                        <%@include file="header.jsp" %>

                                            <main class="main-content">
                                                <div class="content-layout">
                                                    <!-- Filter Sidebar -->
                                                    <aside class="filter-sidebar">
                                                        <div class="filter-card">
                                                            <div class="filter-header">Filter Devices</div>
                                                            <div class="filter-body">
                                                                <p class="filter-section-title">Categories</p>
                                                                <ul class="filter-list">
                                                                    <li>
                                                                        <button class="filter-btn"
                                                                            onclick="window.location.href='${pageContext.request.contextPath}/UserServlet?action=filterByCategory&category=Gaming'">
                                                                            Gaming
                                                                        </button>
                                                                    </li>
                                                                    <li>
                                                                        <button class="filter-btn"
                                                                            onclick="window.location.href='${pageContext.request.contextPath}/UserServlet?action=filterByCategory&category=Office'">
                                                                            Office
                                                                        </button>
                                                                    </li>
                                                                    <li>
                                                                        <button class="filter-btn"
                                                                            onclick="window.location.href='${pageContext.request.contextPath}/UserServlet?action=filterByCategory&category=Students'">
                                                                            Students
                                                                        </button>
                                                                    </li>
                                                                    <li>
                                                                        <button class="filter-btn"
                                                                            onclick="window.location.href='${pageContext.request.contextPath}/UserServlet?action=filterByCategory&category=Creators'">
                                                                            Creators
                                                                        </button>
                                                                    </li>
                                                                    <li>
                                                                        <button class="filter-btn"
                                                                            onclick="window.location.href='${pageContext.request.contextPath}/UserServlet?action=filterByCategory&category=Home'">
                                                                            Home
                                                                        </button>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </aside>

                                                    <!-- Devices Section -->
                                                    <section class="devices-section">
                                                        <div class="section-header">
                                                            <div>
                                                                <h1 class="section-title">
                                                                    <% if (validateAdmin) { %>
                                                                        Browse All Devices
                                                                        <% } else { %>
                                                                            Rekomendasi Untukmu
                                                                            <% } %>
                                                                </h1>
                                                                <p class="section-subtitle">Harga dalam Rupiah (IDR)</p>
                                                            </div>
                                                            <a href="${pageContext.request.contextPath}/Pages/Rekomendasi.jsp"
                                                                class="btn-back customer-only">
                                                                <svg xmlns="http://www.w3.org/2000/svg" width="16"
                                                                    height="16" fill="none" viewBox="0 0 24 24"
                                                                    stroke="currentColor">
                                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                                        stroke-width="2"
                                                                        d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                                                                </svg>
                                                                Back to Preferences
                                                            </a>
                                                        </div>

                                                        <% if (request.getParameter("Query") !=null) { %>
                                                            <div class="query-info">
                                                                Showing results for: "<strong>
                                                                    <%= request.getParameter("Query") %>
                                                                </strong>"
                                                            </div>
                                                            <% } else if (request.getParameter("Filter") !=null) { %>
                                                                <div class="query-info">
                                                                    Filtered by: <strong>
                                                                        <%= request.getParameter("Filter") %>
                                                                    </strong>
                                                                </div>
                                                                <% } else if (request.getParameter("Preference") !=null)
                                                                    { %>
                                                                    <div class="query-info">
                                                                        <%= request.getParameter("Preference") %>
                                                                    </div>
                                                                    <% } %>

                                                                        <% if (displayDevices==null ||
                                                                            displayDevices.isEmpty()) { %>
                                                                            <div class="empty-state">
                                                                                <h3 class="empty-state-title">Tidak Ada
                                                                                    Device
                                                                                    Ditemukan</h3>
                                                                                <p class="empty-state-text">
                                                                                    <% if (request.getParameter("error")
                                                                                        !=null) { %>
                                                                                        <%= request.getParameter("error")
                                                                                            %>
                                                                                            <% } else { %>
                                                                                                Coba sesuaikan filter
                                                                                                atau
                                                                                                kriteria pencarianmu
                                                                                                <% } %>
                                                                                </p>
                                                                            </div>
                                                                            <% } else { %>

                                                                                <form
                                                                                    action="${pageContext.request.contextPath}/UserServlet"
                                                                                    method="get" id="compareForm">
                                                                                    <input type="hidden" name="action"
                                                                                        value="compareDevices">
                                                                                    <div id="selectedDevices"></div>

                                                                                    <!-- Compare Bar -->
                                                                                    <div class="compare-bar">
                                                                                        <p class="compare-info">
                                                                                            Pilih <span
                                                                                                class="compare-count"
                                                                                                id="compareCount">0</span>
                                                                                            dari 2-3 device untuk
                                                                                            dibandingkan
                                                                                        </p>
                                                                                        <button type="submit"
                                                                                            class="btn-compare"
                                                                                            id="compareBtn" disabled>
                                                                                            Compare Selected
                                                                                        </button>
                                                                                    </div>

                                                                                    <div class="products-grid">
                                                                                        <% for (Device device :
                                                                                            displayDevices) { String
                                                                                            posterUrl=device.getPoster_url();
                                                                                            String
                                                                                            finalUrl=posterUrl.contains("images_device")
                                                                                            ? request.getContextPath()
                                                                                            + "/" + posterUrl :
                                                                                            posterUrl; %>
                                                                                            <div class="product-card">
                                                                                                <img src="<%= finalUrl %>"
                                                                                                    alt="<%= device.getName() %>"
                                                                                                    class="product-image">
                                                                                                <div
                                                                                                    class="product-body">
                                                                                                    <h3
                                                                                                        class="product-name">
                                                                                                        <%= device.getName()
                                                                                                            %>
                                                                                                    </h3>
                                                                                                    <p
                                                                                                        class="product-price">
                                                                                                        Rp <%=
                                                                                                            String.format("%,d",
                                                                                                            device.getPrice())
                                                                                                            %>
                                                                                                    </p>
                                                                                                    <div
                                                                                                        class="product-actions">
                                                                                                        <a href="${pageContext.request.contextPath}/UserServlet?action=showDevices&idDevices=<%= device.getDeviceId() %>"
                                                                                                            class="btn-details">
                                                                                                            View Details
                                                                                                        </a>
                                                                                                        <label
                                                                                                            class="compare-checkbox-label">
                                                                                                            <input
                                                                                                                type="checkbox"
                                                                                                                class="compare-checkbox"
                                                                                                                value="<%= device.getDeviceId() %>"
                                                                                                                onchange="updateSelectedDevices(this)">
                                                                                                            Add to
                                                                                                            Compare
                                                                                                        </label>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <% } %>
                                                                                    </div>
                                                                                </form>

                                                                                <script>
                                                                                    let selectedDeviceIds = new Set();
                                                                                    const compareBtn = document.getElementById('compareBtn');
                                                                                    const compareCount = document.getElementById('compareCount');

                                                                                    function updateSelectedDevices(checkbox) {
                                                                                        const deviceId = checkbox.value;
                                                                                        if (checkbox.checked) {
                                                                                            selectedDeviceIds.add(deviceId);
                                                                                        } else {
                                                                                            selectedDeviceIds.delete(deviceId);
                                                                                        }
                                                                                        updateHiddenInputs();
                                                                                        updateCompareUI();
                                                                                    }

                                                                                    function updateHiddenInputs() {
                                                                                        const container = document.getElementById('selectedDevices');
                                                                                        container.innerHTML = '';
                                                                                        selectedDeviceIds.forEach(deviceId => {
                                                                                            const input = document.createElement('input');
                                                                                            input.type = 'hidden';
                                                                                            input.name = 'deviceIds';
                                                                                            input.value = deviceId;
                                                                                            container.appendChild(input);
                                                                                        });
                                                                                    }

                                                                                    function updateCompareUI() {
                                                                                        const count = selectedDeviceIds.size;
                                                                                        compareCount.textContent = count;

                                                                                        if (count >= 2 && count <= 3) {
                                                                                            compareBtn.disabled = false;
                                                                                        } else {
                                                                                            compareBtn.disabled = true;
                                                                                        }
                                                                                    }
                                                                                </script>
                                                                                <% } %>
                                                    </section>
                                                </div>
                                            </main>

                                            <footer class="footer">
                                                <div class="container">
                                                    <div class="footer-content">
                                                        <p class="footer-logo">Manyung</p>
                                                        <p class="footer-text">2025 Manyung. All rights reserved.
                                                        </p>
                                                    </div>
                                                </div>
                                            </footer>
                                    </div>
                                </body>

                                </html>