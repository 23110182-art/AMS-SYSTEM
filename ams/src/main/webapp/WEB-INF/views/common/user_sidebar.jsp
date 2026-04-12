<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-box-open logo-icon"></i>
        <span class="logo-text">Asset MS</span>
    </div>

    <ul class="sidebar-nav">
        <li class="nav-item">
            <a href="/user/assets" class="nav-link">
                <i class="fas fa-boxes"></i> <span>Assets</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="/user/request" class="nav-link">
                <i class="fas fa-clipboard-list"></i> <span>My Requests</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <div class="user-profile">
            <div class="avatar"><i class="fas fa-user-circle"></i></div>
            <div class="user-info">
                <p class="user-name">user</p>
                <p class="user-role">User</p>
            </div>
        </div>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const currentPath = window.location.pathname;
        document.querySelectorAll('.sidebar-nav .nav-link').forEach(link => {
            if (currentPath.includes(link.getAttribute('href'))) {
                link.classList.add('active');
            }
        });
    });
</script>
