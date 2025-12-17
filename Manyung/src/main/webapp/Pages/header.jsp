<%@page import="dao.UserDAO" %>
    <%@page import="model.User" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <% UserDAO userDAOO=new UserDAO(); User userr=(User) request.getSession().getAttribute("user"); boolean
                validateeAdmin=false; if (userr !=null) { validateeAdmin=userDAOO.validateAdmin(userr.getEmail(),
                userr.getPassword()); } %>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
                            <% if (!validateeAdmin && userr !=null) { %>
                                <a href="${pageContext.request.contextPath}/Pages/homeAfterLogin.jsp"
                                    class="nav-link">Dashboard</a>
                                <a href="${pageContext.request.contextPath}/UserServlet?action=rekomendasiDevice"
                                    class="nav-link">Devices</a>
                                <% } else if (validateeAdmin) { %>
                                    <a href="${pageContext.request.contextPath}/AdminServlet?action=showAllDevicesAdmin"
                                        class="nav-link">Admin Panel</a>
                                    <% } %>

                                        <% if (userr !=null) { %>
                                            <form action="${pageContext.request.contextPath}/UserServlet" method="get"
                                                style="margin: 0;">
                                                <button type="submit" name="action" value="logout" class="btn btn-sm"
                                                    style="background: rgba(255,255,255,0.15); color: var(--white); border: 1px solid rgba(255,255,255,0.3);">
                                                    Logout
                                                </button>
                                            </form>
                                            <% } %>
                        </div>
                    </div>
                </nav>