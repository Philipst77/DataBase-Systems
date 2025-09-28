-- =============================
-- 102. Introduction to Constraints
-- (Constraints ensure data integrity in PostgreSQL)
-- =============================

-- 103. NOT NULL constraint
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- 104. UNIQUE constraint
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    email TEXT UNIQUE
);

-- 105. DEFAULT constraint
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    price NUMERIC DEFAULT 9.99
);

-- 106. PRIMARY KEY constraint
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name TEXT
);

-- 107. PRIMARY KEY on multiple columns (composite key)
CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id)
);

-- 108. FOREIGN KEY constraint
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE enrollments_fk (
    student_id INT,
    course_id INT REFERENCES courses(course_id)
);

-- 109. Table without foreign key constraint (allows inconsistent data)
CREATE TABLE bad_enrollments (
    student_id INT,
    course_id INT
);

-- 110. Creating foreign key constraint on existing table
ALTER TABLE enrollments_fk
ADD CONSTRAINT fk_course FOREIGN KEY (course_id)
REFERENCES courses(course_id);

-- 111. Foreign keys maintain referential integrity
-- (Insert with invalid course_id will fail)
-- INSERT INTO enrollments_fk VALUES (1, 9999); -- ERROR

-- 112. Drop a constraint
-- Example: Drop UNIQUE constraint on employees.email
ALTER TABLE employees DROP CONSTRAINT employees_email_key;

-- 113. Add or update foreign key constraint on existing table
ALTER TABLE enrollments_fk
ADD CONSTRAINT fk_student FOREIGN KEY (student_id)
REFERENCES students(student_id);

-- 114. CHECK constraint - Introduction
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    balance NUMERIC CHECK (balance >= 0)
);

-- 115. CHECK constraint - Add to new table
CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    rating INT CHECK (rating BETWEEN 1 AND 10)
);

-- 116. CHECK constraint - Add, Rename, Drop on existing table
ALTER TABLE movies
ADD CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 10);

ALTER TABLE movies
RENAME CONSTRAINT chk_rating TO rating_check;

ALTER TABLE movies
DROP CONSTRAINT rating_check;
