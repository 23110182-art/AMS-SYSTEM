<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Asset Types Management</title>
    <jsp:include page="../common/head_css.jsp" />
    
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-header h2 { margin: 0; color: var(--text-main); font-size: 24px; }
        
        .btn-primary { background-color: var(--primary-color); color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-primary:hover { background-color: #4338ca; }

        /* Bảng dữ liệu */
        .table-container { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px; text-align: left; border-bottom: 1px solid var(--border-color); }
        th { background: #f9fafb; color: var(--text-muted); font-weight: 600; font-size: 13px; text-transform: uppercase; }
        td { color: var(--text-main); font-size: 14px; }
        tr:hover td { background-color: #f8fafc; }
        tr:last-child td { border-bottom: none; }

        /* Nút hành động trong bảng */
        .action-btns { display: flex; gap: 8px; }
        .btn-edit { color: #0284c7; background: #e0f2fe; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer; transition: 0.2s; }
        .btn-edit:hover { background: #bae6fd; }
        .btn-delete { color: #ef4444; background: #fee2e2; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer; transition: 0.2s; }
        .btn-delete:hover { background: #fecaca; }

        /* Hộp thoại Modal (Popup) */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 50; align-items: center; justify-content: center; backdrop-filter: blur(2px); }
        .modal-content { background: #fff; width: 400px; border-radius: 12px; padding: 24px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); animation: modalFadeIn 0.3s; }
        @keyframes modalFadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .modal-header h3 { margin: 0; font-size: 18px; color: var(--text-main); }
        .close-btn { background: none; border: none; font-size: 20px; cursor: pointer; color: var(--text-muted); transition: 0.2s; }
        .close-btn:hover { color: var(--text-main); }
        
        /* Form trong Modal */
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-size: 14px; font-weight: 500; color: var(--text-main); }
        .form-group input { width: 100%; padding: 10px 12px; border: 1px solid var(--border-color); border-radius: 8px; outline: none; box-sizing: border-box; font-family: 'Inter', sans-serif; transition: border 0.2s; }
        .form-group input:focus { border-color: var(--primary-color); }
        
        .modal-footer { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; }
        .btn-secondary { background: #f3f4f6; color: var(--text-main); border: none; padding: 10px 16px; border-radius: 8px; cursor: pointer; font-weight: 500; transition: 0.2s; }
        .btn-secondary:hover { background: #e5e7eb; }
    </style>
</head>
<body>
    <jsp:include page="../common/sidebar.jsp" />
    
    <div class="main-content">
        <jsp:include page="../common/topbar.jsp" />
        
        <div class="page-container">
            <div class="page-header">
                <h2>Asset Types Management</h2>
                <button class="btn-primary" onclick="openModal()"><i class="fas fa-plus"></i> Add New Type</button>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type Name</th>
                            <th width="120px">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="typeTableBody">
                        <tr>
                            <td>1</td>
                            <td><strong>Laptop</strong></td>
                            <td class="action-btns">
                                <button class="btn-edit" title="Edit" onclick="openModal('1', 'Laptop')"><i class="fas fa-edit"></i></button>
                                <button class="btn-delete" title="Delete"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td><strong>Monitor</strong></td>
                            <td class="action-btns">
                                <button class="btn-edit" title="Edit" onclick="openModal('2', 'Monitor')"><i class="fas fa-edit"></i></button>
                                <button class="btn-delete" title="Delete"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td><strong>Printer</strong></td>
                            <td class="action-btns">
                                <button class="btn-edit" title="Edit" onclick="openModal('3', 'Printer')"><i class="fas fa-edit"></i></button>
                                <button class="btn-delete" title="Delete"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="typeModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Add Asset Type</h3>
                <button class="close-btn" onclick="closeModal()"><i class="fas fa-times"></i></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="typeId"> 
                <div class="form-group">
                    <label>Type Name</label>
                    <input type="text" id="typeName" placeholder="Enter type name (e.g. Keyboard)">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn-primary" onclick="saveType()">Save Changes</button>
            </div>
        </div>
    </div>

    <script>
        // Mở Modal (dùng cho cả Add và Edit - Đã bỏ tham số desc)
        function openModal(id = null, name = '') {
            document.getElementById('typeModal').style.display = 'flex';
            
            if (id) {
                document.getElementById('modalTitle').innerText = 'Edit Asset Type';
                document.getElementById('typeId').value = id;
                document.getElementById('typeName').value = name;
            } else {
                document.getElementById('modalTitle').innerText = 'Add Asset Type';
                document.getElementById('typeId').value = '';
                document.getElementById('typeName').value = '';
            }
        }

        // Đóng Modal
        function closeModal() {
            document.getElementById('typeModal').style.display = 'none';
        }

        // Đóng Modal khi click ra vùng đen bên ngoài
        window.onclick = function(event) {
            let modal = document.getElementById('typeModal');
            if (event.target === modal) {
                closeModal();
            }
        }

        // Xử lý nút Save
        function saveType() {
            const name = document.getElementById('typeName').value;
            
            if(!name) {
                alert("Please enter Type Name!");
                return;
            }

            alert("Chức năng đang mô phỏng! Dữ liệu sẽ lưu: " + name);
            closeModal();
            
            /* TODO: Thêm logic gọi API
            fetch('/api/admin/assetType/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ' + localStorage.getItem('jwt_token')
                },
                body: JSON.stringify({ name: name })
            }).then(...)
            */
        }
    </script>
</body>
</html>