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
  cy.get('#username').clear().type(account.username); // tim o nhap username, xoa gia tri cu va nhap username moi
  cy.get('#password').clear().type(account.password);
  cy.get('#role').select(account.role);
  cy.get('#registerBtn').click(); // tim nut dang ky va click
  cy.location('pathname').should('eq', '/login'); // dang ky thanh cong phai chuyen sang trang login
}

function loginViaUi(account, expectedPath) {
  cy.visit('/login');
  cy.get('#username').clear().type(account.username);
  cy.get('#password').clear().type(account.password);
  cy.get('#loginBtn').click();
  cy.location('pathname').should('eq', expectedPath);
  cy.getCookie('jwt_token').should('exist'); // sau khi dang nhap thanh cong, jwt_token phai ton tai, token duoc luu trong cookie de ktra xem login co thanh cong khong
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

// luong that te cua dang ky va dang nhap, kiem tra xem sau khi dang nhap thanh cong thi co jwt_token trong cookie va localStorage khong
// sau do logout va kiem tra xem token da bi xoa chua
describe('Authentication Real Flow', () => {
  beforeEach(() => {
    cy.clearCookies();  
    cy.clearLocalStorage();
  });   // don sach he thong trc khi test

  it('registers a new user account via UI', () => {  // dang ky tai khoan user moi thong qua giao dien nguoi dung
    registerViaUi(userAccount); // goi ham dang ky dinh nghia o tren
    cy.contains('h2', 'Asset Management System').should('be.visible'); //  ktra co quay ve trang login sau khi dang ky thanh cong khong
    cy.get('#username').should('be.visible');
    cy.get('#password').should('be.visible');
  });

  it('logs in and logs out with the registered user account', () => {
    loginViaUi(userAccount, '/user/dashboard'); //login voi tai khoan user roi ktra xem co chuyen den trang dashboard cua user hong
    cy.contains('Available Assets').should('exist');
    logoutViaUi();
  });

  // giong voi tai khoan user, nhung lan nay la tai khoan admin
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
