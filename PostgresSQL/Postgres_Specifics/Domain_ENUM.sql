-- 87. CREATE DOMAIN - Address
CREATE DOMAIN address AS TEXT
CHECK (VALUE ~ '^[A-Za-z0-9\s,.-]+$');

-- 88. CREATE DOMAIN - Positive number
CREATE DOMAIN positive_int AS INT
CHECK (VALUE > 0);

-- 89. CREATE DOMAIN - Postal code validation
CREATE DOMAIN postal_code AS TEXT
CHECK (VALUE ~ '^[0-9]{5}(-[0-9]{4})?$');

-- 90. CREATE DOMAIN - Email validation
CREATE DOMAIN email AS TEXT
CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

-- 91. CREATE DOMAIN - Enum/Set of values
CREATE DOMAIN movie_rating AS TEXT
CHECK (VALUE IN ('G', 'PG', 'PG-13', 'R', 'NC-17'));

-- 92. Get list of all DOMAIN data types
SELECT domain_name, data_type
FROM information_schema.domains
WHERE domain_schema = 'public';

-- 93. Drop a DOMAIN
DROP DOMAIN IF EXISTS email;

------------------------------------------------
-- TYPE SECTION
------------------------------------------------

-- 94. CREATE TYPE - Composite address object
CREATE TYPE address_obj AS (
    street TEXT,
    city   TEXT,
    zip    TEXT
);

-- 95. CREATE TYPE - Composite inventory item
CREATE TYPE inventory_item AS (
    name TEXT,
    supplier_id INT,
    price NUMERIC
);

-- 96. CREATE TYPE - ENUM
CREATE TYPE mood AS ENUM ('happy', 'sad', 'neutral');

-- Drop ENUM safely
DROP TYPE IF EXISTS mood;

-- 97. ALTER TYPE - Alter composite data type
ALTER TYPE address_obj ADD ATTRIBUTE country TEXT;

-- 98. ALTER TYPE - Alter ENUM data type
ALTER TYPE mood ADD VALUE 'angry';

-- 99. Update ENUM data in production (safe add)
ALTER TYPE mood ADD VALUE IF NOT EXISTS 'excited';

-- 100. ENUM with DEFAULT in a table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT,
    mood mood DEFAULT 'neutral'
);

-- 101. Create TYPE if not exists using PL/pgSQL
DO $$
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'mood') THEN
      CREATE TYPE mood AS ENUM ('happy', 'sad', 'neutral');
   END IF;
END$$;
