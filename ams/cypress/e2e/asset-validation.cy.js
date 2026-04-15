const runId = Date.now();

const adminAccount = {
  username: `asset_validation_admin_${runId}`,
  password: 'Admin123@',
  role: 'ADMIN'
};

const assetData = {
  type: 'Laptop',
  status: 'AVAILABLE',
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
}

describe('Admin Asset Management Validation', () => {
  before(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
    registerAdminViaUi(adminAccount);
  });

  beforeEach(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
    loginViaUi(adminAccount);
  });

  it('shows validation when asset name is empty and does not submit the form', () => {
    cy.intercept('GET', '/api/admin/assetType/getAll*').as('getAssetTypes');
    cy.intercept('GET', '/api/admin/asset/getAll*').as('getAssets');
    cy.intercept('POST', '/api/admin/asset/add').as('addAsset');

    cy.visit('/admin/assets');
    cy.wait('@getAssetTypes').its('response.statusCode').should('eq', 200);
    cy.wait('@getAssets').its('response.statusCode').should('eq', 200);

    openCreateModal();
    cy.get('#assetName').clear();
    cy.get('#assetCategory').select(assetData.type);
    cy.get('#assetStatus').select(assetData.status);
    cy.get('#assetQuantity').clear().type(assetData.quantity);

    cy.on('window:alert', (message) => {
      expect(message).to.eq('Please enter Asset Name!');
    });

    cy.contains('#assetModal .btn-primary', 'Save Asset').click();

    cy.get('#assetModal').should('have.css', 'display', 'flex');
    cy.get('#assetId').should('have.value', '');
    cy.get('@addAsset.all').should('have.length', 0);
  });

  it('shows validation when quantity is less than 1 and does not submit the form', () => {
    cy.intercept('GET', '/api/admin/assetType/getAll*').as('getAssetTypes');
    cy.intercept('GET', '/api/admin/asset/getAll*').as('getAssets');
    cy.intercept('POST', '/api/admin/asset/add').as('addAsset');

    cy.visit('/admin/assets');
    cy.wait('@getAssetTypes').its('response.statusCode').should('eq', 200);
    cy.wait('@getAssets').its('response.statusCode').should('eq', 200);

    openCreateModal();
    cy.get('#assetName').clear().type(`Invalid Quantity Asset ${runId}`);
    cy.get('#assetCategory').select(assetData.type);
    cy.get('#assetStatus').select(assetData.status);
    cy.get('#assetQuantity').clear().type('0');

    cy.on('window:alert', (message) => {
      expect(message).to.eq('Quantity must be at least 1.');
    });

    cy.contains('#assetModal .btn-primary', 'Save Asset').click();

    cy.get('#assetModal').should('have.css', 'display', 'flex');
    cy.get('#assetName').should('have.value', `Invalid Quantity Asset ${runId}`);
    cy.get('#assetQuantity').should('have.value', '0');
    cy.get('@addAsset.all').should('have.length', 0);
  });
});
