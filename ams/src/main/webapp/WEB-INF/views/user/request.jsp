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
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
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

        .table th, .table td {
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
        .badge.pending { background: #fef3c7; color: #d97706; } /* Màu vàng: Chờ duyệt */
        .badge.approved { background: #d1fae5; color: #059669; } /* Màu xanh: Đã duyệt */
        .badge.rejected { background: #fee2e2; color: #dc2626; } /* Màu đỏ: Từ chối */

        /* Nút thao tác (Action buttons) */
        .btn-action {
            background: none;
            border: none;
            cursor: pointer;
            padding: 8px;
            border-radius: 6px;
            transition: 0.2s;
            font-size: 16px;
            margin-right: 4px;
        }
        .btn-approve { color: #059669; background-color: #ecfdf5; }
        .btn-approve:hover { background-color: #d1fae5; }
        
        .btn-reject { color: #dc2626; background-color: #fef2f2; }
        .btn-reject:hover { background-color: #fee2e2; }
        
        .btn-view { color: var(--primary-color); background-color: #eef2ff; }
        .btn-view:hover { background-color: #e0e7ff; }
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
                                <th>Ngày tạo</th>
                                <th>Lý do</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><b>#REQ001</b></td>
                                <td>Nguyễn Văn A</td>
                                <td>Laptop Dell Latitude</td>
                                <td>12/04/2026</td>
                                <td>Mượn đi công tác tại Hà Nội</td>
                                <td><span class="badge pending">Chờ duyệt</span></td>
                                <td>
                                    <button class="btn-action btn-approve" title="Phê duyệt"><i class="fa-solid fa-check"></i></button>
                                    <button class="btn-action btn-reject" title="Từ chối"><i class="fa-solid fa-xmark"></i></button>
                                    <button class="btn-action btn-view" title="Xem chi tiết"><i class="fa-solid fa-eye"></i></button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><b>#REQ002</b></td>
                                <td>Trần Thị B</td>
                                <td>Màn hình Dell 24inch</td>
                                <td>11/04/2026</td>
                                <td>Xin cấp thêm màn hình phụ</td>
                                <td><span class="badge approved">Đã duyệt</span></td>
                                <td>
                                    <button class="btn-action btn-view" title="Xem chi tiết"><i class="fa-solid fa-eye"></i></button>
                                </td>
                            </tr>
                            
                            <tr>
                                <td><b>#REQ003</b></td>
                                <td>Lê Hoàng C</td>
                                <td>Chuột không dây Logitech</td>
                                <td>10/04/2026</td>
                                <td>Chuột cũ bị hỏng click trái</td>
                                <td><span class="badge rejected">Từ chối</span></td>
                                <td>
                                    <button class="btn-action btn-view" title="Xem chi tiết"><i class="fa-solid fa-eye"></i></button>
                                </td>
                            </tr>
                            
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>
</body>
</html>