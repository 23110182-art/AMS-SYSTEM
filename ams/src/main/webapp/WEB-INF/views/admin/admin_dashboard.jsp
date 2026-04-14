<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <title>Admin Dashboard</title>
        <jsp:include page="../common/head_css.jsp" />

        <style>
            .dashboard-header {
                margin-bottom: 24px;
            }

            .dashboard-header h2 {
                margin: 0;
                color: var(--text-main);
                font-size: 24px;
            }

            /* Cấu trúc 4 thẻ thống kê */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 24px;
                margin-bottom: 32px;
            }

            .stat-card {
                background: #fff;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                gap: 16px;
                border: 1px solid var(--border-color);
            }

            .stat-icon {
                width: 56px;
                height: 56px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
            }

            .stat-info p {
                margin: 0;
                color: var(--text-muted);
                font-size: 14px;
                font-weight: 500;
            }

            .stat-info h3 {
                margin: 4px 0 0;
                color: var(--text-main);
                font-size: 28px;
                font-weight: 700;
            }

            /* Màu cho từng icon */
            .icon-total {
                background: #eef2ff;
                color: #4f46e5;
            }

            .icon-available {
                background: #dcfce7;
                color: #16a34a;
            }

            .icon-inuse {
                background: #e0f2fe;
                color: #0284c7;
            }

            .icon-broken {
                background: #fee2e2;
                color: #ef4444;
            }

            /* Cấu trúc Biểu đồ */
            .charts-grid {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 24px;
                margin-bottom: 32px;
            }

            .chart-card {
                background: #fff;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid var(--border-color);
            }

            .chart-card h3 {
                margin-top: 0;
                margin-bottom: 20px;
                font-size: 16px;
                color: var(--text-main);
            }

            /* Cấu trúc Bảng dữ liệu */
            .table-card {
                background: #fff;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid var(--border-color);
            }

            .table-card h3 {
                margin-top: 0;
                margin-bottom: 20px;
                font-size: 16px;
                color: var(--text-main);
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            th,
            td {
                padding: 14px 16px;
                text-align: left;
                border-bottom: 1px solid var(--border-color);
            }

            th {
                background: #f9fafb;
                color: var(--text-muted);
                font-weight: 600;
                font-size: 13px;
                text-transform: uppercase;
            }

            td {
                color: var(--text-main);
                font-size: 14px;
            }

            /* Badge Trạng thái */
            .badge {
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
            }

            .badge-assigned {
                background: #dbeafe;
                color: #1e40af;
            }

            .badge-returned {
                background: #dcfce7;
                color: #166534;
            }

            .badge-maintenance {
                background: #fef3c7;
                color: #92400e;
            }
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
                            <h3 id="totalAssets">...</h3>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon icon-available"><i class="fas fa-check-circle"></i></div>
                        <div class="stat-info">
                            <p>Available</p>
                            <h3 id="availableAssets">...</h3>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon icon-inuse"><i class="fas fa-desktop"></i></div>
                        <div class="stat-info">
                            <p>In Use</p>
                            <h3 id="inUseAssets">...</h3>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon icon-broken"><i class="fas fa-wrench"></i></div>
                        <div class="stat-info">
                            <p>Broken/Maint.</p>
                            <h3 id="brokenAssets">...</h3>
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
                        <tbody id="activityTableBody">
                            <tr>
                                <td colspan="5" style="text-align: center; color: #999;">Loading...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            const totalAssetsEl = document.getElementById('totalAssets');
            const availableAssetsEl = document.getElementById('availableAssets');
            const inUseAssetsEl = document.getElementById('inUseAssets');
            const brokenAssetsEl = document.getElementById('brokenAssets');

            const typeCtx = document.getElementById('typeChart').getContext('2d');
            const typeChart = new Chart(typeCtx, {
                type: 'bar',
                data: {
                    labels: [],
                    datasets: [{
                        label: 'Quantity',
                        data: [],
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

            const statusCtx = document.getElementById('statusChart').getContext('2d');
            const statusChart = new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Available', 'In Use', 'Broken'],
                    datasets: [{
                        data: [0, 0, 0],
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

            async function loadDashboardData() {
                try {
                    const [totalRes, availableRes, inUseRes, brokenRes, typeRes] = await Promise.all([
                        fetch('/api/admin/asset/count'),
                        fetch('/api/admin/asset/count?status=AVAILABLE'),
                        fetch('/api/admin/asset/count?status=IN_USE'),
                        fetch('/api/admin/asset/count?status=BROKEN'),
                        fetch('/api/admin/asset/statisticByType')
                    ]);

                    const totalData = await totalRes.json();
                    const availableData = await availableRes.json();
                    const inUseData = await inUseRes.json();
                    const brokenData = await brokenRes.json();
                    const typeData = await typeRes.json();

                    if (!totalData.success || !availableData.success || !inUseData.success || !brokenData.success || !typeData.success) {
                        throw new Error('Cannot load dashboard data');
                    }

                    totalAssetsEl.innerText = totalData.data;
                    availableAssetsEl.innerText = availableData.data;
                    inUseAssetsEl.innerText = inUseData.data;
                    brokenAssetsEl.innerText = brokenData.data;

                    const labels = Object.keys(typeData.data || {});
                    const values = Object.values(typeData.data || {});
                    typeChart.data.labels = labels;
                    typeChart.data.datasets[0].data = values;
                    typeChart.update();

                    statusChart.data.datasets[0].data = [availableData.data, inUseData.data, brokenData.data];
                    statusChart.update();
                } catch (error) {
                    console.error('Dashboard load error:', error);
                }
            }

            window.addEventListener('DOMContentLoaded', loadDashboardData);

            async function loadRecentActivity() {
                try {
                    const response = await fetch('/api/admin/asset-usage/getAll?page=0&size=10');
                    const data = await response.json();

                    if (!data.success) {
                        throw new Error(data.message || 'Failed to load recent activity');
                    }

                    const activityTableBody = document.getElementById('activityTableBody');
                    activityTableBody.innerHTML = '';

                    if (!data.data.content || data.data.content.length === 0) {
                        activityTableBody.innerHTML = '<tr><td colspan="5" style="text-align: center; color: #999;">No recent activity</td></tr>';
                        return;
                    }

                    data.data.content.forEach(activity => {
                        const row = document.createElement('tr');

                        let actionBadge = '';
                        const status = activity.status ? activity.status.toLowerCase() : '';
                        if (status === 'approved') {
                            actionBadge = '<span class="badge badge-assigned">Assigned</span>';
                        } else if (status === 'returned') {
                            actionBadge = '<span class="badge badge-returned">Returned</span>';
                        } else if (status === 'pending') {
                            actionBadge = '<span class="badge badge-maintenance">Pending</span>';
                        } else if (status === 'rejected') {
                            actionBadge = '<span class="badge" style="background: #fee2e2; color: #dc2626;">Rejected</span>';
                        }

                        const startDate = new Date(activity.startDate).toLocaleDateString('vi-VN');

                        row.innerHTML = '<td>' + (activity.assetId || '-') + '</td>' +
                            '<td>' + (activity.assetName || 'Unknown') + '</td>' +
                            '<td>' + actionBadge + '</td>' +
                            '<td>' + (activity.userName || 'Unknown') + '</td>' +
                            '<td>' + startDate + '</td>';

                        activityTableBody.appendChild(row);
                    });
                } catch (error) {
                    console.error('Recent activity load error:', error);
                    const activityTableBody = document.getElementById('activityTableBody');
                    activityTableBody.innerHTML = '<tr><td colspan="5" style="text-align: center; color: #e74c3c;">Error loading activity</td></tr>';
                }
            }

            window.addEventListener('DOMContentLoaded', function () {
                loadDashboardData();
                loadRecentActivity();
            });
        </script>
    </body>

    </html>