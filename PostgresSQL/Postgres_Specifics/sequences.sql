-- =========================================================
-- 117. Create a sequence, advance it, get current value, set value
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS test_seq START 1;

-- Advance sequence
SELECT NEXTVAL('test_seq');   -- 1
SELECT NEXTVAL('test_seq');   -- 2

-- Current value (this session only)
SELECT CURRVAL('test_seq');   -- 2

-- Set value manually
SELECT SETVAL('test_seq', 100);
SELECT NEXTVAL('test_seq');   -- 101


-- =========================================================
-- 119. Create a sequence with START WITH, INCREMENT, MINVALUE, MAXVALUE
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS custom_seq
    START WITH 10
    INCREMENT BY 5
    MINVALUE 10
    MAXVALUE 50
    CYCLE;

SELECT NEXTVAL('custom_seq');   -- 10
SELECT NEXTVAL('custom_seq');   -- 15


-- =========================================================
-- 120. Create a sequence using a specific data type
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS big_seq AS BIGINT START 1;

SELECT NEXTVAL('big_seq');


-- =========================================================
-- 121. Creating a descending sequence, and CYCLE
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS down_seq
    START WITH 10
    INCREMENT BY -1
    MINVALUE 1
    MAXVALUE 10
    CYCLE;

SELECT NEXTVAL('down_seq');   -- 10, 9, 8... then cycles


-- =========================================================
-- 122. Delete a sequence
-- =========================================================
DROP SEQUENCE IF EXISTS test_seq;


-- =========================================================
-- 123. Attach a sequence to a table column
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS order_seq;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT DEFAULT NEXTVAL('order_seq'),
    product TEXT
);

INSERT INTO orders (product) VALUES ('Laptop');
INSERT INTO orders (product) VALUES ('Phone');

SELECT * FROM orders;


-- =========================================================
-- 124. List all sequences in a database
-- =========================================================
-- From information_schema
SELECT sequence_name
FROM information_schema.sequences
WHERE sequence_schema = 'public';

-- From pg_class
SELECT relname AS sequence_name
FROM pg_class
WHERE relkind = 'S';


-- =========================================================
-- 125. Share one sequence between two tables
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS shared_seq;

CREATE TABLE IF NOT EXISTS invoices (
    id INT DEFAULT NEXTVAL('shared_seq'),
    amount NUMERIC
);

CREATE TABLE IF NOT EXISTS receipts (
    id INT DEFAULT NEXTVAL('shared_seq'),
    description TEXT
);

INSERT INTO invoices (amount) VALUES (500);
INSERT INTO receipts (description) VALUES ('Payment received');

SELECT * FROM invoices;
SELECT * FROM receipts;


-- =========================================================
-- 126. Create an alphanumeric sequence
-- =========================================================
CREATE SEQUENCE IF NOT EXISTS invoice_seq START 1;

-- Generate IDs like INV001, INV002, ...
SELECT 'INV' || LPAD(NEXTVAL('invoice_seq')::TEXT, 3, '0') AS invoice_id;
