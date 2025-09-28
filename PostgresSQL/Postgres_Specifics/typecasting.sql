-- 79. What is a data type conversion
-- Converting one data type into another so PostgreSQL can work with it
-- Example: convert a string to an integer
SELECT '123'::INT AS converted_to_int;   -- result: 123

-- Example: convert a string to a date
SELECT '2025-09-24'::DATE AS converted_to_date; -- result: 2025-09-24

------------------------------------------------------------

-- 80. Using CAST for data conversions
-- CAST() is the SQL-standard way to convert data types
SELECT CAST('456' AS INTEGER) AS converted_to_int;  -- result: 456

-- Convert a number to text
SELECT CAST(789 AS TEXT) AS converted_to_text;  -- result: '789'

-- Convert a string to timestamp
SELECT CAST('2025-09-24 10:45:00' AS TIMESTAMP) AS converted_to_timestamp;

------------------------------------------------------------

-- 81. Implicit to Explicit conversions
-- Implicit conversion: PostgreSQL does it automatically
SELECT 10 + 3.5;  
-- 10 (integer) is implicitly converted to numeric to match 3.5

-- Explicit conversion: you do it manually
SELECT 10::NUMERIC + 3.5;  -- explicitly cast integer to numeric

-- Another explicit example
SELECT '42'::INT + 8;  -- explicitly convert text '42' into integer

------------------------------------------------------------

-- 82. Table data conversion
-- Example: changing column type in a table

-- Step 1: Create a sample table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    amount TEXT  -- stored as text (not great for math!)
);

-- Step 2: Insert sample data
INSERT INTO payments (amount) VALUES ('100'), ('250'), ('400');

-- Step 3: Convert column type (text → integer)
ALTER TABLE payments
ALTER COLUMN amount TYPE INTEGER USING amount::INTEGER;

-- Now amount is an integer column, and we can do math:
SELECT SUM(amount) AS total_payments FROM payments;  -- result: 750


--FORMATTED TYPE CASTING 


-- 83. to_char
-- Converts numbers and dates to text with formatting

-- Format a number
SELECT to_char(1234567.89, 'FM9,999,999.00') AS formatted_number;
-- result: '1,234,567.89'

-- Format a date
SELECT to_char(CURRENT_DATE, 'Day, DD Mon YYYY') AS formatted_date;
-- result: 'Tuesday 24 Sep 2025' (example)

------------------------------------------------------------

-- 84. to_number
-- Converts a text string into a number, using a format model

SELECT to_number('1,234,567.89', '9,999,999.99') AS numeric_value;
-- result: 1234567.89

-- Another example
SELECT to_number('2025', '9999') + 1 AS next_year;
-- result: 2026

------------------------------------------------------------

-- 85. to_date
-- Converts a string into a DATE using a format pattern

SELECT to_date('24-09-2025', 'DD-MM-YYYY') AS converted_date;
-- result: 2025-09-24

-- Another example
SELECT to_date('09/24/25', 'MM/DD/YY') AS converted_date;
-- result: 2025-09-24

------------------------------------------------------------

-- 86. to_timestamp
-- Converts a string into a TIMESTAMP (date + time)

SELECT to_timestamp('2025-09-24 14:30:00', 'YYYY-MM-DD HH24:MI:SS') AS converted_timestamp;
-- result: 2025-09-24 14:30:00

-- Another example (with 12-hour format and AM/PM)
SELECT to_timestamp('09-24-2025 02:30 PM', 'MM-DD-YYYY HH12:MI AM') AS converted_timestamp;
-- result: 2025-09-24 14:30:00
