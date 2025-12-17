<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Login - Manyung</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            body {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background: linear-gradient(135deg, var(--primary-700) 0%, var(--primary-500) 50%, var(--primary-300) 100%);
                position: relative;
            }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            }

            .login-container {
                position: relative;
                z-index: 1;
                width: 100%;
                max-width: 420px;
                margin: var(--space-6);
            }

            .login-card {
                background: var(--white);
                border-radius: var(--radius-2xl);
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                overflow: hidden;
            }

            .login-header {
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                padding: var(--space-8) var(--space-6);
                text-align: center;
            }

            .login-header h1 {
                color: var(--white);
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: var(--space-2);
            }

            .login-header p {
                color: rgba(255, 255, 255, 0.8);
                font-size: 0.9375rem;
                margin: 0;
            }

            .login-body {
                padding: var(--space-8) var(--space-6);
            }

            .form-group {
                margin-bottom: var(--space-5);
            }

            .form-group label {
                display: block;
                font-size: 0.875rem;
                font-weight: 600;
                color: var(--neutral-700);
                margin-bottom: var(--space-2);
            }

            .form-group input {
                width: 100%;
                padding: var(--space-4);
                font-size: 1rem;
                border: 2px solid var(--neutral-200);
                border-radius: var(--radius-lg);
                transition: all var(--transition-fast);
                background: var(--neutral-50);
            }

            .form-group input:focus {
                outline: none;
                border-color: var(--primary-500);
                background: var(--white);
                box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1);
            }

            .form-group input::placeholder {
                color: var(--neutral-400);
            }

            .btn-login {
                width: 100%;
                padding: var(--space-4);
                background: linear-gradient(135deg, var(--primary-600) 0%, var(--primary-700) 100%);
                color: var(--white);
                font-size: 1rem;
                font-weight: 600;
                border: none;
                border-radius: var(--radius-lg);
                cursor: pointer;
                transition: all var(--transition-base);
                box-shadow: 0 4px 14px 0 rgba(220, 38, 38, 0.4);
            }

            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px 0 rgba(220, 38, 38, 0.5);
            }

            .login-footer {
                text-align: center;
                padding-top: var(--space-6);
                border-top: 1px solid var(--neutral-100);
                margin-top: var(--space-6);
            }

            .login-footer p {
                color: var(--neutral-600);
                font-size: 0.9375rem;
                margin: 0;
            }

            .login-footer a {
                color: var(--primary-600);
                font-weight: 600;
                text-decoration: none;
                transition: color var(--transition-fast);
            }

            .login-footer a:hover {
                color: var(--primary-700);
                text-decoration: underline;
            }

            .alert {
                padding: var(--space-4);
                border-radius: var(--radius-lg);
                margin-bottom: var(--space-5);
                font-size: 0.9375rem;
            }

            .alert-error {
                background: var(--error-100);
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            .alert-success {
                background: #dcfce7;
                color: #166534;
                border: 1px solid #bbf7d0;
            }

            .back-link {
                display: block;
                text-align: center;
                margin-top: var(--space-6);
                color: rgba(255, 255, 255, 0.9);
                font-size: 0.9375rem;
                text-decoration: none;
            }

            .back-link:hover {
                color: var(--white);
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <div class="login-container">
            <div class="login-card">
                <div class="login-header">
                    <h1>Manyung</h1>
                    <p>Masuk ke akunmu</p>
                </div>

                <div class="login-body">
                    <% if (request.getParameter("error") !=null) { %>
                        <div class="alert alert-error">
                            <%= request.getParameter("error") %>
                        </div>
                        <% } %>

                            <% if (request.getParameter("regMsg") !=null) { %>
                                <div class="alert alert-success">
                                    <%= request.getParameter("regMsg") %>
                                </div>
                                <% } %>

                                    <form action="${pageContext.request.contextPath}/UserServlet" method="get">
                                        <input type="hidden" name="action" value="login">

                                        <div class="form-group">
                                            <label for="email">Email Address</label>
                                            <input type="email" id="email" name="email" placeholder="Enter your email"
                                                required>
                                        </div>

                                        <div class="form-group">
                                            <label for="password">Password</label>
                                            <input type="password" id="password" name="password"
                                                placeholder="Enter your password" required>
                                        </div>

                                        <button type="submit" class="btn-login">Sign In</button>
                                    </form>

                                    <div class="login-footer">
                                        <p>Belum punya akun? <a href="registration.jsp">Create Account</a></p>
                                    </div>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/Pages/homeBeforeLogin.jsp" class="back-link">Back to Home</a>
        </div>
    </body>

    </html>