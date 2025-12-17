<%@page import="java.util.List" %>
    <%@page import="model.Device" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Dashboard - Manyung</title>
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

                    /* Dashboard Header */
                    .dashboard-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        margin-bottom: var(--space-8);
                    }

                    .dashboard-title {
                        font-size: 1.75rem;
                        font-weight: 700;
                        color: var(--neutral-900);
                    }

                    .dashboard-subtitle {
                        color: var(--neutral-500);
                        font-size: 0.9375rem;
                        margin-top: var(--space-1);
                    }

                    /* Stats Cards */
                    .stats-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: var(--space-5);
                        margin-bottom: var(--space-8);
                    }

                    .stat-card {
                        background: var(--white);
                        padding: var(--space-5);
                        border-radius: var(--radius-xl);
                        box-shadow: var(--shadow-sm);
                    }

                    .stat-label {
                        font-size: 0.875rem;
                        color: var(--neutral-500);
                        margin-bottom: var(--space-2);
                    }

                    .stat-value {
                        font-size: 1.75rem;
                        font-weight: 700;
                        color: var(--neutral-900);
                    }

                    /* Products Section */
                    .products-section {
                        background: var(--white);
                        border-radius: var(--radius-xl);
                        box-shadow: var(--shadow-sm);
                        overflow: hidden;
                    }

                    .products-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: var(--space-5) var(--space-6);
                        border-bottom: 1px solid var(--neutral-100);
                    }

                    .products-title {
                        font-size: 1.125rem;
                        font-weight: 600;
                        color: var(--neutral-900);
                    }

                    .products-body {
                        padding: var(--space-6);
                    }

                    .products-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
                        gap: var(--space-5);
                    }

                    /* Product Card */
                    .product-card {
                        background: var(--white);
                        border: 1px solid var(--neutral-200);
                        border-radius: var(--radius-xl);
                        overflow: hidden;
                        transition: all var(--transition-base);
                    }

                    .product-card:hover {
                        border-color: var(--primary-200);
                        box-shadow: var(--shadow-md);
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
                        font-size: 1rem;
                        font-weight: 600;
                        color: var(--neutral-900);
                        margin-bottom: var(--space-2);
                        line-height: 1.4;
                        display: -webkit-box;
                        -webkit-line-clamp: 2;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                    }

                    .product-price {
                        font-size: 1.125rem;
                        font-weight: 700;
                        color: var(--primary-600);
                        margin-bottom: var(--space-4);
                    }

                    .product-actions {
                        display: flex;
                        gap: var(--space-2);
                    }

                    .btn-edit {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: var(--space-2);
                        padding: var(--space-2) var(--space-3);
                        background: var(--warning-100);
                        color: #92400e;
                        border: none;
                        border-radius: var(--radius-md);
                        font-size: 0.875rem;
                        font-weight: 500;
                        cursor: pointer;
                        text-decoration: none;
                        transition: all var(--transition-fast);
                    }

                    .btn-edit:hover {
                        background: #fde68a;
                    }

                    .btn-delete {
                        flex: 1;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: var(--space-2);
                        padding: var(--space-2) var(--space-3);
                        background: var(--error-100);
                        color: #991b1b;
                        border: none;
                        border-radius: var(--radius-md);
                        font-size: 0.875rem;
                        font-weight: 500;
                        cursor: pointer;
                        text-decoration: none;
                        transition: all var(--transition-fast);
                    }

                    .btn-delete:hover {
                        background: #fecaca;
                    }

                    /* Empty State */
                    .empty-state {
                        text-align: center;
                        padding: var(--space-16);
                    }

                    .empty-state-icon {
                        width: 80px;
                        height: 80px;
                        background: var(--neutral-100);
                        border-radius: var(--radius-full);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        margin: 0 auto var(--space-5);
                    }

                    .empty-state-icon svg {
                        width: 40px;
                        height: 40px;
                        color: var(--neutral-400);
                    }

                    .empty-state-title {
                        font-size: 1.125rem;
                        font-weight: 600;
                        color: var(--neutral-700);
                        margin-bottom: var(--space-2);
                    }

                    .empty-state-text {
                        color: var(--neutral-500);
                        margin-bottom: var(--space-6);
                    }

                    /* Modal Styles */
                    .modal-overlay {
                        display: none;
                        position: fixed;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: rgba(0, 0, 0, 0.6);
                        backdrop-filter: blur(4px);
                        z-index: 2000;
                        align-items: center;
                        justify-content: center;
                        padding: var(--space-6);
                    }

                    .modal-overlay.active {
                        display: flex;
                    }

                    .modal {
                        background: var(--white);
                        border-radius: var(--radius-2xl);
                        box-shadow: var(--shadow-xl);
                        width: 100%;
                        max-width: 600px;
                        max-height: 90vh;
                        overflow-y: auto;
                    }

                    .modal-header {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: var(--space-5) var(--space-6);
                        border-bottom: 1px solid var(--neutral-100);
                        position: sticky;
                        top: 0;
                        background: var(--white);
                        z-index: 1;
                    }

                    .modal-title {
                        font-size: 1.25rem;
                        font-weight: 600;
                        color: var(--neutral-900);
                    }

                    .modal-close {
                        width: 36px;
                        height: 36px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        background: var(--neutral-100);
                        border: none;
                        border-radius: var(--radius-md);
                        cursor: pointer;
                        color: var(--neutral-600);
                        font-size: 1.5rem;
                        transition: all var(--transition-fast);
                    }

                    .modal-close:hover {
                        background: var(--neutral-200);
                    }

                    .modal-body {
                        padding: var(--space-6);
                    }

                    .form-row {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: var(--space-4);
                    }

                    .modal-footer {
                        display: flex;
                        justify-content: flex-end;
                        gap: var(--space-3);
                        padding: var(--space-4) var(--space-6);
                        border-top: 1px solid var(--neutral-100);
                        background: var(--neutral-50);
                    }

                    .btn-cancel {
                        padding: var(--space-3) var(--space-5);
                        background: var(--neutral-200);
                        color: var(--neutral-700);
                        border: none;
                        border-radius: var(--radius-lg);
                        font-weight: 500;
                        cursor: pointer;
                        transition: all var(--transition-fast);
                    }

                    .btn-cancel:hover {
                        background: var(--neutral-300);
                    }

                    .btn-save {
                        padding: var(--space-3) var(--space-5);
                        background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                        color: var(--white);
                        border: none;
                        border-radius: var(--radius-lg);
                        font-weight: 500;
                        cursor: pointer;
                        transition: all var(--transition-fast);
                    }

                    .btn-save:hover {
                        transform: translateY(-1px);
                    }

                    @media (max-width: 640px) {
                        .form-row {
                            grid-template-columns: 1fr;
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

                            <div class="navbar-search">
                                <form action="${pageContext.request.contextPath}/UserServlet" method="get"
                                    class="search-form">
                                    <input type="hidden" name="action" value="searchDevice">
                                    <input type="text" name="deviceName" placeholder="Search devices..."
                                        class="search-input">
                                    <button type="submit" class="search-btn">Search</button>
                                </form>
                            </div>

                            <div class="navbar-nav">
                                <span class="nav-link" style="opacity: 0.8;">Admin Panel</span>
                                <form action="${pageContext.request.contextPath}/UserServlet" method="get"
                                    style="margin: 0;">
                                    <button type="submit" name="action" value="logout" class="btn btn-sm"
                                        style="background: rgba(255,255,255,0.15); color: var(--white); border: 1px solid rgba(255,255,255,0.3);">
                                        Logout
                                    </button>
                                </form>
                            </div>
                        </div>
                    </nav>

                    <main class="main-content">
                        <div class="container">
                            <!-- Alerts -->
                            <% if (request.getParameter("msg") !=null) { %>
                                <div class="alert alert-success" style="margin-bottom: var(--space-5);">
                                    <%= request.getParameter("msg") %>
                                </div>
                                <% } %>

                                    <% if (request.getParameter("error") !=null) { %>
                                        <div class="alert alert-error" style="margin-bottom: var(--space-5);">
                                            <%= request.getParameter("error") %>
                                        </div>
                                        <% } %>

                                            <!-- Dashboard Header -->
                                            <div class="dashboard-header">
                                                <div>
                                                    <h1 class="dashboard-title">Device Management</h1>
                                                    <p class="dashboard-subtitle">Manage all devices in the system</p>
                                                </div>
                                                <button id="add-device-btn" class="btn btn-primary">
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20"
                                                        fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round"
                                                            stroke-width="2" d="M12 4v16m8-8H4" />
                                                    </svg>
                                                    Add Device
                                                </button>
                                            </div>

                                            <% List<Device> devices = (List<Device>)
                                                    request.getSession().getAttribute("allDevices");
                                                    int deviceCount = (devices != null) ? devices.size() : 0;
                                                    %>

                                                    <!-- Stats -->
                                                    <div class="stats-grid">
                                                        <div class="stat-card">
                                                            <p class="stat-label">Total Devices</p>
                                                            <p class="stat-value">
                                                                <%= deviceCount %>
                                                            </p>
                                                        </div>
                                                        <div class="stat-card">
                                                            <p class="stat-label">Categories</p>
                                                            <p class="stat-value">5</p>
                                                        </div>
                                                        <div class="stat-card">
                                                            <p class="stat-label">Brands</p>
                                                            <p class="stat-value">10+</p>
                                                        </div>
                                                    </div>

                                                    <!-- Products Section -->
                                                    <div class="products-section">
                                                        <div class="products-header">
                                                            <h2 class="products-title">All Devices</h2>
                                                        </div>

                                                        <div class="products-body">
                                                            <% if (devices==null || devices.isEmpty()) { %>
                                                                <div class="empty-state">
                                                                    <div class="empty-state-icon">
                                                                        <svg xmlns="http://www.w3.org/2000/svg"
                                                                            fill="none" viewBox="0 0 24 24"
                                                                            stroke="currentColor">
                                                                            <path stroke-linecap="round"
                                                                                stroke-linejoin="round" stroke-width="2"
                                                                                d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                                                                        </svg>
                                                                    </div>
                                                                    <h3 class="empty-state-title">No Devices Yet</h3>
                                                                    <p class="empty-state-text">Get started by adding
                                                                        your first device</p>
                                                                    <button class="btn btn-primary"
                                                                        onclick="document.getElementById('add-device-btn').click()">
                                                                        Add First Device
                                                                    </button>
                                                                </div>
                                                                <% } else { %>
                                                                    <div class="products-grid">
                                                                        <% for (Device device : devices) { String
                                                                            posterUrl=device.getPoster_url(); String
                                                                            finalUrl=posterUrl.contains("images_device")
                                                                            ? request.getContextPath() + "/" + posterUrl
                                                                            : posterUrl; %>
                                                                            <div class="product-card">
                                                                                <img src="<%= finalUrl %>"
                                                                                    alt="<%= device.getName() %>"
                                                                                    class="product-image">
                                                                                <div class="product-body">
                                                                                    <h3 class="product-name">
                                                                                        <%= device.getName() %>
                                                                                    </h3>
                                                                                    <p class="product-price">Rp <%=
                                                                                            String.format("%,d",
                                                                                            device.getPrice()) %>
                                                                                    </p>
                                                                                    <div class="product-actions">
                                                                                        <a href="${pageContext.request.contextPath}/AdminServlet?action=showDeviceEdit&idDevices=<%= device.getDeviceId() %>"
                                                                                            class="btn-edit">
                                                                                            Edit
                                                                                        </a>
                                                                                        <a href="${pageContext.request.contextPath}/AdminServlet?action=deleteDevice&idDevice=<%= device.getDeviceId() %>"
                                                                                            class="btn-delete"
                                                                                            onclick="return confirm('Are you sure you want to delete this device?')">
                                                                                            Delete
                                                                                        </a>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <% } %>
                                                                    </div>
                                                                    <% } %>
                                                        </div>
                                                    </div>
                        </div>
                    </main>

                    <!-- Add Device Modal -->
                    <div class="modal-overlay" id="deviceModal">
                        <div class="modal">
                            <div class="modal-header">
                                <h2 class="modal-title">Add New Device</h2>
                                <button class="modal-close" id="closeModalBtn">&times;</button>
                            </div>

                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post"
                                enctype="multipart/form-data">
                                <input type="hidden" name="action" value="tambahDevice">

                                <div class="modal-body">
                                    <div class="form-group">
                                        <label class="form-label">Device Name</label>
                                        <input type="text" name="name" class="form-input"
                                            placeholder="e.g. ASUS ROG Zephyrus" required>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">Brand</label>
                                            <select name="brand" class="form-input" required>
                                                <option value="">-- Select Brand --</option>
                                                <option value="Asus">Asus</option>
                                                <option value="Acer">Acer</option>
                                                <option value="MSI">MSI</option>
                                                <option value="Lenovo">Lenovo</option>
                                                <option value="Dell">Dell</option>
                                                <option value="HP">HP</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Category</label>
                                            <select name="category" class="form-input" required>
                                                <option value="">-- Select Category --</option>
                                                <option value="Gaming">Gaming</option>
                                                <option value="Creators">Creators</option>
                                                <option value="Office">Office</option>
                                                <option value="Students">Students</option>
                                                <option value="Home">Home</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">Price (Rp)</label>
                                            <input type="number" name="price" class="form-input"
                                                placeholder="e.g. 25000000" required>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Operating System</label>
                                            <input type="text" name="operatingSystem" class="form-input"
                                                placeholder="e.g. Windows 11">
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">Processor</label>
                                            <input type="text" name="processor" class="form-input"
                                                placeholder="e.g. Intel Core i7">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Memory (GB)</label>
                                            <input type="number" name="memory" class="form-input" placeholder="e.g. 16">
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">Graphics Card</label>
                                            <input type="text" name="graphicsCard" class="form-input"
                                                placeholder="e.g. RTX 4060">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Graphics Type</label>
                                            <select name="graphicsCardType" class="form-input">
                                                <option value="Dedicated">Dedicated</option>
                                                <option value="Integrated">Integrated</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label class="form-label">Storage</label>
                                            <input type="text" name="storage" class="form-input"
                                                placeholder="e.g. 512GB SSD">
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label">Battery</label>
                                            <input type="text" name="battery" class="form-input"
                                                placeholder="e.g. 90Wh">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Display</label>
                                        <input type="text" name="display" class="form-input"
                                            placeholder="e.g. 15.6 inch FHD 144Hz">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Product URL</label>
                                        <input type="url" name="url" class="form-input" placeholder="https://...">
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label">Product Image</label>
                                        <input type="file" name="image" class="form-input" accept="image/*" required>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                                    <button type="submit" class="btn-save">Save Device</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    const addDeviceBtn = document.getElementById('add-device-btn');
                    const deviceModal = document.getElementById('deviceModal');
                    const closeModalBtn = document.getElementById('closeModalBtn');

                    addDeviceBtn.addEventListener('click', () => {
                        deviceModal.classList.add('active');
                    });

                    closeModalBtn.addEventListener('click', closeModal);

                    function closeModal() {
                        deviceModal.classList.remove('active');
                    }

                    deviceModal.addEventListener('click', (e) => {
                        if (e.target === deviceModal) {
                            closeModal();
                        }
                    });

                    document.addEventListener('keydown', (e) => {
                        if (e.key === 'Escape') {
                            closeModal();
                        }
                    });
                </script>
            </body>

            </html>