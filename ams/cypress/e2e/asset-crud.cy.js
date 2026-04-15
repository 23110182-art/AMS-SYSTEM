const runId = Date.now();

const adminAccount = {
  username: `asset_admin_${runId}`,
  password: 'Admin123@',
  role: 'ADMIN'
};

const assetData = {
  createdName: `Cypress Asset ${runId}`,
  updatedName: `Cypress Asset Updated ${runId}`,
  type: 'Laptop',
  createdStatus: 'AVAILABLE',
  updatedStatus: 'BROKEN',
  quantity: '1'
};

function registerAdminViaUi(account) {
  cy.visit('/register');
  cy.get('#username').clear().type(account.username);
  cy.get('#password').clear().type(account.password);
  cy.get('#role').select(account.role);
  cy.get('#registerBtn').click();
  cy.location('pathname').should('eq', '/login');
}

function loginViaUi(account) {
  cy.visit('/login');
  cy.get('#username').clear().type(account.username);
  cy.get('#password').clear().type(account.password);
  cy.get('#loginBtn').click();
  cy.location('pathname').should('eq', '/admin/dashboard');
  cy.getCookie('jwt_token').should('exist');
}

function openCreateModal() {
  cy.contains('button', 'Add New Asset').click();
  cy.get('#assetModal').should('have.css', 'display', 'flex');
  cy.contains('#modalTitle', 'Add New Asset').should('be.visible');
} // ham chi krta xem modal tao moi asset co mo ra khong, va tieu de cua modal co dung khong

function openEditModalByName(assetName) {
  cy.contains('#assetTableBody tr', assetName)
    .within(() => {
      cy.get('.btn-edit').click();
    }); 

  cy.get('#assetModal').should('have.css', 'display', 'flex');
  cy.contains('#modalTitle', 'Edit Asset').should('be.visible');
} // ham tim dong co ten asset can sua, click nut edit tren dong do, va ktra xem modal edit co mo ra khong, tieu de co dung khong, va cac truong trong form co gia tri dung voi asset can sua khong

// lam het tao , xem , sua va xoa asset tren giao dien quan ly cua admin, kiem tra xem cac api tuong ung da duoc goi va tra ve ket qua co dung hong
describe('Admin Asset Management CRUD', () => {
  before(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
    registerAdminViaUi(adminAccount); //tao tai khoan admin de test
  });

  beforeEach(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
    loginViaUi(adminAccount); // dang  nhap truoc moi test de dam bao co token va quyen truy cap
  });

  it('creates, reads, updates, and deletes an asset from the admin management page', () => {
    cy.intercept('GET', '/api/admin/assetType/getAll*').as('getAssetTypes');
    cy.intercept('GET', '/api/admin/asset/getAll*').as('getAssets');
    cy.intercept('POST', '/api/admin/asset/add').as('addAsset');
    cy.intercept('PUT', /\/api\/admin\/asset\/update\/\d+/).as('updateAsset');
    cy.intercept('DELETE', /\/api\/admin\/asset\/delete\/\d+/).as('deleteAsset');
    cy.visit('/admin/assets');
    cy.wait('@getAssetTypes').its('response.statusCode').should('eq', 200);
    cy.wait('@getAssets').its('response.statusCode').should('eq', 200);

    // tao tai san moi
    openCreateModal();
    cy.get('#assetName').clear().type(assetData.createdName);
    cy.get('#assetCategory').select(assetData.type);
    cy.get('#assetStatus').select(assetData.createdStatus);
    cy.get('#assetQuantity').clear().type(assetData.quantity);
    cy.contains('#assetModal .btn-primary', 'Save Asset').click();

    //ktra xem api tao moi asset co duoc goi va tra ve ket qua dung khong, du lieu gui len co chinh xac khong, va du lieu tra ve co chua thong tin cua asset vua tao khong
    cy.wait('@addAsset').then(({ request, response }) => {
      expect(response.statusCode).to.eq(200);
      expect(request.body).to.deep.equal({
        name: assetData.createdName,
        assetTypeName: assetData.type,
        status: assetData.createdStatus,
        quantity: Number(assetData.quantity)
      });
      expect(response.body.success).to.eq(true);
      expect(response.body.data.name).to.eq(assetData.createdName);
    });

    // ktra xem asset vua tao da hien thi tren bang danh sach asset chua, va thong tin hien thi co chinh xac khong
    cy.wait('@getAssets');
    cy.contains('#assetTableBody tr', assetData.createdName).as('createdRow');
    cy.get('@createdRow').within(() => {
      cy.contains(assetData.type).should('be.visible');
      cy.contains('Available').should('be.visible');
    });

    //ktra cai tai san vua tao o duoi backend co dung khong, dung id tra ve tu api de lay chi tiet va so sanh voi du lieu goc
    cy.get('@addAsset').then(({ response }) => {
      const assetId = response.body.data.id;
      cy.request(`/api/asset/get/${assetId}`).then((detailResponse) => {
        expect(detailResponse.status).to.eq(200);
        expect(detailResponse.body.success).to.eq(true);
        expect(detailResponse.body.data.id).to.eq(assetId);
        expect(detailResponse.body.data.name).to.eq(assetData.createdName);
        expect(detailResponse.body.data.assetTypeName).to.eq(assetData.type);
        expect(detailResponse.body.data.status).to.eq(assetData.createdStatus);
      });
    });

    openEditModalByName(assetData.createdName);
    cy.get('#assetName').should('have.value', assetData.createdName);
    cy.get('#assetCategory').should('have.value', assetData.type);
    cy.get('#assetStatus').should('have.value', assetData.createdStatus);
    cy.get('#assetName').clear().type(assetData.updatedName);
    cy.get('#assetStatus').select(assetData.updatedStatus);
    cy.contains('#assetModal .btn-primary', 'Save Asset').click();

    //ktra api update
    cy.wait('@updateAsset').then(({ request, response }) => {
      expect(response.statusCode).to.eq(200);
      //ktra frontend gui len du lieu de update co chinh xac khong, chi gui nhung truong duoc phep update va gia tri moi sau khi da sua
      expect(request.body).to.deep.equal({
        name: assetData.updatedName,
        assetTypeName: assetData.type,
        status: assetData.updatedStatus
      });
      // ktra xem api update da duoc goi va tra ve ket qua dung khong
      expect(response.body.success).to.eq(true);
      expect(response.body.data.name).to.eq(assetData.updatedName);
      expect(response.body.data.status).to.eq(assetData.updatedStatus);
    });

    cy.wait('@getAssets');
    cy.contains('#assetTableBody tr', assetData.updatedName).within(() => {
      cy.contains(assetData.type).should('be.visible');
      cy.contains('Broken').should('be.visible');
    });
    cy.contains('#assetTableBody tr', assetData.createdName).should('not.exist');
    

    cy.on('window:confirm', () => true); // tu dong dong y khi co hoi xac nhan xoa hien ra
    // tim dung dong tai san muon xoa roi xoa no di
    cy.contains('#assetTableBody tr', assetData.updatedName)
      .within(() => {
        cy.get('.btn-delete').click();
      });
    // ktra api delete xem server co xoa tai san dc chon di chua
    cy.wait('@deleteAsset').then(({ response }) => {
      expect(response.statusCode).to.eq(200);
      expect(response.body.success).to.eq(true);
    });

    cy.wait('@getAssets');
    cy.contains('#assetTableBody tr', assetData.updatedName).should('not.exist');
  });
});
