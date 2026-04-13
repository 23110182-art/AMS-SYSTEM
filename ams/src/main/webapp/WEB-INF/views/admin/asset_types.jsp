<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Asset Types Management</title>
    <jsp:include page="../common/head_css.jsp" />

    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            gap: 16px;
            flex-wrap: wrap;
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
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
        }

        .btn-primary:hover {
            background-color: #4338ca;
        }

        .table-container {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
            overflow: hidden;
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

        tr:last-child td {
            border-bottom: none;
        }

        .empty-state {
            text-align: center;
            color: var(--text-muted);
            padding: 24px;
        }

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
            width: 400px;
            max-width: calc(100vw - 32px);
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

        .form-group input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            outline: none;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
            transition: border 0.2s;
        }

        .form-group input:focus {
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
                <h2>Asset Types Management</h2>
                <button class="btn-primary" onclick="openModal()">
                    <i class="fas fa-plus"></i>
                    <span>Add New Type</span>
                </button>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Type Name</th>
                            <th width="140px">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="typeTableBody">
                        <tr>
                            <td colspan="3" class="empty-state">Loading asset types...</td>
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
                    <label for="typeName">Type Name</label>
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
        const typeTableBody = document.getElementById('typeTableBody');

        window.addEventListener('DOMContentLoaded', fetchAssetTypes);

        async function fetchAssetTypes() {
            try {
                const response = await fetch('/api/admin/assetType/getAll?page=0&size=100');
                const result = await response.json();

                if (!result.success) {
                    throw new Error(result.message || 'Failed to load asset types');
                }

                const assetTypes = result.data && result.data.content ? result.data.content : [];
                renderRows(assetTypes);
            } catch (error) {
                typeTableBody.innerHTML = '<tr><td colspan="3" class="empty-state">Cannot load asset types.</td></tr>';
                alert('Không tải được loại tài sản: ' + error.message);
            }
        }

        function renderRows(assetTypes) {
            typeTableBody.innerHTML = '';

            if (!assetTypes.length) {
                const emptyRow = document.createElement('tr');
                emptyRow.innerHTML = '<td colspan="3" class="empty-state">No asset types found.</td>';
                typeTableBody.appendChild(emptyRow);
                return;
            }

            assetTypes.forEach(function (type) {
                const row = document.createElement('tr');

                const idCell = document.createElement('td');
                idCell.textContent = type.id;

                const nameCell = document.createElement('td');
                const strong = document.createElement('strong');
                strong.textContent = type.name;
                nameCell.appendChild(strong);

                const actionCell = document.createElement('td');
                const actions = document.createElement('div');
                actions.className = 'action-btns';

                const editButton = document.createElement('button');
                editButton.className = 'btn-edit';
                editButton.title = 'Edit';
                editButton.innerHTML = '<i class="fas fa-edit"></i>';
                editButton.onclick = function () {
                    openModal(type.id, type.name);
                };

                const deleteButton = document.createElement('button');
                deleteButton.className = 'btn-delete';
                deleteButton.title = 'Delete';
                deleteButton.innerHTML = '<i class="fas fa-trash"></i>';
                deleteButton.onclick = function () {
                    deleteType(type.id);
                };

                actions.appendChild(editButton);
                actions.appendChild(deleteButton);
                actionCell.appendChild(actions);

                row.appendChild(idCell);
                row.appendChild(nameCell);
                row.appendChild(actionCell);
                typeTableBody.appendChild(row);
            });
        }

        function openModal(id, name) {
            document.getElementById('typeModal').style.display = 'flex';
            document.getElementById('typeId').value = id || '';
            document.getElementById('typeName').value = name || '';
            document.getElementById('modalTitle').innerText = id ? 'Edit Asset Type' : 'Add Asset Type';
        }

        function closeModal() {
            document.getElementById('typeModal').style.display = 'none';
        }

        window.onclick = function (event) {
            const modal = document.getElementById('typeModal');
            if (event.target === modal) {
                closeModal();
            }
        };

        async function saveType() {
            const id = document.getElementById('typeId').value;
            const name = document.getElementById('typeName').value.trim();

            if (!name) {
                alert('Please enter Type Name!');
                return;
            }

            try {
                const response = await fetch(id ? '/api/admin/assetType/update/' + id : '/api/admin/assetType/add', {
                    method: id ? 'PUT' : 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ name: name })
                });

                const result = await response.json();

                if (!result.success) {
                    throw new Error(result.message || 'Save failed');
                }

                closeModal();
                fetchAssetTypes();
            } catch (error) {
                alert('Không lưu được loại tài sản: ' + error.message);
            }
        }

        async function deleteType(id) {
            if (!confirm('Xác nhận xoá loại tài sản này?')) {
                return;
            }

            try {
                const response = await fetch('/api/admin/assetType/delete/' + id, {
                    method: 'DELETE'
                });
                const result = await response.json();

                if (!result.success) {
                    throw new Error(result.message || 'Delete failed');
                }

                fetchAssetTypes();
            } catch (error) {
                alert('Không xoá được loại tài sản: ' + error.message);
            }
        }
    </script>
</body>

</html>
