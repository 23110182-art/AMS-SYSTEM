<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Asset Management System - Login</title>
        <link rel="stylesheet" href="/css/login.css">
    </head>

    <body>

        <div class="login-card">
            <div class="logo-icon">📦</div>
            <h2>Asset Management System</h2>
            <p class="subtitle">Sign in to your account</p>

            <div id="errorMessage"></div>

            <div class="form-group">
                <label>Username</label>
                <input type="text" id="username" placeholder="Enter your username">
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" id="password" placeholder="Enter your password">
            </div>

            <!-- <div class="demo-box">
                <strong>Demo accounts:</strong>
                Admin: username "admin", password "admin123"<br>
                User: username "user", password "user123"
            </div> -->

            <button class="btn-submit" id="loginBtn">Sign In</button>

            <div class="register-link">
                Don't have an account? <a href="/register">Register</a>
            </div>
        </div>

        <script>
            document.getElementById("loginBtn").addEventListener("click", function () {
                const userVal = document.getElementById("username").value;
                const passVal = document.getElementById("password").value;
                const errorDiv = document.getElementById("errorMessage");

                if (!userVal || !passVal) {
                    errorDiv.innerText = "Please enter username and password.";
                    errorDiv.style.display = "block";
                    return;
                }

                fetch('/api/auth/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ username: userVal, password: passVal })
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            localStorage.setItem('jwt_token', data.data.token);
                            document.cookie = 'jwt_token=' + encodeURIComponent(data.data.token) + '; path=/; SameSite=Lax';
                            const role = data.data.user.role.toUpperCase();
                            if (role === 'ADMIN') {
                                window.location.href = '/admin/dashboard';
                            } else {
                                window.location.href = '/user/dashboard';
                            }
                        } else {
                            errorDiv.innerText = data.message || "Invalid username or password";
                            errorDiv.style.display = "block";
                        }
                    })
                    .catch(error => {
                        errorDiv.innerText = "Error connecting to server.";
                        errorDiv.style.display = "block";
                    });
            });
        </script>
    </body>

    </html>