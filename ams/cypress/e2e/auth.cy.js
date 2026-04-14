const runId = Date.now();

const userAccount = {
  username: `e2e_user_${runId}`,
  password: 'User123@',
  role: 'USER'
};

const adminAccount = {
  username: `e2e_admin_${runId}`,
  password: 'Admin123@',
  role: 'ADMIN'
};

function registerViaUi(account) {
  cy.visit('/register');
  cy.get('#username').clear().type(account.username);
  cy.get('#password').clear().type(account.password);
  cy.get('#role').select(account.role);
  cy.get('#registerBtn').click();
  cy.location('pathname').should('eq', '/login');
}

function loginViaUi(account, expectedPath) {
  cy.visit('/login');
  cy.get('#username').clear().type(account.username);
  cy.get('#password').clear().type(account.password);
  cy.get('#loginBtn').click();
  cy.location('pathname').should('eq', expectedPath);
  cy.getCookie('jwt_token').should('exist');
  cy.window().then((win) => {
    expect(win.localStorage.getItem('jwt_token')).to.be.a('string').and.not.be.empty;
  });
}

function logoutViaUi() {
  cy.on('window:confirm', () => true);
  cy.get('.btn-logout').click();
  cy.location('pathname').should('eq', '/login');
  cy.window().then((win) => {
    expect(win.localStorage.getItem('jwt_token')).to.be.null;
  });
  cy.getCookie('jwt_token').should('not.exist');
}

describe('Authentication Real Flow', () => {
  beforeEach(() => {
    cy.clearCookies();
    cy.clearLocalStorage();
  });

  it('registers a new user account via UI', () => {
    registerViaUi(userAccount);
    cy.contains('h2', 'Asset Management System').should('be.visible');
    cy.get('#username').should('be.visible');
    cy.get('#password').should('be.visible');
  });

  it('logs in and logs out with the registered user account', () => {
    loginViaUi(userAccount, '/user/dashboard');
    cy.contains('Available Assets').should('exist');
    logoutViaUi();
  });

  it('registers a new admin account via UI', () => {
    registerViaUi(adminAccount);
    cy.contains('h2', 'Asset Management System').should('be.visible');
    cy.get('#username').should('be.visible');
    cy.get('#password').should('be.visible');
  });

  it('logs in and logs out with the registered admin account', () => {
    loginViaUi(adminAccount, '/admin/dashboard');
    cy.contains('Dashboard Overview').should('exist');
    logoutViaUi();
  });
});
