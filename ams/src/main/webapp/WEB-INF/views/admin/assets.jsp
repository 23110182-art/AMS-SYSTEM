<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Asset Management</title>
    <jsp:include page="../common/head_css.jsp" />
    
    <style>
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-header h2 { margin: 0; color: var(--text-main); font-size: 24px; }
        
        .btn-primary { background-color: var(--primary-color); color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer; font-weight: 500; display: flex; align-items: center; gap: 8px; transition: 0.2s; }
        .btn-primary:hover { background-color: #4338ca; }

        /* Khung Bảng và Bộ lọc */
        .table-container { background: #fff; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid var(--border-color); overflow: hidden; }
        .table-filters { display: flex; gap: 16px; padding: 16px; border-bottom: 1px solid var(--border-color); background: #fff; }
        
        /* Thanh Tìm kiếm */
        .search-box { position: relative; width: 300px; }
        .search-box i { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted); }
        .search-box input { width: 100%; padding: 10px 12px 10px 36px; border: 1px solid var(--border-color); border-radius: 8px; outline: none; font-family: 'Inter', sans-serif; box-sizing: border-box; transition: 0.2s;}
        .search-box input:focus { border-color: var(--primary-color); }
        
        /* Dropdown Lọc */
        .filter-select { padding: 10px 16px; border: 1px solid var(--border-color); border-radius: 8px; outline: none; font-family: 'Inter', sans-serif; background-color: #fff; cursor: pointer; color: var(--text-main); transition: 0.2s; }
        .filter-select:focus { border-color: var(--primary-color); }

        /* Bảng Dữ liệu */
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px; text-align: left; border-bottom: 1px solid var(--border-color); }
        th { background: #f9fafb; color: var(--text-muted); font-weight: 600; font-size: 13px; text-transform: uppercase; }
        td { color: var(--text-main); font-size: 14px; }
        tr:hover td { background-color: #f8fafc; }

        /* Nhãn Trạng Thái (Badges) */
        .badge { padding: 6px 12px; border-radius: 999px; font-size: 12px; font-weight: 600; display: inline-block; text-align: center; }
        .badge-available { background: #dcfce7; color: #16a34a; } 
        .badge-inuse { background: #dbeafe; color: #1e40af; } 
        .badge-broken { background: #fee2e2; color: #ef4444; } 

        /* Nút Hành động */
        .action-btns { display: flex; gap: 8px; }
        .btn-edit { color: #0284c7; background: #e0f2fe; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer; transition: 0.2s; }
        .btn-edit:hover { background: #bae6fd; }
        .btn-delete { color: #ef4444; background: #fee2e2; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer; transition: 0.2s; }
        .btn-delete:hover { background: #fecaca; }

        /* Phân Trang (Pagination) */
        .pagination-container { display: flex; justify-content: space-between; align-items: center; padding: 16px; background: #fff; }
        .pagination-info { color: var(--text-muted); font-size: 14px; }
        .pagination-btns { display: flex; gap: 4px; }
        .page-btn { padding: 8px 12px; border: 1px solid var(--border-color); background: #fff; color: var(--text-main); border-radius: 6px; cursor: pointer; font-size: 14px; transition: 0.2s; font-family: 'Inter', sans-serif;}
        .page-btn:hover:not(.active) { background: #f3f4f6; }
        .page-btn.active { background: var(--primary-color); color: #fff; border-color: var(--primary-color); }

        /* Hộp thoại Modal */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 50; align-items: center; justify-content: center; backdrop-filter: blur(2px); }
        .modal-content { background: #fff; width: 450px; border-radius: 12px; padding: 24px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); animation: modalFadeIn 0.3s; }
        @keyframes modalFadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .modal-header h3 { margin: 0; font-size: 18px; color: var(--text-main); }
        .close-btn { background: none; border: none; font-size: 20px; cursor: pointer; color: var(--text-muted); transition: 0.2s; }
        .close-btn:hover { color: var(--text-main); }
        
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; margin-bottom: 6px; font-size: 14px; font-weight: 500; color: var(--text-main); }
        .form-group input, .form-group select { width: 100%; padding: 10px 12px; border: 1px solid var(--border-color); border-radius: 8px; outline: none; box-sizing: border-box; font-family: 'Inter', sans-serif; transition: border 0.2s; background: #fff;}
        .form-group input:focus, .form-group select:focus { border-color: var(--primary-color); }
        
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
                <h2>Asset Management</h2>
                <button class="btn-primary" onclick="openModal()"><i class="fas fa-plus"></i> Add New Asset</button>
            </div>

            <div class="table-container">
                <div class="table-filters">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Search Asset...">
                    </div>
                    <select class="filter-select">
                        <option value="">All Categories</option>
                        <option value="Laptop">Laptop</option>
                        <option value="Monitor">Monitor</option>
                        <option value="Printer">Printer</option>
                    </select>
                    <select class="filter-select">
                        <option value="">All Status</option>
                        <option value="Available">Available</option>
                        <option value="In Use">In Use</option>
                        <option value="Broken">Broken</option>
                    </select>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Asset ID</th>
                            <th>Asset Name</th>
                            <th>Category</th>
                            <th>Status</th>
                            <th width="120px">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>AST-001</td>
                            <td><strong>MacBook Pro 16"</strong></td>
                            <td>Laptop</td>
                            <td><span class="badge badge-available">Available</span></td>
                            <td class="action-btns">
                                <button class="btn-edit" title="Edit" onclick="openModal('AST-001', 'MacBook Pro 16\'', 'Laptop', 'Available')"><i class="fas fa-edit"></i></button>
                                <button class="btn-delete" title="Delete"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>AST-002</td>
                            <td><strong>Dell UltraSharp 27"</strong></td>
                            <td>Monitor</td>
                            <td><span class="badge badge-inuse">In Use</span></td>
                            <td class="action-btns">
                                <button class="btn-edit" title="Edit" onclick="openModal('AST-002', 'Dell UltraSharp 27\'', 'Monitor', 'In Use')"><i class="fas fa-edit"></i></button>
                                <button class="btn-delete" title="Delete"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>AST-003</td>
                            <td><strong>HP LaserJet Pro</strong></td>
                            <td>Printer</td>
                            <td><span class="badge badge-broken">Broken</span></td>
                            <td class="action-btns">
                                <button class="btn-edit" title="Edit" onclick="openModal('AST-003', 'HP LaserJet Pro', 'Printer', 'Broken')"><i class="fas fa-edit"></i></button>
                                <button class="btn-delete" title="Delete"><i class="fas fa-trash"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination-container">
                    <div class="pagination-info">Showing 1 to 3 of 150 entries</div>
                    <div class="pagination-btns">
                        <button class="page-btn">Previous</button>
                        <button class="page-btn active">1</button>
                        <button class="page-btn">2</button>
                        <button class="page-btn">3</button>
                        <button class="page-btn">Next</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal-overlay" id="assetModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">Add New Asset</h3>
                <button class="close-btn" onclick="closeModal()"><i class="fas fa-times"></i></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="assetId"> 
                
                <div class="form-group">
                    <label>Asset Name</label>
                    <input type="text" id="assetName" placeholder="Enter asset name">
                </div>
                
                <div class="form-group">
                    <label>Category</label>
                    <select id="assetCategory">
                        <option value="Laptop">Laptop</option>
                        <option value="Monitor">Monitor</option>
                        <option value="Printer">Printer</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Status</label>
                    <select id="assetStatus">
                        <option value="Available">Available</option>
                        <option value="In Use">In Use</option>
                        <option value="Broken">Broken</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn-primary" onclick="saveAsset()">Save Asset</button>
            </div>
        </div>
    </div>

    <script>
        // Mở Modal (dùng chung cho Add và Edit)
        function openModal(id = null, name = '', category = 'Laptop', status = 'Available') {
            document.getElementById('assetModal').style.display = 'flex';
            
            if (id) {
                // Chế độ Edit
                document.getElementById('modalTitle').innerText = 'Edit Asset';
                document.getElementById('assetId').value = id;
                document.getElementById('assetName').value = name;
                document.getElementById('assetCategory').value = category;
                document.getElementById('assetStatus').value = status;
            } else {
                // Chế độ Add Mới
                document.getElementById('modalTitle').innerText = 'Add New Asset';
                document.getElementById('assetId').value = '';
                document.getElementById('assetName').value = '';
                document.getElementById('assetCategory').value = 'Laptop';
                document.getElementById('assetStatus').value = 'Available';
            }
        }

        function closeModal() {
            document.getElementById('assetModal').style.display = 'none';
        }

        window.onclick = function(event) {
            let modal = document.getElementById('assetModal');
            if (event.target === modal) {
                closeModal();
            }
        }

        function saveAsset() {
            const name = document.getElementById('assetName').value;
            if(!name) {
                alert("Please enter Asset Name!");
                return;
            }
            alert("Chức năng đang mô phỏng! Tài sản đã được lưu: " + name);
            closeModal();
        }
    </script>
</body>
</html>