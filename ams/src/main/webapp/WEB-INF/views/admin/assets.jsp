<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <title>Asset Management</title>
        <jsp:include page="../common/head_css.jsp" />

        <style>
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
            }

            .page-header h2 {
                margin: 0;
                color: var(--text-main);
                font-size: 24px;
            }

            .btn-primary {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: 0.2s;
            }

            .btn-primary:hover {
                background-color: #4338ca;
            }

            /* Khung Bảng và Bộ lọc */
            .table-container {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                border: 1px solid var(--border-color);
                overflow: hidden;
            }

            .table-filters {
                display: flex;
                gap: 16px;
                padding: 16px;
                border-bottom: 1px solid var(--border-color);
                background: #fff;
            }

            /* Thanh Tìm kiếm */
            .search-box {
                position: relative;
                width: 300px;
            }

            .search-box i {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-muted);
            }

            .search-box input {
                width: 100%;
                padding: 10px 12px 10px 36px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                outline: none;
                font-family: 'Inter', sans-serif;
                box-sizing: border-box;
                transition: 0.2s;
            }

            .search-box input:focus {
                border-color: var(--primary-color);
            }

            /* Dropdown Lọc */
            .filter-select {
                padding: 10px 16px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                outline: none;
                font-family: 'Inter', sans-serif;
                background-color: #fff;
                cursor: pointer;
                color: var(--text-main);
                transition: 0.2s;
            }

            .filter-select:focus {
                border-color: var(--primary-color);
            }

            /* Bảng Dữ liệu */
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

            tr:hover td {
                background-color: #f8fafc;
            }

            /* Nhãn Trạng Thái (Badges) */
            .badge {
                padding: 6px 12px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
                text-align: center;
            }

            .badge-available {
                background: #dcfce7;
                color: #16a34a;
            }

            .badge-inuse {
                background: #dbeafe;
                color: #1e40af;
            }

            .badge-broken {
                background: #fee2e2;
                color: #ef4444;
            }

            /* Nút Hành động */
            .action-btns {
                display: flex;
                gap: 8px;
            }

            .btn-edit {
                color: #0284c7;
                background: #e0f2fe;
                border: none;
                padding: 8px 12px;
                border-radius: 6px;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-edit:hover {
                background: #bae6fd;
            }

            .btn-delete {
                color: #ef4444;
                background: #fee2e2;
                border: none;
                padding: 8px 12px;
                border-radius: 6px;
                cursor: pointer;
                transition: 0.2s;
            }

            .btn-delete:hover {
                background: #fecaca;
            }

            /* Phân Trang (Pagination) */
            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 16px;
                background: #fff;
            }

            .pagination-info {
                color: var(--text-muted);
                font-size: 14px;
            }

            .pagination-btns {
                display: flex;
                gap: 4px;
            }

            .page-btn {
                padding: 8px 12px;
                border: 1px solid var(--border-color);
                background: #fff;
                color: var(--text-main);
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                transition: 0.2s;
                font-family: 'Inter', sans-serif;
            }

            .page-btn:hover:not(.active) {
                background: #f3f4f6;
            }

            .page-btn.active {
                background: var(--primary-color);
                color: #fff;
                border-color: var(--primary-color);
            }

            /* Hộp thoại Modal */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 50;
                align-items: center;
                justify-content: center;
                backdrop-filter: blur(2px);
            }

            .modal-content {
                background: #fff;
                width: 450px;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                animation: modalFadeIn 0.3s;
            }

            @keyframes modalFadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .modal-header h3 {
                margin: 0;
                font-size: 18px;
                color: var(--text-main);
            }

            .close-btn {
                background: none;
                border: none;
                font-size: 20px;
                cursor: pointer;
                color: var(--text-muted);
                transition: 0.2s;
            }

            .close-btn:hover {
                color: var(--text-main);
            }

            .form-group {
                margin-bottom: 16px;
            }

            .form-group label {
                display: block;
                margin-bottom: 6px;
                font-size: 14px;
                font-weight: 500;
                color: var(--text-main);
            }

            .form-group input,
            .form-group select {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid var(--border-color);
                border-radius: 8px;
                outline: none;
                box-sizing: border-box;
                font-family: 'Inter', sans-serif;
                transition: border 0.2s;
                background: #fff;
            }

            .form-group input:focus,
            .form-group select:focus {
                border-color: var(--primary-color);
            }

            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                margin-top: 24px;
            }

            .btn-secondary {
                background: #f3f4f6;
                color: var(--text-main);
                border: none;
                padding: 10px 16px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: 0.2s;
            }

            .btn-secondary:hover {
                background: #e5e7eb;
            }
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
                            <input type="text" id="searchInput" placeholder="Search Asset..." oninput="filterAssets()">
                        </div>
                        <select class="filter-select" id="typeFilter" onchange="filterAssets()">
                            <option value="">All Categories</option>
                        </select>
                        <select class="filter-select" id="statusFilter" onchange="filterAssets()">
                            <option value="">All Status</option>
                            <option value="AVAILABLE">Available</option>
                            <option value="IN_USE">In Use</option>
                            <option value="BROKEN">Broken</option>
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
                        <tbody id="assetTableBody"></tbody>
                    </table>

                    <div class="pagination-container">
                        <div class="pagination-info" id="paginationInfo">Showing 0 to 0 of 0 entries</div>
                        <div class="pagination-btns">
                            <button class="page-btn" id="prevPageBtn" onclick="changePage(-1)">Previous</button>
                            <button class="page-btn active" id="pageIndicator" type="button">1 / 1</button>
                            <button class="page-btn" id="nextPageBtn" onclick="changePage(1)">Next</button>
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
                            <option value="">Loading categories...</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Status</label>
                        <select id="assetStatus">
                            <option value="AVAILABLE">Available</option>
                            <option value="IN_USE">In Use</option>
                            <option value="BROKEN">Broken</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Quantity</label>
                        <input type="number" id="assetQuantity" min="1" value="1" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn-secondary" onclick="closeModal()">Cancel</button>
                    <button class="btn-primary" onclick="saveAsset()">Save Asset</button>
                </div>
            </div>
        </div>

        <script>
            const assetTableBody = document.getElementById('assetTableBody');
            const assetCategory = document.getElementById('assetCategory');
            const typeFilter = document.getElementById('typeFilter');
            let assets = [];
            let currentPage = 0;
            let pageSize = 10;
            let totalPages = 0;
            let totalElements = 0;

            window.addEventListener('DOMContentLoaded', async () => {
                await loadAssetCategories();
                fetchAssets(0);
            });

            function escapeHtml(text) {
                return String(text || '').replace(/["'&<>]/g, function (char) {
                    return { '"': '&quot;', "'": '&#39;', '&': '&amp;', '<': '&lt;', '>': '&gt;' }[char];
                });
            }

            function populateTypeFilter() {
                const selectedType = typeFilter.value;
                const types = Array.from(assetCategory.options)
                    .map(function (option) { return option.value; })
                    .filter(Boolean);

                typeFilter.innerHTML = '<option value="">All Categories</option>' + types.map(function (type) {
                    const selected = type === selectedType ? ' selected' : '';
                    return '<option value="' + escapeHtml(type) + '"' + selected + '>' + escapeHtml(type) + '</option>';
                }).join('');
            }

            function buildAssetQuery(page) {
                const searchValue = document.getElementById('searchInput').value.trim();
                const selectedType = typeFilter.value;
                const selectedStatus = document.getElementById('statusFilter').value;
                const params = new URLSearchParams({
                    page: String(page),
                    size: String(pageSize)
                });

                if (searchValue) {
                    params.set('keyword', searchValue);
                }

                if (selectedType) {
                    params.set('assetTypeName', selectedType);
                }

                if (selectedStatus) {
                    params.set('status', selectedStatus);
                }

                return params.toString();
            }

            function renderAssets(data) {
                assetTableBody.innerHTML = '';

                if (!data.length) {
                    assetTableBody.innerHTML = '<tr><td colspan="5" style="text-align:center; color:#999; padding:20px;">No assets match the current filters.</td></tr>';
                    return;
                }

                data.forEach(asset => {
                    const row = document.createElement('tr');

                    const idCell = document.createElement('td');
                    idCell.textContent = asset.id;
                    row.appendChild(idCell);

                    const nameCell = document.createElement('td');
                    const strong = document.createElement('strong');
                    strong.textContent = asset.name || '';
                    nameCell.appendChild(strong);
                    row.appendChild(nameCell);

                    const categoryCell = document.createElement('td');
                    categoryCell.textContent = asset.assetTypeName || '';
                    row.appendChild(categoryCell);

                    const statusCell = document.createElement('td');
                    statusCell.innerHTML = renderStatusBadge(asset.status);
                    row.appendChild(statusCell);

                    const actionCell = document.createElement('td');
                    actionCell.className = 'action-btns';

                    const editButton = document.createElement('button');
                    editButton.className = 'btn-edit';
                    editButton.title = 'Edit';
                    editButton.type = 'button';
                    editButton.innerHTML = '<i class="fas fa-edit"></i>';
                    editButton.addEventListener('click', () => openModal(asset.id, asset.name || '', asset.assetTypeName || 'Laptop', asset.status || 'AVAILABLE'));

                    const deleteButton = document.createElement('button');
                    deleteButton.className = 'btn-delete';
                    deleteButton.title = 'Delete';
                    deleteButton.type = 'button';
                    deleteButton.innerHTML = '<i class="fas fa-trash"></i>';
                    deleteButton.addEventListener('click', () => deleteAsset(asset.id));

                    actionCell.appendChild(editButton);
                    actionCell.appendChild(deleteButton);
                    row.appendChild(actionCell);

                    assetTableBody.appendChild(row);
                });
            }

            function updatePagination() {
                const start = totalElements === 0 ? 0 : (currentPage * pageSize) + 1;
                const end = totalElements === 0 ? 0 : Math.min((currentPage + 1) * pageSize, totalElements);

                document.getElementById('paginationInfo').textContent =
                    'Showing ' + start + ' to ' + end + ' of ' + totalElements + ' entries';
                document.getElementById('pageIndicator').textContent =
                    (totalPages === 0 ? '0 / 1' : (currentPage + 1) + ' / ' + totalPages);
                document.getElementById('prevPageBtn').disabled = currentPage <= 0;
                document.getElementById('nextPageBtn').disabled = totalPages === 0 || currentPage >= totalPages - 1;
            }

            function filterAssets() {
                fetchAssets(0);
            }

            function changePage(direction) {
                const nextPage = currentPage + direction;
                if (nextPage < 0 || (totalPages > 0 && nextPage >= totalPages)) {
                    return;
                }

                fetchAssets(nextPage);
            }

            async function loadAssetCategories() {
                try {
                    const response = await fetch('/api/admin/assetType/getAll?page=0&size=50');
                    const data = await response.json();
                    if (!data.success) throw new Error(data.message || 'Failed to load categories');

                    assetCategory.innerHTML = '';
                    data.data.content.forEach(type => {
                        const option = document.createElement('option');
                        option.value = type.name;
                        option.textContent = type.name;
                        assetCategory.appendChild(option);
                    });

                    if (!assetCategory.value && assetCategory.options.length > 0) {
                        assetCategory.value = assetCategory.options[0].value;
                    }

                    populateTypeFilter();
                } catch (error) {
                    assetCategory.innerHTML = '<option value="">Unable to load categories</option>';
                    typeFilter.innerHTML = '<option value="">All Categories</option>';
                    console.error('Load asset categories error:', error);
                }
            }

            async function fetchAssets(page = 0) {
                try {
                    const response = await fetch('/api/admin/asset/getAll?' + buildAssetQuery(page));
                    const data = await response.json();
                    if (!data.success) throw new Error(data.message || 'Failed to load assets');

                    const pageData = data.data || {};
                    assets = pageData.content || [];
                    currentPage = pageData.number || 0;
                    totalPages = pageData.totalPages || 0;
                    totalElements = pageData.totalElements || 0;
                    renderAssets(assets);
                    updatePagination();
                } catch (error) {
                    alert('Không tải được dữ liệu tài sản: ' + error.message);
                    assets = [];
                    totalPages = 0;
                    totalElements = 0;
                    renderAssets([]);
                    updatePagination();
                }
            }

            function openModal(id = null, name = '', category = 'Laptop', status = 'AVAILABLE') {
                document.getElementById('assetModal').style.display = 'flex';
                if (id) {
                    document.getElementById('modalTitle').innerText = 'Edit Asset';
                    document.getElementById('assetId').value = id;
                    document.getElementById('assetName').value = name;
                    document.getElementById('assetCategory').value = category;
                    document.getElementById('assetStatus').value = status;
                    document.getElementById('assetQuantity').value = 1;
                } else {
                    document.getElementById('modalTitle').innerText = 'Add New Asset';
                    document.getElementById('assetId').value = '';
                    document.getElementById('assetName').value = '';
                    document.getElementById('assetCategory').value = 'Laptop';
                    document.getElementById('assetStatus').value = 'AVAILABLE';
                    document.getElementById('assetQuantity').value = 1;
                }
            }

            function closeModal() {
                document.getElementById('assetModal').style.display = 'none';
            }

            window.onclick = function (event) {
                let modal = document.getElementById('assetModal');
                if (event.target === modal) {
                    closeModal();
                }
            }

            async function saveAsset() {
                const id = document.getElementById('assetId').value;
                const name = document.getElementById('assetName').value.trim();
                const assetTypeName = document.getElementById('assetCategory').value;
                const status = document.getElementById('assetStatus').value;
                const quantity = Number(document.getElementById('assetQuantity').value || 1);

                if (!name) {
                    alert('Please enter Asset Name!');
                    return;
                }
                if (!assetTypeName) {
                    alert('Please select a valid asset category.');
                    return;
                }
                if (quantity < 1) {
                    alert('Quantity must be at least 1.');
                    return;
                }

                try {
                    if (id) {
                        const response = await fetch('/api/admin/asset/update/' + id, {
                            method: 'PUT',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ name, assetTypeName, status })
                        });
                        const data = await response.json();
                        if (!data.success) throw new Error(data.message || 'Update failed');
                    } else {
                        const response = await fetch('/api/admin/asset/add', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({ name, assetTypeName, status, quantity })
                        });
                        const data = await response.json();
                        if (!data.success) throw new Error(data.message || 'Add failed');
                    }
                    closeModal();
                    fetchAssets(currentPage);
                } catch (error) {
                    alert('Không lưu được tài sản: ' + error.message);
                }
            }

            async function deleteAsset(id) {
                if (!confirm('Xác nhận xoá tài sản này?')) return;
                try {
                    const response = await fetch('/api/admin/asset/delete/' + id, { method: 'DELETE' });
                    const data = await response.json();
                    if (!data.success) throw new Error(data.message || 'Delete failed');
                    fetchAssets(currentPage);
                } catch (error) {
                    alert('Không xoá được tài sản: ' + error.message);
                }
            }

            function renderStatusBadge(status) {
                if (!status) return '<span class="badge badge-pending">Unknown</span>';
                const text = status.replace('_', ' ').toLowerCase();
                if (status === 'AVAILABLE') return '<span class="badge badge-available">Available</span>';
                if (status === 'IN_USE') return '<span class="badge badge-inuse">In Use</span>';
                if (status === 'BROKEN') return '<span class="badge badge-broken">Broken</span>';
                return '<span class="badge badge-pending">' + escapeHtml(text) + '</span>';
            }
        </script>
    </body>

    </html>
