<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Dashboard</title>
    <jsp:include page="../common/head_css.jsp" />
    
    <style>
        .dashboard-header { margin-bottom: 24px; }
        .dashboard-header h2 { margin: 0; color: var(--text-main); font-size: 24px; }
        
        /* Cấu trúc 4 thẻ thống kê */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 32px; }
        .stat-card { background: #fff; padding: 24px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); display: flex; align-items: center; gap: 16px; border: 1px solid var(--border-color); }
        .stat-icon { width: 56px; height: 56px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; }
        .stat-info p { margin: 0; color: var(--text-muted); font-size: 14px; font-weight: 500; }
        .stat-info h3 { margin: 4px 0 0; color: var(--text-main); font-size: 28px; font-weight: 700; }
        
        /* Màu cho từng icon */
        .icon-total { background: #eef2ff; color: #4f46e5; }
        .icon-available { background: #dcfce7; color: #16a34a; }
        .icon-inuse { background: #e0f2fe; color: #0284c7; }
        .icon-broken { background: #fee2e2; color: #ef4444; }

        /* Cấu trúc Biểu đồ */
        .charts-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 24px; margin-bottom: 32px; }
        .chart-card { background: #fff; padding: 24px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); }
        .chart-card h3 { margin-top: 0; margin-bottom: 20px; font-size: 16px; color: var(--text-main); }

        /* Cấu trúc Bảng dữ liệu */
        .table-card { background: #fff; padding: 24px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); }
        .table-card h3 { margin-top: 0; margin-bottom: 20px; font-size: 16px; color: var(--text-main); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 16px; text-align: left; border-bottom: 1px solid var(--border-color); }
        th { background: #f9fafb; color: var(--text-muted); font-weight: 600; font-size: 13px; text-transform: uppercase; }
        td { color: var(--text-main); font-size: 14px; }
        
        /* Badge Trạng thái */
        .badge { padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; }
        .badge-assigned { background: #dbeafe; color: #1e40af; }
        .badge-returned { background: #dcfce7; color: #166534; }
        .badge-maintenance { background: #fef3c7; color: #92400e; }
    </style>
</head>
<body>
    <jsp:include page="../common/sidebar.jsp" />
    
    <div class="main-content">
        <jsp:include page="../common/topbar.jsp" />
        
        <div class="page-container">
            <div class="dashboard-header">
                <h2>Dashboard Overview</h2>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-total"><i class="fas fa-boxes"></i></div>
                    <div class="stat-info">
                        <p>Total Assets</p>
                        <h3>150</h3>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-available"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-info">
                        <p>Available</p>
                        <h3>85</h3>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-inuse"><i class="fas fa-desktop"></i></div>
                    <div class="stat-info">
                        <p>In Use</p>
                        <h3>45</h3>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-broken"><i class="fas fa-wrench"></i></div>
                    <div class="stat-info">
                        <p>Broken/Maint.</p>
                        <h3>20</h3>
                    </div>
                </div>
            </div>

            <div class="charts-grid">
                <div class="chart-card">
                    <h3>Asset by Types</h3>
                    <canvas id="typeChart" height="120"></canvas>
                </div>
                <div class="chart-card">
                    <h3>Asset Status</h3>
                    <canvas id="statusChart" height="250"></canvas>
                </div>
            </div>

            <div class="table-card">
                <h3>Recent Activity</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Asset ID</th>
                            <th>Asset Name</th>
                            <th>Action</th>
                            <th>User</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>LPT-001</td>
                            <td>Dell Latitude 7420</td>
                            <td><span class="badge badge-assigned">Assigned</span></td>
                            <td>John Doe</td>
                            <td>2026-04-07</td>
                        </tr>
                        <tr>
                            <td>MON-005</td>
                            <td>LG 27" 4K Monitor</td>
                            <td><span class="badge badge-returned">Returned</span></td>
                            <td>Jane Smith</td>
                            <td>2026-04-06</td>
                        </tr>
                        <tr>
                            <td>PRN-002</td>
                            <td>HP LaserJet Pro</td>
                            <td><span class="badge badge-maintenance">Maintenance</span></td>
                            <td>System Admin</td>
                            <td>2026-04-05</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // 1. Vẽ biểu đồ cột (Bar Chart)
        const typeCtx = document.getElementById('typeChart').getContext('2d');
        new Chart(typeCtx, {
            type: 'bar',
            data: {
                labels: ['Laptops', 'Desktops', 'Monitors', 'Printers', 'Others'],
                datasets: [{
                    label: 'Quantity',
                    data: [45, 30, 50, 10, 15], // Dữ liệu giả lập
                    backgroundColor: '#4f46e5',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { 
                    y: { beginAtZero: true, grid: { borderDash: [2, 4] } },
                    x: { grid: { display: false } }
                }
            }
        });

        // 2. Vẽ biểu đồ tròn (Doughnut Chart)
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Available', 'In Use', 'Broken'],
                datasets: [{
                    data: [85, 45, 20], // Dữ liệu giả lập
                    backgroundColor: ['#16a34a', '#0284c7', '#ef4444'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                cutout: '75%',
                plugins: {
                    legend: { position: 'bottom', labels: { padding: 20 } }
                }
            }
        });
    </script>
</body>
</html>