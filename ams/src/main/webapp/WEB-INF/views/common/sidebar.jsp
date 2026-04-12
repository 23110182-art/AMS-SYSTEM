<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<aside class="sidebar">
    <div class="sidebar-brand">
        <i class="fas fa-box-open logo-icon"></i>
        <span class="logo-text">Asset MS</span>
    </div>

    <ul class="sidebar-nav">
        <li class="nav-item">
            <a href="/admin/dashboard" class="nav-link">
                <i class="fas fa-home"></i> <span>Dashboard</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="/admin/assets" class="nav-link">
                <i class="fas fa-boxes"></i> <span>Asset Management</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="/admin/requests" class="nav-link">
                <i class="fas fa-clipboard-check"></i> <span>Request Approval</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="/admin/types" class="nav-link">
                <i class="fas fa-tags"></i> <span>Asset Types</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <div class="user-profile">
            <div class="avatar"><i class="fas fa-user-circle"></i></div>
            <div class="user-info">
                <p class="user-name">admin</p>
                <p class="user-role">Administrator</p>
            </div>
        </div>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const currentPath = window.location.pathname;
        const navLinks = document.querySelectorAll('.sidebar-nav .nav-link');
        
        navLinks.forEach(link => {
            if (currentPath.includes(link.getAttribute('href'))) {
                link.classList.add('active');
            }
        });
    });
</script>