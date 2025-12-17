<%@page import="model.Device" %>
    <%@page import="jakarta.servlet.http.HttpServletRequest" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <% Device device=(Device) request.getSession().getAttribute("singleDevice"); if (device==null) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=showAllDevicesAdmin" ); return; }
                String posterUrl=device.getPoster_url(); String finalUrl=posterUrl.contains("images_device") ?
                request.getContextPath() + "/" + posterUrl : posterUrl; %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Edit Device - Manyung</title>
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

                        .edit-card {
                            background: var(--white);
                            border-radius: var(--radius-2xl);
                            box-shadow: var(--shadow-md);
                            max-width: 800px;
                            margin: 0 auto;
                            overflow: hidden;
                        }

                        .edit-header {
                            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                            padding: var(--space-6);
                            color: var(--white);
                        }

                        .edit-header h1 {
                            font-size: 1.5rem;
                            font-weight: 700;
                            color: var(--white);
                            margin: 0;
                        }

                        .edit-body {
                            padding: var(--space-8);
                        }

                        .image-preview {
                            text-align: center;
                            margin-bottom: var(--space-6);
                        }

                        .image-preview img {
                            max-width: 200px;
                            max-height: 200px;
                            object-fit: contain;
                            border-radius: var(--radius-lg);
                            border: 2px solid var(--neutral-200);
                            background: var(--neutral-50);
                            padding: var(--space-4);
                        }

                        .form-row {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: var(--space-5);
                        }

                        .form-group {
                            margin-bottom: var(--space-5);
                        }

                        .form-label {
                            display: block;
                            font-size: 0.875rem;
                            font-weight: 600;
                            color: var(--neutral-700);
                            margin-bottom: var(--space-2);
                        }

                        .form-input,
                        .form-select {
                            width: 100%;
                            padding: var(--space-3) var(--space-4);
                            font-size: 0.9375rem;
                            color: var(--neutral-800);
                            background: var(--neutral-50);
                            border: 2px solid var(--neutral-200);
                            border-radius: var(--radius-lg);
                            transition: all var(--transition-fast);
                        }

                        .form-input:focus,
                        .form-select:focus {
                            outline: none;
                            border-color: var(--primary-500);
                            background: var(--white);
                            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1);
                        }

                        .form-actions {
                            display: flex;
                            gap: var(--space-4);
                            margin-top: var(--space-8);
                            padding-top: var(--space-6);
                            border-top: 1px solid var(--neutral-100);
                        }

                        .btn-save {
                            flex: 1;
                            padding: var(--space-4);
                            background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                            color: var(--white);
                            font-size: 1rem;
                            font-weight: 600;
                            border: none;
                            border-radius: var(--radius-lg);
                            cursor: pointer;
                            transition: all var(--transition-base);
                            box-shadow: 0 4px 14px rgba(220, 38, 38, 0.35);
                        }

                        .btn-save:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 20px rgba(220, 38, 38, 0.45);
                        }

                        .btn-cancel {
                            padding: var(--space-4) var(--space-8);
                            background: var(--neutral-200);
                            color: var(--neutral-700);
                            font-size: 1rem;
                            font-weight: 500;
                            border: none;
                            border-radius: var(--radius-lg);
                            cursor: pointer;
                            transition: all var(--transition-fast);
                        }

                        .btn-cancel:hover {
                            background: var(--neutral-300);
                        }

                        @media (max-width: 768px) {
                            .form-row {
                                grid-template-columns: 1fr;
                            }

                            .form-actions {
                                flex-direction: column;
                            }
                        }
                    </style>
                    <script>
                        function previewImage(event) {
                            const reader = new FileReader();
                            reader.onload = function () {
                                const output = document.getElementById('poster_preview');
                                output.src = reader.result;
                            };
                            reader.readAsDataURL(event.target.files[0]);
                        }
                    </script>
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
                                    <span class="nav-link" style="opacity: 0.8;">Edit Device</span>
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
                                <a href="${pageContext.request.contextPath}/AdminServlet?action=showAllDevicesAdmin"
                                    class="back-link">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                                        viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                                    </svg>
                                    Back to Device Management
                                </a>

                                <div class="edit-card">
                                    <div class="edit-header">
                                        <h1>Edit Device</h1>
                                    </div>

                                    <div class="edit-body">
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="post"
                                            enctype="multipart/form-data">
                                            <input type="hidden" name="idDevice" value="<%= device.getDeviceId() %>">
                                            <input type="hidden" name="action" value="editDevice">

                                            <div class="image-preview">
                                                <img id="poster_preview" src="<%= finalUrl %>" alt="Device Image">
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label" for="poster_url">Device Image</label>
                                                <input type="file" id="poster_url" name="image" accept="image/*"
                                                    onchange="previewImage(event)" class="form-input" required>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label" for="name">Device Name</label>
                                                    <input type="text" id="name" name="name"
                                                        value="<%= device.getName() %>" class="form-input" required>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="brand">Brand</label>
                                                    <select id="brand" name="brand" class="form-select" required>
                                                        <option value="">-- Select Brand --</option>
                                                        <option value="Asus" <%="Asus" .equals(device.getBrand())
                                                            ? "selected" : "" %>>Asus</option>
                                                        <option value="Acer" <%="Acer" .equals(device.getBrand())
                                                            ? "selected" : "" %>>Acer</option>
                                                        <option value="MSI" <%="MSI" .equals(device.getBrand())
                                                            ? "selected" : "" %>>MSI</option>
                                                        <option value="Lenovo" <%="Lenovo" .equals(device.getBrand())
                                                            ? "selected" : "" %>>Lenovo</option>
                                                        <option value="Dell" <%="Dell" .equals(device.getBrand())
                                                            ? "selected" : "" %>>Dell</option>
                                                        <option value="HP" <%="HP" .equals(device.getBrand())
                                                            ? "selected" : "" %>>HP</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label" for="price">Price (Rp)</label>
                                                    <input type="number" id="price" name="price"
                                                        value="<%= device.getPrice() %>" class="form-input" required>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="category">Category</label>
                                                    <select id="category" name="category" class="form-select" required>
                                                        <option value="">-- Select Category --</option>
                                                        <option value="Gaming" <%="Gaming" .equals(device.getCategory())
                                                            ? "selected" : "" %>>Gaming</option>
                                                        <option value="Creators" <%="Creators"
                                                            .equals(device.getCategory()) ? "selected" : "" %>>Creators
                                                        </option>
                                                        <option value="Office" <%="Office" .equals(device.getCategory())
                                                            ? "selected" : "" %>>Office</option>
                                                        <option value="Students" <%="Students"
                                                            .equals(device.getCategory()) ? "selected" : "" %>>Students
                                                        </option>
                                                        <option value="Home" <%="Home" .equals(device.getCategory())
                                                            ? "selected" : "" %>>Home</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label class="form-label" for="url">Official Website URL</label>
                                                <input type="url" id="url" name="url"
                                                    value="<%= device.getUrl() != null ? device.getUrl() : "" %>"
                                                    class="form-input">
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label" for="operating_system">Operating
                                                        System</label>
                                                    <input type="text" id="operating_system" name="operatingSystem"
                                                        value="<%= device.getOperatingSystem() %>" class="form-input">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="processor">Processor</label>
                                                    <input type="text" id="processor" name="processor"
                                                        value="<%= device.getProcessor() %>" class="form-input">
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label" for="graphics_card">Graphics Card</label>
                                                    <input type="text" id="graphics_card" name="graphicsCard"
                                                        value="<%= device.getGraphicsCard() != null ? device.getGraphicsCard() : "" %>"
                                                        class="form-input">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="graphics_card_type">Graphics
                                                        Type</label>
                                                    <select id="graphics_card_type" name="graphicsCardType"
                                                        class="form-select">
                                                        <option value="Dedicated" <%="Dedicated"
                                                            .equals(device.getGraphicsCardType()) ? "selected" : "" %>
                                                            >Dedicated</option>
                                                        <option value="Integrated" <%="Integrated"
                                                            .equals(device.getGraphicsCardType()) ? "selected" : "" %>
                                                            >Integrated</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label" for="memory">Memory (GB)</label>
                                                    <input type="number" id="memory" name="memory"
                                                        value="<%= device.getMemory() %>" class="form-input">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="storage">Storage</label>
                                                    <input type="text" id="storage" name="storage"
                                                        value="<%= device.getStorage() %>" class="form-input">
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label" for="display">Display</label>
                                                    <input type="text" id="display" name="display"
                                                        value="<%= device.getDisplay() != null ? device.getDisplay() : "" %>"
                                                        class="form-input">
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label" for="battery">Battery</label>
                                                    <input type="text" id="battery" name="battery"
                                                        value="<%= device.getBattery() != null ? device.getBattery() : "" %>"
                                                        class="form-input">
                                                </div>
                                            </div>

                                            <div class="form-actions">
                                                <button type="button" class="btn-cancel"
                                                    onclick="window.location.href='${pageContext.request.contextPath}/AdminServlet?action=showAllDevicesAdmin'">
                                                    Cancel
                                                </button>
                                                <button type="submit" class="btn-save">
                                                    Save Changes
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </main>
                    </div>
                </body>

                </html>