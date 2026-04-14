-- ======================
-- ASSET TYPES
-- ======================
INSERT INTO asset_types (name) VALUES
('Laptop'),
('Monitor'),
('Keyboard'),
('Mouse'),
('Printer');

-- ======================
-- ASSETS
-- ======================

-- Laptop
INSERT INTO assets (id, name, description, status, type_id)
VALUES (1, 'Dell Inspiron 15', 'Laptop văn phòng', 'AVAILABLE', 1);

INSERT INTO assets (id, name, description, status, type_id)
VALUES (2, 'Macbook Pro M1', 'Laptop cao cấp', 'AVAILABLE', 1);

-- Monitor
INSERT INTO assets (id, name, description, status, type_id)
VALUES (3, 'LG 24 inch', 'Màn hình IPS', 'AVAILABLE', 2);

INSERT INTO assets (id, name, description, status, type_id)
VALUES (4, 'Samsung 27 inch', 'Màn hình cong', 'AVAILABLE', 2);

-- Keyboard
INSERT INTO assets (id, name, description, status, type_id)
VALUES (5, 'Logitech K120', 'Bàn phím văn phòng', 'AVAILABLE', 3);

INSERT INTO assets  (id, name, description, status, type_id)
VALUES (6, 'Razer BlackWidow', 'Bàn phím cơ gaming', 'AVAILABLE', 3);

-- Mouse
INSERT INTO assets (id, name, description, status, type_id)
VALUES (7, 'Logitech G102', 'Chuột gaming', 'AVAILABLE', 4);

INSERT INTO assets   (id, name, description, status, type_id)
VALUES (8, 'Razer DeathAdder', 'Chuột cao cấp', 'AVAILABLE', 4);

-- Printer
INSERT INTO assets (id, name, description, status, type_id)
VALUES (9, 'HP LaserJet', 'Máy in laser', 'AVAILABLE', 5);

INSERT INTO assets (id, name, description, status, type_id)
VALUES (10, 'Canon LBP2900', 'Máy in phổ biến', 'AVAILABLE', 5);