<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Request Approval</title>
    <jsp:include page="../common/head_css.jsp" />
    
    <style>
        .page-header { margin-bottom: 24px; }
        .page-header h2 { margin: 0 0 8px 0; color: var(--text-main); font-size: 28px; }
        .page-header p { margin: 0; color: var(--text-muted); font-size: 15px; }
        
        /* Bảng dữ liệu */
        .table-container { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); padding: 24px; }
        .table-container h3 { margin-top: 0; margin-bottom: 20px; font-size: 16px; color: var(--text-main); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px; text-align: left; border-bottom: 1px solid var(--border-color); }
        th { color: var(--text-main); font-weight: 600; font-size: 14px; }
        td { color: var(--text-main); font-size: 14px; }
        tr:last-child td { border-bottom: none; }

        /* Nhãn Trạng Thái (Badges) */
        .badge { padding: 6px 12px; border-radius: 999px; font-size: 12px; font-weight: 500; display: inline-block; text-align: center; }
        .badge-approved { background: #dcfce7; color: #16a34a; } /* Xanh lá */
        .badge-pending { background: #fef08a; color: #854d0e; } /* Vàng */
        .badge-returned { background: #f3f4f6; color: #4b5563; } /* Xám */

        /* Nút Hành động & Text */
        .action-btns { display: flex; gap: 8px; justify-content: flex-end;}
        .btn-approve { color: #fff; background: #10b981; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; transition: 0.2s; font-weight: 500; display: flex; align-items: center; gap: 6px;}
        .btn-approve:hover { background: #059669; }
        .btn-reject { color: #ef4444; background: #fff; border: 1px solid #ef4444; padding: 8px 16px; border-radius: 6px; cursor: pointer; transition: 0.2s; font-weight: 500; display: flex; align-items: center; gap: 6px;}
        .btn-reject:hover { background: #fee2e2; }
        
        .text-action { color: var(--text-muted); text-align: right; display: block;}
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
                    <tbody>
                        <tr>
                            <td>user</td>
                            <td>Dell XPS 15</td>
                            <td>25/3/2026</td>
                            <td><span class="badge badge-approved">approved</span></td>
                            <td><span class="text-action">Approved</span></td>
                        </tr>
                        <tr>
                            <td>user</td>
                            <td>Samsung 27" 4K</td>
                            <td>26/3/2026</td>
                            <td><span class="badge badge-pending">pending</span></td>
                            <td class="action-btns">
                                <button class="btn-approve" onclick="handleRequest('approve', 'REQ-002')"><i class="fas fa-check"></i> Approve</button>
                                <button class="btn-reject" onclick="handleRequest('reject', 'REQ-002')"><i class="fas fa-times"></i> Reject</button>
                            </td>
                        </tr>
                        <tr>
                            <td>user</td>
                            <td>Sony WH-1000XM5</td>
                            <td>20/3/2026</td>
                            <td><span class="badge badge-returned">returned</span></td>
                            <td><span class="text-action">Returned</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function handleRequest(action, requestId) {
            if (action === 'approve') {
                alert('Mô phỏng: Đã PHÊ DUYỆT yêu cầu ' + requestId);
            } else if (action === 'reject') {
                alert('Mô phỏng: Đã TỪ CHỐI yêu cầu ' + requestId);
            }
            
            /* TODO: Nơi gọi API Backend sau này
            fetch('/api/admin/requests/' + requestId + '/' + action, {
                method: 'POST',
                headers: { 'Authorization': 'Bearer ' + localStorage.getItem('jwt_token') }
            }).then(...)
            */
        }
    </script>
</body>
</html>