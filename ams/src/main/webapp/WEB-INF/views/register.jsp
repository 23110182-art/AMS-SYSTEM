<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Asset Management System - Register</title>
        <link rel="stylesheet" href="/css/login.css">
    </head>

    <body>

        <div class="login-card">
            <div class="logo-icon">📦</div>
            <h2>Asset Management System</h2>
            <p class="subtitle">Create a new account</p>

            <div id="errorMessage"></div>

            <div class="form-group">
                <label>Username</label>
                <input type="text" id="username" placeholder="Enter your username">
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" id="password" placeholder="Enter your password">
            </div>

            <div class="form-group">
                <label>Role</label>
                <select id="role">
                    <option value="USER">User</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>

            <button class="btn-submit" id="registerBtn">Register</button>

            <div class="register-link">
                Already have an account? <a href="/login">Sign in</a>
            </div>
        </div>

        <script>
            document.getElementById("registerBtn").addEventListener("click", function () {
                const userVal = document.getElementById("username").value;
                const passVal = document.getElementById("password").value;
                const roleVal = document.getElementById("role").value;
                const errorDiv = document.getElementById("errorMessage");

                if (!userVal || !passVal) {
                    errorDiv.innerText = "Please enter username and password.";
                    errorDiv.style.display = "block";
                    return;
                }

                fetch('/api/auth/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ username: userVal, password: passVal, role: roleVal })
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            window.location.href = '/login';
                        } else {
                            errorDiv.innerText = data.message || "Registration failed.";
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