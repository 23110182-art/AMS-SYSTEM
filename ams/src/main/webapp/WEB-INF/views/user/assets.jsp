<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <%@ include file="../common/head_css.jsp" %>
            <title>Employee Portal – Assets</title>
            <style>
                /* ── LAYOUT ── */
                *,
                *::before,
                *::after {
                    box-sizing: border-box;
                    margin: 0;
                    padding: 0;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    background: #f1f5f9;
                    display: flex;
                    min-height: 100vh;
                }

                .main-wrapper {
                    margin-left: 10px;
                    flex: 1;
                    display: flex;
                    flex-direction: column;
                }

                /* ── CARD ── */
                .card {
                    background: #fff;
                    border-radius: 12px;
                    border: 1px solid #e2e8f0;
                    box-shadow: 0 1px 4px rgba(0, 0, 0, .04);
                }

                .card-header {
                    padding: 16px 20px;
                    border-bottom: 1px solid #f1f5f9;
                    font-size: 15px;
                    font-weight: 600;
                    color: #1e293b;
                }

                /* ── PAGE HEADER ── */
                .content {
                    padding: 28px;
                }

                .page-header {
                    margin-bottom: 22px;
                }

                .page-header h1 {
                    font-size: 26px;
                    font-weight: 700;
                    color: #0f172a;
                }

                .page-header p {
                    font-size: 14px;
                    color: #64748b;
                    margin-top: 3px;
                }

                /* ── FILTERS ── */
                .filters {
                    padding: 14px 20px;
                    display: flex;
                    gap: 8px;
                    /* Đã tăng khoảng cách lên một chút cho thoáng */
                    align-items: center;
                    /* Căn giữa các thành phần theo chiều dọc */
                    border-bottom: 1px solid #f1f5f9;
                }

                .search-wrap {
                    width: 350px;
                    /* Đã đổi từ flex: 1 thành width cố định để không bị giãn dài */
                    position: relative;
                }

                .search-wrap i {
                    position: absolute;
                    left: 12px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #94a3b8;
                    font-size: 13px;
                }

                .search-input {
                    width: 100%;
                    height: 38px;
                    padding: 0 12px 0 36px;
                    border: 1px solid #e2e8f0;
                    border-radius: 8px;
                    font-size: 14px;
                    font-family: inherit;
                    color: #334155;
                    background: #f8fafc;
                    outline: none;
                }

                .search-input:focus {
                    border-color: #3b82f6;
                    background: #fff;
                }

                .filter-select {
                    height: 38px;
                    padding: 0 30px 0 12px;
                    border: 1px solid #e2e8f0;
                    border-radius: 8px;
                    font-size: 14px;
                    font-family: inherit;
                    color: #475569;
                    background: #f8fafc url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E") no-repeat right 10px center;
                    appearance: none;
                    outline: none;
                    cursor: pointer;
                }

                /* ── TABLE ── */
                .table-wrap {
                    overflow-x: auto;
                }

                table.asset-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .asset-table thead th {
                    padding: 12px 20px;
                    font-size: 13px;
                    font-weight: 600;
                    color: #475569;
                    text-align: left;
                    background: #f8fafc;
                    border-bottom: 1px solid #e2e8f0;
                }

                .asset-table thead th.col-actions {
                    text-align: right;
                }

                .asset-table tbody td {
                    padding: 13px 20px;
                    font-size: 14px;
                    color: #334155;
                    border-bottom: 1px solid #f1f5f9;
                    vertical-align: middle;
                }

                .asset-table tbody tr:last-child td {
                    border-bottom: none;
                }

                .asset-table tbody tr:hover td {
                    background: #f8fafc;
                }

                .td-actions {
                    display: flex;
                    justify-content: flex-end;
                    gap: 8px;
                }

                /* ── STATUS BADGES ── */
                .badge {
                    display: inline-block;
                    padding: 3px 10px;
                    border-radius: 20px;
                    font-size: 12px;
                    font-weight: 600;
                }

                .badge-available {
                    background: #dcfce7;
                    color: #16a34a;
                }

                .badge-in-use {
                    background: #fef9c3;
                    color: #b45309;
                }

                .badge-broken {
                    background: #fee2e2;
                    color: #dc2626;
                }

                /* ── BUTTONS ── */
                .btn {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    padding: 7px 13px;
                    border-radius: 7px;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                    border: none;
                    font-family: inherit;
                    transition: all .15s;
                }

                .btn-view {
                    background: transparent;
                    color: #475569;
                    border: 1px solid #e2e8f0;
                }

                .btn-view:hover {
                    background: #f8fafc;
                    border-color: #cbd5e1;
                }

                .btn-request {
                    background: #3b82f6;
                    color: #fff;
                }

                .btn-request:hover {
                    background: #2563eb;
                }

                .btn-request:disabled {
                    background: #cbd5e1;
                    color: #94a3b8;
                    cursor: not-allowed;
                }

                .btn-back {
                    background: #fff;
                    color: #475569;
                    border: 1px solid #e2e8f0;
                    box-shadow: 0 1px 2px rgba(0, 0, 0, .05);
                    padding: 8px 16px;
                    border-radius: 8px;
                    font-size: 14px;
                    margin-bottom: 18px;
                }

                .btn-back:hover {
                    background: #f8fafc;
                    border-color: #94a3b8;
                }

                .btn-req-full {
                    width: 100%;
                    justify-content: center;
                    padding: 11px;
                    font-size: 14px;
                    border-radius: 8px;
                    background: #3b82f6;
                    color: #fff;
                }

                .btn-req-full:hover {
                    background: #2563eb;
                }

                .btn-req-full:disabled {
                    background: #cbd5e1;
                    color: #94a3b8;
                    cursor: not-allowed;
                }

                /* ── DETAIL LAYOUT ── */
                .detail-grid {
                    display: grid;
                    grid-template-columns: 1fr 280px;
                    gap: 20px;
                    align-items: start;
                }

                .info-body {
                    padding: 24px;
                }

                .info-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 22px 32px;
                }

                .info-field label {
                    display: block;
                    font-size: 13px;
                    color: #94a3b8;
                    font-weight: 500;
                    margin-bottom: 5px;
                }

                .info-field .val {
                    font-size: 15px;
                    font-weight: 600;
                    color: #0f172a;
                }

                .info-field.span-2 {
                    grid-column: 1 / -1;
                }

                .info-field.span-2 .val {
                    font-weight: 400;
                    color: #475569;
                    font-size: 14px;
                    line-height: 1.6;
                }

                .actions-body {
                    padding: 20px;
                }

                .actions-hint {
                    font-size: 13px;
                    color: #64748b;
                    margin-bottom: 14px;
                }

                .request-form {
                    display: grid;
                    gap: 12px;
                    margin-bottom: 14px;
                }

                .form-field label {
                    display: block;
                    font-size: 13px;
                    font-weight: 600;
                    color: #475569;
                    margin-bottom: 6px;
                }

                .form-field input {
                    width: 100%;
                    height: 40px;
                    padding: 0 12px;
                    border: 1px solid #e2e8f0;
                    border-radius: 8px;
                    font-size: 14px;
                    font-family: inherit;
                    color: #334155;
                    background: #fff;
                    outline: none;
                }

                .form-field input:focus {
                    border-color: #3b82f6;
                    box-shadow: 0 0 0 3px rgba(59, 130, 246, .12);
                }

                .request-message {
                    min-height: 20px;
                    font-size: 13px;
                    line-height: 1.5;
                    margin-top: 10px;
                }

                .request-message.success {
                    color: #16a34a;
                }

                .request-message.error {
                    color: #dc2626;
                }

                .pagination {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 16px 20px;
                    border-top: 1px solid #f1f5f9;
                    gap: 12px;
                }

                .pagination-info {
                    font-size: 13px;
                    color: #64748b;
                }

                .pagination-actions {
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .page-btn {
                    border: 1px solid #e2e8f0;
                    background: #fff;
                    color: #334155;
                    border-radius: 8px;
                    padding: 8px 12px;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                }

                .page-btn:disabled {
                    opacity: .5;
                    cursor: not-allowed;
                }

                .hidden {
                    display: none !important;
                }

                #list-view,
                #detail-view {
                    animation: fadeUp .18s ease;
                }

                @keyframes fadeUp {
                    from {
                        opacity: 0;
                        transform: translateY(5px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            </style>
    </head>

    <body>

        <%-- ── SIDEBAR (user) ── --%>
            <%@ include file="../common/user_sidebar.jsp" %>

                <div class="main-wrapper">
                    <%-- ── TOPBAR ── --%>
                        <%@ include file="../common/user_topbar.jsp" %>

                            <div class="content">

                                <%-- ════ LIST VIEW ════ --%>
                                    <div id="list-view">
                                        <div class="page-header">
                                            <h1>Available Assets</h1>
                                            <p>Browse and request assets</p>
                                        </div>

                                        <div class="card">
                                            <div class="card-header">Asset Catalog</div>
                                            <div class="filters">
                                                <div class="search-wrap">
                                                    <i class="fas fa-search"></i>
                                                    <input class="search-input" id="searchInput" type="text"
                                                        placeholder="Search assets..." oninput="filterTable()">
                                                </div>
                                                <select class="filter-select" id="typeFilter" onchange="filterTable()">
                                                    <option value="">All Types</option>
                                                </select>
                                                <select class="filter-select" id="statusFilter"
                                                    onchange="filterTable()">
                                                    <option value="">All Status</option>
                                                    <option value="available">Available</option>
                                                    <option value="in use">In Use</option>
                                                    <option value="broken">Broken</option>
                                                </select>
                                            </div>
                                            <div class="table-wrap">
                                                <table class="asset-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Name</th>
                                                            <th>Type</th>
                                                            <th>Status</th>
                                                            <th class="col-actions">Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="assetTableBody"></tbody>
                                                </table>
                                            </div>
                                            <div class="pagination">
                                                <div class="pagination-info" id="paginationInfo">Showing 0 to 0 of 0 assets</div>
                                                <div class="pagination-actions">
                                                    <button class="page-btn" id="prevPageBtn" onclick="changePage(-1)">Previous</button>
                                                    <span class="pagination-info" id="pageIndicator">Page 1 / 1</span>
                                                    <button class="page-btn" id="nextPageBtn" onclick="changePage(1)">Next</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div><%-- /list-view --%>


                                        <%-- ════ DETAIL VIEW ════ --%>
                                            <div id="detail-view" class="hidden">

                                                <button class="btn btn-back" onclick="goToList()">
                                                    <i class="fas fa-arrow-left"></i> Back to Assets
                                                </button>

                                                <div class="page-header">
                                                    <h1 id="d-title">—</h1>
                                                    <p>Asset details and information</p>
                                                </div>

                                                <div class="detail-grid">
                                                    <div class="card">
                                                        <div class="card-header">Asset Information</div>
                                                        <div class="info-body">
                                                            <div class="info-grid">
                                                                <div class="info-field">
                                                                    <label>Asset Name</label>
                                                                    <div class="val" id="d-name"></div>
                                                                </div>
                                                                <div class="info-field">
                                                                    <label>Type</label>
                                                                    <div class="val" id="d-type"></div>
                                                                </div>
                                                                <div class="info-field">
                                                                    <label>Status</label>
                                                                    <div id="d-status"></div>
                                                                </div>
                                                                <div class="info-field">
                                                                    <label>Asset ID</label>
                                                                    <div class="val" id="d-id"></div>
                                                                </div>
                                                                <div class="info-field span-2">
                                                                    <label>Description</label>
                                                                    <div class="val" id="d-desc"></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="card">
                                                        <div class="card-header">Actions</div>
                                                        <div class="actions-body">
                                                            <p class="actions-hint" id="d-hint"></p>
                                                            <div class="request-form">
                                                                <div class="form-field">
                                                                    <label for="requestStartDate">Start Date</label>
                                                                    <input type="date" id="requestStartDate">
                                                                </div>
                                                                <div class="form-field">
                                                                    <label for="requestEndDate">End Date</label>
                                                                    <input type="date" id="requestEndDate">
                                                                </div>
                                                            </div>
                                                            <button class="btn btn-req-full" id="btnRequest"
                                                                onclick="requestAsset()">
                                                                <i class="fas fa-paper-plane"></i> Request Asset
                                                            </button>
                                                            <div class="request-message" id="requestMessage"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </div><%-- /detail-view --%>

                            </div><%-- /content --%>
                </div><%-- /main-wrapper --%>


                    <script>
                        let assets = [];
                        let currentAsset = null;
                        let currentPage = 0;
                        let pageSize = 10;
                        let totalPages = 0;
                        let totalElements = 0;

                        function getAuthToken() {
                            return localStorage.getItem('jwt_token');
                        }

                        function normalizeStatus(status) {
                            const normalized = String(status || '').toUpperCase();

                            if (normalized === 'IN_USE') {
                                return 'in use';
                            }

                            if (normalized === 'BROKEN') {
                                return 'broken';
                            }

                            if (normalized === 'PENDING') {
                                return 'pending';
                            }

                            return 'available';
                        }

                        function escapeHtml(value) {
                            return String(value || '')
                                .replace(/&/g, '&amp;')
                                .replace(/</g, '&lt;')
                                .replace(/>/g, '&gt;')
                                .replace(/"/g, '&quot;')
                                .replace(/'/g, '&#39;');
                        }

                        function setRequestMessage(message, type) {
                            const messageEl = document.getElementById('requestMessage');
                            messageEl.textContent = message || '';
                            messageEl.className = 'request-message' + (type ? ' ' + type : '');
                        }

                        async function loadAssetTypes() {
                            const typeFilter = document.getElementById('typeFilter');
                            try {
                                const response = await fetch('${pageContext.request.contextPath}/api/assetType/getAll?page=0&size=100', {
                                    headers: {
                                        'Authorization': 'Bearer ' + (getAuthToken() || '')
                                    }
                                });
                                const data = await response.json();

                                if (!data.success) {
                                    throw new Error(data.message || 'Failed to load asset types');
                                }

                                const selectedType = typeFilter.value;
                                const types = (data.data.content || []).map(function (type) {
                                    return type.name;
                                });

                                typeFilter.innerHTML = '<option value="">All Types</option>' + types.map(function (type) {
                                    const selected = type === selectedType ? ' selected' : '';
                                    return '<option value="' + escapeHtml(type) + '"' + selected + '>' + escapeHtml(type) + '</option>';
                                }).join('');
                            } catch (error) {
                                typeFilter.innerHTML = '<option value="">All Types</option>';
                            }
                        }

                        function getQueryParams(page) {
                            const keyword = document.getElementById('searchInput').value.trim();
                            const assetTypeName = document.getElementById('typeFilter').value;
                            const statusValue = document.getElementById('statusFilter').value;
                            const params = new URLSearchParams({
                                page: String(page),
                                size: String(pageSize)
                            });

                            if (keyword) {
                                params.set('keyword', keyword);
                            }

                            if (assetTypeName) {
                                params.set('assetTypeName', assetTypeName);
                            }

                            if (statusValue) {
                                params.set('status', statusValue.toUpperCase().replace(/\s+/g, '_'));
                            }

                            return params.toString();
                        }

                        function updatePagination() {
                            const start = totalElements === 0 ? 0 : (currentPage * pageSize) + 1;
                            const end = totalElements === 0 ? 0 : Math.min((currentPage + 1) * pageSize, totalElements);

                            document.getElementById('paginationInfo').textContent =
                                'Showing ' + start + ' to ' + end + ' of ' + totalElements + ' assets';
                            document.getElementById('pageIndicator').textContent =
                                'Page ' + (totalPages === 0 ? 0 : currentPage + 1) + ' / ' + Math.max(totalPages, 1);
                            document.getElementById('prevPageBtn').disabled = currentPage <= 0;
                            document.getElementById('nextPageBtn').disabled = totalPages === 0 || currentPage >= totalPages - 1;
                        }

                        function getTodayString() {
                            return new Date().toISOString().split('T')[0];
                        }

                        function setDefaultRequestDates() {
                            const today = getTodayString();
                            const startDateInput = document.getElementById('requestStartDate');
                            const endDateInput = document.getElementById('requestEndDate');

                            startDateInput.min = today;
                            endDateInput.min = today;

                            if (!startDateInput.value) {
                                startDateInput.value = today;
                            }

                            if (!endDateInput.value || endDateInput.value < startDateInput.value) {
                                endDateInput.value = startDateInput.value;
                            }
                        }

                        function syncEndDateMin() {
                            const startDate = document.getElementById('requestStartDate').value;
                            const endDateInput = document.getElementById('requestEndDate');

                            endDateInput.min = startDate || getTodayString();

                            if (startDate && endDateInput.value && endDateInput.value < startDate) {
                                endDateInput.value = startDate;
                            }
                        }

                        async function loadAssets(page) {
                            try {
                                const response = await fetch('${pageContext.request.contextPath}/api/asset/getAll?' + getQueryParams(page));
                                const data = await response.json();

                                if (!data.success) {
                                    throw new Error(data.message || 'Failed to load assets');
                                }

                                const pageData = data.data || {};
                                currentPage = pageData.number || 0;
                                totalPages = pageData.totalPages || 0;
                                totalElements = pageData.totalElements || 0;
                                assets = (pageData.content || []).map(asset => ({
                                    id: asset.id,
                                    name: asset.name,
                                    type: asset.assetTypeName || 'Unknown',
                                    status: normalizeStatus(asset.status),
                                    hasPendingRequest: false,
                                    desc: asset.description || 'No description available'
                                }));

                                renderTable(assets);
                                updatePagination();
                            } catch (error) {
                                console.error('Load assets error:', error);
                                document.getElementById('assetTableBody').innerHTML =
                                    '<tr><td colspan="4" style="text-align: center; color: #e74c3c; padding: 20px;">Error loading assets: ' + error.message + '</td></tr>';
                                totalPages = 0;
                                totalElements = 0;
                                updatePagination();
                            }
                        }

                        function badge(s) {
                            const cls = { available: 'badge-available', 'in use': 'badge-in-use', broken: 'badge-broken' };
                            return '<span class="badge ' + (cls[s] || '') + '">' + s + '</span>';
                        }

                        function renderTable(data) {
                            if (!data.length) {
                                document.getElementById('assetTableBody').innerHTML =
                                    '<tr><td colspan="4" style="text-align: center; color: #64748b; padding: 20px;">No assets found.</td></tr>';
                                return;
                            }

                            document.getElementById('assetTableBody').innerHTML = data.map(function (a) {
                                const ok = a.status === 'available' && !a.hasPendingRequest;
                                const buttonLabel = a.hasPendingRequest ? 'Requested' : 'Request';
                                return '<tr>' +
                                    '<td><strong>' + escapeHtml(a.name) + '</strong></td>' +
                                    '<td>' + escapeHtml(a.type) + '</td>' +
                                    '<td>' + badge(a.status) + '</td>' +
                                    '<td><div class="td-actions">' +
                                    '<button class="btn btn-view" onclick="viewAsset(' + a.id + ')">' +
                                    '<i class="fas fa-eye"></i> View' +
                                    '</button>' +
                                    '<button class="btn btn-request" onclick="viewAsset(' + a.id + ')" ' + (ok ? '' : 'disabled') + '>' +
                                    '<i class="fas fa-paper-plane"></i> ' + buttonLabel +
                                    '</button>' +
                                    '</div></td>' +
                                    '</tr>';
                            }).join('');
                        }

                        function filterTable() {
                            loadAssets(0);
                        }

                        function changePage(direction) {
                            const nextPage = currentPage + direction;
                            if (nextPage < 0 || (totalPages > 0 && nextPage >= totalPages)) {
                                return;
                            }

                            loadAssets(nextPage);
                        }

                        function viewAsset(id) {
                            const a = assets.find(function (x) { return x.id === id; });
                            if (!a) return;
                            currentAsset = a;
                            const ok = a.status === 'available' && !a.hasPendingRequest;

                            document.getElementById('d-title').textContent = a.name;
                            document.getElementById('d-name').textContent = a.name;
                            document.getElementById('d-type').textContent = a.type;
                            document.getElementById('d-id').textContent = '#' + a.id;
                            document.getElementById('d-desc').textContent = a.desc;
                            document.getElementById('d-status').innerHTML = badge(a.status);
                            document.getElementById('d-hint').textContent =
                                a.hasPendingRequest
                                    ? 'You already submitted a request for this asset.'
                                    : (ok ? 'This asset is available for request.' : 'This asset is currently not available.');
                            document.getElementById('btnRequest').disabled = !ok;
                            setDefaultRequestDates();
                            syncEndDateMin();
                            setRequestMessage('', '');

                            document.getElementById('list-view').classList.add('hidden');
                            document.getElementById('detail-view').classList.remove('hidden');
                            window.scrollTo({ top: 0, behavior: 'smooth' });
                        }

                        function goToList() {
                            document.getElementById('detail-view').classList.add('hidden');
                            document.getElementById('list-view').classList.remove('hidden');
                        }

                        async function requestAsset() {
                            if (!currentAsset || currentAsset.status !== 'available' || currentAsset.hasPendingRequest) {
                                return;
                            }

                            const token = getAuthToken();
                            const startDate = document.getElementById('requestStartDate').value;
                            const endDate = document.getElementById('requestEndDate').value;
                            const requestButton = document.getElementById('btnRequest');

                            if (!token) {
                                setRequestMessage('Please log in again before submitting a request.', 'error');
                                return;
                            }

                            if (!startDate || !endDate) {
                                setRequestMessage('Please select both start date and end date.', 'error');
                                return;
                            }

                            if (endDate < startDate) {
                                setRequestMessage('End date must be the same as or later than start date.', 'error');
                                return;
                            }

                            if (!confirm('Submit request for "' + currentAsset.name + '"?')) {
                                return;
                            }

                            try {
                                requestButton.disabled = true;
                                setRequestMessage('Submitting request...', '');

                                const response = await fetch('${pageContext.request.contextPath}/api/users/asset-usage', {
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                        'Authorization': 'Bearer ' + token
                                    },
                                    body: JSON.stringify({
                                        assetId: currentAsset.id,
                                        startDate: startDate,
                                        endDate: endDate
                                    })
                                });

                                const data = await response.json();

                                if (!response.ok || !data.success) {
                                    throw new Error(data.message || 'Failed to submit request');
                                }

                                currentAsset.hasPendingRequest = true;
                                document.getElementById('d-hint').textContent = 'Your request was submitted and is waiting for approval.';
                                setRequestMessage('Request submitted successfully. You can track it in My Requests.', 'success');
                                renderTable(getFilteredAssets());
                            } catch (error) {
                                setRequestMessage(error.message, 'error');
                                requestButton.disabled = false;
                                return;
                            }

                            requestButton.disabled = true;
                        }

                        window.addEventListener('DOMContentLoaded', async function () {
                            document.getElementById('requestStartDate').addEventListener('change', syncEndDateMin);
                            await loadAssetTypes();
                            loadAssets(0);
                        });
                    </script>
    </body>

    </html>
