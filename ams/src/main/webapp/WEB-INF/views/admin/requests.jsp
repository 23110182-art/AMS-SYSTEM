<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <title>Request Approval</title>
        <jsp:include page="../common/head_css.jsp" />

        <style>
            .page-header {
                margin-bottom: 24px;
            }

            .page-header h2 {
                margin: 0 0 8px 0;
                color: var(--text-main);
                font-size: 28px;
            }

            .page-header p {
                margin: 0;
                color: var(--text-muted);
                font-size: 15px;
            }

            /* Bảng dữ liệu */
            .table-container {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid var(--border-color);
                padding: 24px;
            }

            .table-container h3 {
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
                padding: 16px;
                text-align: left;
                border-bottom: 1px solid var(--border-color);
            }

            th {
                color: var(--text-main);
                font-weight: 600;
                font-size: 14px;
            }

            td {
                color: var(--text-main);
                font-size: 14px;
            }

            tr:last-child td {
                border-bottom: none;
            }

            /* Nhãn Trạng Thái (Badges) */
            .badge {
                padding: 6px 12px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 500;
                display: inline-block;
                text-align: center;
            }

            .badge-approved {
                background: #dcfce7;
                color: #16a34a;
            }

            /* Xanh lá */
            .badge-pending {
                background: #fef08a;
                color: #854d0e;
            }

            /* Vàng */
            .badge-returned {
                background: #f3f4f6;
                color: #4b5563;
            }

            /* Xám */

            /* Nút Hành động & Text */
            .action-btns {
                display: flex;
                gap: 8px;
                justify-content: flex-end;
            }

            .btn-approve {
                color: #fff;
                background: #10b981;
                border: none;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                transition: 0.2s;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .btn-approve:hover {
                background: #059669;
            }

            .btn-reject {
                color: #ef4444;
                background: #fff;
                border: 1px solid #ef4444;
                padding: 8px 16px;
                border-radius: 6px;
                cursor: pointer;
                transition: 0.2s;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .btn-reject:hover {
                background: #fee2e2;
            }

            .text-action {
                color: var(--text-muted);
                text-align: right;
                display: block;
            }
        </style>
    </head>

    <body>
        <jsp:include page="../common/sidebar.jsp" />

        <div class="main-content">
            <jsp:include page="../common/topbar.jsp" />

            <div class="page-container">
                <div class="page-header">
                    <h2>Request Approval</h2>
                    <p>Review and manage asset requests</p>
                </div>

                <div class="table-container">
                    <h3>All Requests</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Asset</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="requestTableBody"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            const requestTableBody = document.getElementById('requestTableBody');

            function getAuthToken() {
                return localStorage.getItem('jwt_token');
            }

            window.addEventListener('DOMContentLoaded', fetchRequests);

            async function fetchRequests() {
                const token = getAuthToken();

                if (!token) {
                    requestTableBody.innerHTML =
                        '<tr><td colspan="5" style="text-align:center; color:#999; padding:20px;">Admin session not found. Please log in again.</td></tr>';
                    return;
                }

                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/admin/asset-usage/getAll?page=0&size=100', {
                        headers: {
                            'Authorization': 'Bearer ' + token
                        }
                    });
                    const data = await response.json();
                    if (!response.ok || !data.success) throw new Error(data.message || 'Failed to load requests');

                    requestTableBody.innerHTML = '';
                    if (!data.data || !data.data.content || data.data.content.length === 0) {
                        requestTableBody.innerHTML =
                            '<tr><td colspan="5" style="text-align:center; color:#999; padding:20px;">No asset requests found.</td></tr>';
                        return;
                    }

                    data.data.content.forEach(request => {
                        const row = document.createElement('tr');
                        const status = request.status ? request.status.toLowerCase() : 'pending';
                        const statusBadge = renderStatusBadge(status);

                        let actions = '';
                        if (request.status === 'PENDING') {
                            actions = '<td class="action-btns">' +
                                '<button class="btn-approve" onclick="handleRequest(\'approve\', ' + request.id + ')"><i class="fas fa-check"></i> Approve</button>' +
                                '<button class="btn-reject" onclick="handleRequest(\'reject\', ' + request.id + ')"><i class="fas fa-times"></i> Reject</button>' +
                                '</td>';
                        } else {
                            const statusText = status === 'approved' ? 'Approved' : status === 'rejected' ? 'Rejected' : 'Returned';
                            actions = '<td><span class="text-action">' + statusText + '</span></td>';
                        }

                        row.innerHTML = '<td>' + escapeHtml(request.userName || 'Unknown') + '</td>' +
                            '<td>' + escapeHtml(request.assetName || 'Unknown') + '</td>' +
                            '<td>' + formatDate(request.startDate) + '</td>' +
                            '<td>' + statusBadge + '</td>' +
                            actions;
                        requestTableBody.appendChild(row);
                    });
                } catch (error) {
                    alert('Không tải được danh sách yêu cầu: ' + error.message);
                }
            }

            async function handleRequest(action, requestId) {
                const token = getAuthToken();

                if (!token) {
                    alert('Admin session not found. Please log in again.');
                    return;
                }

                try {
                    const response = await fetch('${pageContext.request.contextPath}/api/admin/asset-usage/' + requestId + '/' + action, {
                        method: 'PUT',
                        headers: {
                            'Authorization': 'Bearer ' + token
                        }
                    });
                    const data = await response.json();
                    if (!response.ok || !data.success) throw new Error(data.message || 'Action failed');
                    await fetchRequests();
                } catch (error) {
                    alert('Không thể thực hiện hành động: ' + error.message);
                }
            }

            function renderStatusBadge(status) {
                switch (status.toLowerCase()) {
                    case 'approved':
                        return '<span class="badge badge-approved">approved</span>';
                    case 'rejected':
                        return '<span class="badge badge-returned">rejected</span>';
                    case 'pending':
                    default:
                        return '<span class="badge badge-pending">pending</span>';
                }
            }

            function formatDate(value) {
                if (!value) return '';
                const date = new Date(value);
                return date.toLocaleDateString('vi-VN');
            }

            function escapeHtml(text) {
                return String(text).replace(/["'&<>]/g, function (char) {
                    return { '"': '&quot;', "'": "&#39;", '&': '&amp;', '<': '&lt;', '>': '&gt;' }[char];
                });
            }
        </script>
    </body>

    </html>
