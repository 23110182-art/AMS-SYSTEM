<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="../common/head_css.jsp" %>
    <title>Employee Portal – Assets</title>
    <style>
        /* ── LAYOUT ── */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', sans-serif; background: #f1f5f9; display: flex; min-height: 100vh; }
        .main-wrapper { 
            margin-left: 10px; 
            flex: 1; 
            display: flex; 
            flex-direction: column; 
        }

        /* ── CARD ── */
        .card { background: #fff; border-radius: 12px; border: 1px solid #e2e8f0; box-shadow: 0 1px 4px rgba(0,0,0,.04); }
        .card-header { padding: 16px 20px; border-bottom: 1px solid #f1f5f9; font-size: 15px; font-weight: 600; color: #1e293b; }

        /* ── PAGE HEADER ── */
        .content { padding: 28px; }
        .page-header { margin-bottom: 22px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #0f172a; }
        .page-header p  { font-size: 14px; color: #64748b; margin-top: 3px; }

        /* ── FILTERS ── */
        .filters { 
            padding: 14px 20px; 
            display: flex; 
            gap: 8px; /* Đã tăng khoảng cách lên một chút cho thoáng */
            align-items: center; /* Căn giữa các thành phần theo chiều dọc */
            border-bottom: 1px solid #f1f5f9; 
        }
        .search-wrap { 
            width: 350px; /* Đã đổi từ flex: 1 thành width cố định để không bị giãn dài */
            position: relative; 
        }
        .search-wrap i { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 13px; }
        .search-input {
            width: 100%; height: 38px; padding: 0 12px 0 36px;
            border: 1px solid #e2e8f0; border-radius: 8px;
            font-size: 14px; font-family: inherit; color: #334155;
            background: #f8fafc; outline: none;
        }
        .search-input:focus { border-color: #3b82f6; background: #fff; }
        .filter-select {
            height: 38px; padding: 0 30px 0 12px;
            border: 1px solid #e2e8f0; border-radius: 8px;
            font-size: 14px; font-family: inherit; color: #475569;
            background: #f8fafc url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%2394a3b8' stroke-width='2'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E") no-repeat right 10px center;
            appearance: none; outline: none; cursor: pointer;
        }

        /* ── TABLE ── */
        .table-wrap { overflow-x: auto; }
        table.asset-table { width: 100%; border-collapse: collapse; }
        .asset-table thead th {
            padding: 12px 20px; font-size: 13px; font-weight: 600;
            color: #475569; text-align: left; background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
        }
        .asset-table thead th.col-actions { text-align: right; }
        .asset-table tbody td { padding: 13px 20px; font-size: 14px; color: #334155; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
        .asset-table tbody tr:last-child td { border-bottom: none; }
        .asset-table tbody tr:hover td { background: #f8fafc; }
        .td-actions { display: flex; justify-content: flex-end; gap: 8px; }

        /* ── STATUS BADGES ── */
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge-available { background: #dcfce7; color: #16a34a; }
        .badge-in-use    { background: #fef9c3; color: #b45309; }
        .badge-broken    { background: #fee2e2; color: #dc2626; }

        /* ── BUTTONS ── */
        .btn { display: inline-flex; align-items: center; gap: 6px; padding: 7px 13px; border-radius: 7px; font-size: 13px; font-weight: 600; cursor: pointer; border: none; font-family: inherit; transition: all .15s; }
        .btn-view         { background: transparent; color: #475569; border: 1px solid #e2e8f0; }
        .btn-view:hover   { background: #f8fafc; border-color: #cbd5e1; }
        .btn-request      { background: #3b82f6; color: #fff; }
        .btn-request:hover { background: #2563eb; }
        .btn-request:disabled { background: #cbd5e1; color: #94a3b8; cursor: not-allowed; }
        .btn-back         { background: #fff; color: #475569; border: 1px solid #e2e8f0; box-shadow: 0 1px 2px rgba(0,0,0,.05); padding: 8px 16px; border-radius: 8px; font-size: 14px; margin-bottom: 18px; }
        .btn-back:hover   { background: #f8fafc; border-color: #94a3b8; }
        .btn-req-full     { width: 100%; justify-content: center; padding: 11px; font-size: 14px; border-radius: 8px; background: #3b82f6; color: #fff; }
        .btn-req-full:hover    { background: #2563eb; }
        .btn-req-full:disabled { background: #cbd5e1; color: #94a3b8; cursor: not-allowed; }

        /* ── DETAIL LAYOUT ── */
        .detail-grid { display: grid; grid-template-columns: 1fr 280px; gap: 20px; align-items: start; }
        .info-body { padding: 24px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 22px 32px; }
        .info-field label { display: block; font-size: 13px; color: #94a3b8; font-weight: 500; margin-bottom: 5px; }
        .info-field .val  { font-size: 15px; font-weight: 600; color: #0f172a; }
        .info-field.span-2 { grid-column: 1 / -1; }
        .info-field.span-2 .val { font-weight: 400; color: #475569; font-size: 14px; line-height: 1.6; }
        .actions-body { padding: 20px; }
        .actions-hint { font-size: 13px; color: #64748b; margin-bottom: 14px; }

        .hidden { display: none !important; }
        #list-view, #detail-view { animation: fadeUp .18s ease; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: translateY(0); } }
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
                        <input class="search-input" id="searchInput"
                               type="text" placeholder="Search assets..."
                               oninput="filterTable()">
                    </div>
                    <select class="filter-select" id="typeFilter" onchange="filterTable()">
                        <option value="">All Types</option>
                        <option value="Laptop">Laptop</option>
                        <option value="Monitor">Monitor</option>
                        <option value="Keyboard">Keyboard</option>
                        <option value="Mouse">Mouse</option>
                        <option value="Headset">Headset</option>
                    </select>
                    <select class="filter-select" id="statusFilter" onchange="filterTable()">
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
                        <button class="btn btn-req-full" id="btnRequest" onclick="requestAsset()">
                            <i class="fas fa-paper-plane"></i> Request Asset
                        </button>
                    </div>
                </div>
            </div>

        </div><%-- /detail-view --%>

    </div><%-- /content --%>
</div><%-- /main-wrapper --%>


<script>
    /* ─────────────────────────────────────────
       DATA  – thay bằng JSTL/EL từ controller
       ───────────────────────────────────────── */
    const assets = [
        { id:1, name:'MacBook Pro 16"',         type:'Laptop',   status:'available', desc:'Apple M3 Pro chip, 18GB unified memory, 512GB SSD.' },
        { id:2, name:'Dell XPS 15',              type:'Laptop',   status:'in use',    desc:'Intel Core i7-13700H, 32GB DDR5, 1TB NVMe SSD.' },
        { id:3, name:'LG UltraWide 34"',         type:'Monitor',  status:'available', desc:'34-inch curved monitor with 1440p resolution.' },
        { id:4, name:'Samsung 27" 4K',           type:'Monitor',  status:'in use',    desc:'27-inch 4K UHD IPS panel, 60Hz, USB-C.' },
        { id:5, name:'Mechanical Keyboard RGB',  type:'Keyboard', status:'available', desc:'TKL layout, Cherry MX Brown, per-key RGB.' },
        { id:6, name:'Logitech MX Master 3',     type:'Mouse',    status:'available', desc:'Ergonomic wireless, MagSpeed scroll, 4000 DPI.' },
        { id:7, name:'Sony WH-1000XM5',          type:'Headset',  status:'in use',    desc:'Noise cancelling headset, 30-hour battery.' },
        { id:8, name:'MacBook Air M2',            type:'Laptop',   status:'broken',    desc:'Sent for repair – screen damage.' },
    ];

    let currentAsset = null;

    function badge(s) {
        const cls = { available:'badge-available', 'in use':'badge-in-use', broken:'badge-broken' };
        return `<span class="badge ${cls[s]||''}">${s}</span>`;
    }

    function renderTable(data) {
        document.getElementById('assetTableBody').innerHTML = data.map(a => {
            const ok = a.status === 'available';
            // Thêm dấu \ trước tất cả các ký tự $ để JSP bỏ qua, không compile nhầm
            return `<tr>
                <td><strong>\${a.name}</strong></td>
                <td>\${a.type}</td>
                <td>\${badge(a.status)}</td>
                <td><div class="td-actions">
                    <button class="btn btn-view" onclick="viewAsset(\${a.id})">
                        <i class="fas fa-eye"></i> View
                    </button>
                    <button class="btn btn-request" onclick="viewAsset(\${a.id})" \${ok ? '' : 'disabled'}>
                        <i class="fas fa-paper-plane"></i> Request
                    </button>
                </div></td>
            </tr>`;
        }).join('');
    }

    function filterTable() {
        const q = document.getElementById('searchInput').value.toLowerCase();
        const t = document.getElementById('typeFilter').value;
        const s = document.getElementById('statusFilter').value;
        renderTable(assets.filter(a =>
            (!q || a.name.toLowerCase().includes(q) || a.type.toLowerCase().includes(q)) &&
            (!t || a.type === t) &&
            (!s || a.status === s)
        ));
    }

    function viewAsset(id) {
        const a = assets.find(x => x.id === id);
        if (!a) return;
        currentAsset = a;
        const ok = a.status === 'available';

        document.getElementById('d-title').textContent = a.name;
        document.getElementById('d-name').textContent  = a.name;
        document.getElementById('d-type').textContent  = a.type;
        document.getElementById('d-id').textContent    = '#' + a.id;
        document.getElementById('d-desc').textContent  = a.desc;
        document.getElementById('d-status').innerHTML  = badge(a.status);
        document.getElementById('d-hint').textContent  =
            ok ? 'This asset is available for request.' : 'This asset is currently not available.';
        document.getElementById('btnRequest').disabled = !ok;

        document.getElementById('list-view').classList.add('hidden');
        document.getElementById('detail-view').classList.remove('hidden');
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function goToList() {
        document.getElementById('detail-view').classList.add('hidden');
        document.getElementById('list-view').classList.remove('hidden');
    }

    function requestAsset() {
        if (!currentAsset || currentAsset.status !== 'available') return;
        if (confirm(`Submit request for "${currentAsset.name}"?`)) {
            alert(`✅ Request submitted!\nTrack it in My Requests.`);
        }
    }

    renderTable(assets);
</script>
</body>
</html>
