<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<header class="topbar">
    <div class="topbar-left">
        <h2 class="page-title">User Portal</h2>
    </div>
    
    <div class="topbar-right">
        
        <button onclick="logout()" class="btn-logout">
            <i class="fas fa-sign-out-alt"></i> Logout
        </button>
    </div>
</header>

<script>
    // Hàm xử lý đăng xuất đã thảo luận trước đó
    function logout() {
        if(confirm("Are you sure you want to logout?")) {
            // Xóa token ở LocalStorage
            localStorage.removeItem('jwt_token');
            // Xóa cookie
            document.cookie = "jwt_token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 UTC;";
            // Chuyển về trang đăng nhập
            window.location.href = '/login';
        }
    }
</script>