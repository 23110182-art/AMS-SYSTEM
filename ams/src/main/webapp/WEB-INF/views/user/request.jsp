<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="jakarta.tags.core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý Yêu cầu - AMS SYSTEM</title>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">

            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

            <style>
                /* --- BỔ SUNG CSS CHO BẢNG VÀ NÚT --- */
                .content-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 24px;
                }

                .card {
                    background-color: #ffffff;
                    border-radius: 12px;
                    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                    border: 1px solid var(--border-color);
                    overflow: hidden;
                }

                .table-responsive {
                    overflow-x: auto;
                }

                .table {
                    width: 100%;
                    border-collapse: collapse;
                    text-align: left;
                }

                .table th,
                .table td {
                    padding: 16px 20px;
                    border-bottom: 1px solid var(--border-color);
                    color: var(--text-main);
                }

                .table th {
                    background-color: #f9fafb;
                    color: var(--text-muted);
                    font-weight: 600;
                    font-size: 14px;
                    text-transform: uppercase;
                }

                .table tr:hover {
                    background-color: #f9fafb;
                }

                /* Nút trạng thái (Badge) */
                .badge {
                    padding: 6px 12px;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: 600;
                    display: inline-block;
                }

                .badge.pending {
                    background: #fef3c7;
                    color: #d97706;
                }

                /* Màu vàng: Chờ duyệt */
                .badge.approved {
                    background: #d1fae5;
                    color: #059669;
                }

                /* Màu xanh: Đã duyệt */
                .badge.rejected {
                    background: #fee2e2;
                    color: #dc2626;
                }

                .badge.returned {
                    background: #e5e7eb;
                    color: #4b5563;
                }

                .table td.actions-cell {
                    text-align: center;
                }

                .btn-return {
                    border: none;
                    border-radius: 8px;
                    padding: 8px 14px;
                    font-size: 13px;
                    font-weight: 600;
                    color: #ffffff;
                    background: #2563eb;
                    cursor: pointer;
                    transition: background 0.2s ease;
                }

                .btn-return:hover {
                    background: #1d4ed8;
                }

                .empty-state {
                    text-align: center;
                    color: #94a3b8;
                    padding: 24px;
                }
            </style>
        </head>

        <body>
            <jsp:include page="../common/user_sidebar.jsp" />

            <div class="main-content">
                <jsp:include page="../common/user_topbar.jsp" />

                <div class="page-container">

                    <div class="content-header">
                        <h2 class="page-title">Danh sách Yêu cầu mượn tài sản</h2>
                    </div>

                    <div class="card">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Mã YC</th>
                                        <th>Người yêu cầu</th>
                                        <th>Tên tài sản</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Ngày kết thúc</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="requestTableBody">
                                    <tr>
                                        <td colspan="7" style="text-align: center; color: #999; padding: 20px;">
                                            Loading...</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>
            </div>

            <script>
                const requestTableBody = document.getElementById('requestTableBody');

                function getAuthToken() {
                    return localStorage.getItem('jwt_token');
                }

                function escapeHtml(text) {
                    return String(text || '').replace(/["'&<>]/g, function (char) {
                        return { '"': '&quot;', "'": '&#39;', '&': '&amp;', '<': '&lt;', '>': '&gt;' }[char];
                    });
                }

                function formatDate(value) {
                    if (!value) {
                        return '';
                    }

                    const date = new Date(value);
                    if (Number.isNaN(date.getTime())) {
                        return escapeHtml(value);
                    }

                    return date.toLocaleDateString('vi-VN');
                }

                function renderStatusBadge(status) {
                    const normalizedStatus = String(status || 'PENDING').toLowerCase();
                    const label = normalizedStatus.charAt(0).toUpperCase() + normalizedStatus.slice(1);

                    return '<span class="badge ' + normalizedStatus + '">' + escapeHtml(label) + '</span>';
                }

                function renderActionCell(request) {
                    if (request.status === 'APPROVED') {
                        return '<button class="btn-return" onclick="returnAsset(' + request.id + ')">Return</button>';
                    }

                    if (request.status === 'RETURNED') {
                        return 'Returned';
                    }

                    if (request.status === 'REJECTED') {
                        return 'Rejected';
                    }

                    return '-';
                }

                async function loadMyRequests() {
                    const token = getAuthToken();

                    if (!token) {
                        requestTableBody.innerHTML =
                            '<tr><td colspan="7" class="empty-state">Bạn chưa đăng nhập hoặc phiên đã hết hạn.</td></tr>';
                        return;
                    }

                    try {
                        const response = await fetch('${pageContext.request.contextPath}/api/users/asset-usage/my?page=0&size=100', {
                            headers: {
                                'Authorization': 'Bearer ' + token
                            }
                        });

                        const data = await response.json();

                        if (!response.ok || !data.success) {
                            throw new Error(data.message || 'Failed to load requests');
                        }

                        const requests = data.data && data.data.content ? data.data.content : [];

                        if (requests.length === 0) {
                            requestTableBody.innerHTML =
                                '<tr><td colspan="7" class="empty-state">Bạn chưa có yêu cầu mượn tài sản nào.</td></tr>';
                            return;
                        }

                        requestTableBody.innerHTML = requests.map(function (request) {
                            return '<tr>' +
                                '<td>#' + escapeHtml(request.id) + '</td>' +
                                '<td>' + escapeHtml(request.userName || '') + '</td>' +
                                '<td>' + escapeHtml(request.assetName || '') + '</td>' +
                                '<td>' + formatDate(request.startDate) + '</td>' +
                                '<td>' + formatDate(request.endDate) + '</td>' +
                                '<td>' + renderStatusBadge(request.status) + '</td>' +
                                '<td class="actions-cell">' + renderActionCell(request) + '</td>' +
                                '</tr>';
                        }).join('');
                    } catch (error) {
                        requestTableBody.innerHTML =
                            '<tr><td colspan="7" class="empty-state">Không tải được danh sách yêu cầu: ' +
                            escapeHtml(error.message) + '</td></tr>';
                    }
                }

                async function returnAsset(requestId) {
                    const token = getAuthToken();

                    if (!token) {
                        alert('Bạn chưa đăng nhập hoặc phiên đã hết hạn.');
                        return;
                    }

                    if (!confirm('Bạn có chắc muốn trả lại tài sản này không?')) {
                        return;
                    }

                    try {
                        const response = await fetch('${pageContext.request.contextPath}/api/users/asset-usage/' + requestId + '/return', {
                            method: 'PUT',
                            headers: {
                                'Authorization': 'Bearer ' + token
                            }
                        });

                        const data = await response.json();

                        if (!response.ok || !data.success) {
                            throw new Error(data.message || 'Return asset failed');
                        }

                        await loadMyRequests();
                    } catch (error) {
                        alert('Không thể trả tài sản: ' + error.message);
                    }
                }

                window.addEventListener('DOMContentLoaded', loadMyRequests);
            </script>
        </body>

        </html>
