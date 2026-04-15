const runId = Date.now();

const adminAccount = {
  username: `asset_list_admin_${runId}`,
  password: 'Admin123@',
  role: 'ADMIN'
};

const seededBrokenAsset = {
  name: `Broken Filter Asset ${runId}`,
  assetTypeName: 'Laptop',
  status: 'BROKEN',
  quantity: 1
};

const paginationAssets = Array.from({ length: 3 }, (_, index) => ({
  name: `Pagination Asset ${runId}-${index + 1}`,
  assetTypeName: 'Laptop',
  status: 'AVAILABLE',
  quantity: 1
}));

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

function openAssetListPage() {
  cy.intercept('GET', '/api/admin/assetType/getAll*').as('getAssetTypes');
  cy.intercept('GET', '/api/admin/asset/getAll*').as('getAssets');
  cy.visit('/admin/assets');
  cy.wait('@getAssetTypes').its('response.statusCode').should('eq', 200);
  cy.wait('@getAssets').its('response.statusCode').should('eq', 200);
}

describe('Admin Asset List', () => {
  before(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
    registerAdminViaUi(adminAccount);
    loginViaUi(adminAccount);

    cy.request('POST', '/api/admin/asset/add', seededBrokenAsset).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.success).to.eq(true);
    });

    paginationAssets.forEach((asset) => {
      cy.request('POST', '/api/admin/asset/add', asset).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body.success).to.eq(true);
      });
    });
  });

  beforeEach(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
    loginViaUi(adminAccount);
    openAssetListPage();
  });

  it('searches assets by keyword', () => {
    cy.intercept({
      method: 'GET',
      pathname: '/api/admin/asset/getAll',
      query: {
        keyword: 'Dell Inspiron 15'
      }
    }).as('searchByKeyword');

    cy.get('#searchInput').clear().type('Dell Inspiron 15');
    cy.wait('@searchByKeyword').then(({ request, response }) => {
      expect(response.statusCode).to.eq(200);
      expect(request.query.keyword).to.eq('Dell Inspiron 15');
    });

    cy.contains('#assetTableBody tr', 'Dell Inspiron 15').should('be.visible');
    cy.get('#assetTableBody tr').should('have.length', 1);
  });

  it('filters assets by category', () => {
    cy.get('#typeFilter').select('Printer');
    cy.wait('@getAssets').then(({ request, response }) => {
      expect(response.statusCode).to.eq(200);
      expect(request.query.assetTypeName).to.eq('Printer');
    });

    cy.contains('#assetTableBody tr', 'HP LaserJet').should('be.visible');
    cy.contains('#assetTableBody tr', 'Canon LBP2900').should('be.visible');
    cy.contains('#assetTableBody tr', 'Dell Inspiron 15').should('not.exist');
  });

  it('filters assets by status', () => {
    cy.get('#statusFilter').select('BROKEN');
    cy.wait('@getAssets').then(({ request, response }) => {
      expect(response.statusCode).to.eq(200);
      expect(request.query.status).to.eq('BROKEN');
    });

    cy.contains('#assetTableBody tr', seededBrokenAsset.name).within(() => {
      cy.contains('Laptop').should('be.visible');
      cy.contains('Broken').should('be.visible');
    });
    cy.contains('#assetTableBody tr', 'Dell Inspiron 15').should('not.exist');
  });

  it('navigates between asset list pages', () => {
    cy.get('#paginationInfo').should('contain', 'Showing 1 to 10');
    cy.get('#pageIndicator').should('contain', '1 /');
    cy.get('#prevPageBtn').should('be.disabled');
    cy.get('#nextPageBtn').should('not.be.disabled');

    cy.get('#nextPageBtn').click();
    cy.wait('@getAssets').then(({ request, response }) => {
      expect(response.statusCode).to.eq(200);
      expect(request.query.page).to.eq('1');
      expect(response.body.data.number).to.eq(1);
      expect(response.body.data.totalElements).to.be.greaterThan(10);
      expect(response.body.data.totalPages).to.be.greaterThan(1);
    });

    cy.get('#pageIndicator').should('contain', '2 /');
    cy.get('#assetTableBody tr').its('length').should('be.at.least', 1);
    cy.get('#paginationInfo').invoke('text').should('match', /Showing 11 to \d+ of \d+ entries/);
    cy.get('#nextPageBtn').should('be.disabled');
    cy.get('#prevPageBtn').should('not.be.disabled');

    cy.get('#prevPageBtn').click();
    cy.wait('@getAssets').then(({ request, response }) => {
      expect(response.statusCode).to.eq(200);
      expect(request.query.page).to.eq('0');
      expect(response.body.data.number).to.eq(0);
    });

    cy.get('#pageIndicator').should('contain', '1 /');
    cy.get('#paginationInfo').should('contain', 'Showing 1 to 10');
  });
});
