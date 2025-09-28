-- 26. Insert a data into table
INSERT INTO actors (first_name, last_name, gender, date_of_birth)
VALUES ('Tom', 'Hanks', 'Male', '1956-07-09');

-- 27. Insert multiple records into a table
INSERT INTO actors (first_name, last_name, gender, date_of_birth) VALUES
('Emma', 'Watson', 'Female', '1990-04-15'),
('Robert', 'Downey', 'Male', '1965-04-04');

-- 28. Insert a data that had quotes
INSERT INTO movies (movie_name, movie_length, movie_lang, age_cert, release_date)
VALUES ('Schindler''s List', 195, 'English', 15, '1993-12-15');

-- 29. Use RETURNING to get info on added rows
INSERT INTO directors (first_name, last_name, nationality)
VALUES ('Steven', 'Spielberg', 'American')
RETURNING * ;

-- 30. Update data in a table
UPDATE actors
SET last_name = 'Hanks-Smith'
WHERE actor_id = 1;

-- 31. Updating a row and returning the updated row
UPDATE actors
SET last_name = 'Watson-Granger'
WHERE first_name = 'Emma'
RETURNING *;

-- 32. Updating all records in a table
UPDATE actors
SET add_date = CURRENT_DATE;

-- 33. Delete data from a table
DELETE FROM actors
WHERE first_name = 'Robert';

-- 34. Using UPSERT
INSERT INTO actors (actor_id, first_name, last_name)
VALUES (1, 'Tom', 'Hanks')
ON CONFLICT (actor_id) 
DO UPDATE SET last_name = EXCLUDED.last_name;

-- 35. Select all data from a table
SELECT * FROM movies;

-- 36. Selecting specific columns from a table
SELECT first_name, last_name FROM actors;

-- 37. Adding Aliases to columns in a table
SELECT first_name AS fname, last_name AS lname FROM actors;

-- 38. Using SELECT statement for expressions
SELECT movie_name, movie_length/60 AS length_hours FROM movies;

-- 39. Using ORDER BY to sort records
SELECT * FROM actors ORDER BY last_name ASC;

-- 40. Using ORDER BY with alias column name
SELECT first_name || ' ' || last_name AS full_name
FROM actors
ORDER BY full_name;

-- 41. Using ORDER BY to sort rows by expressions
SELECT movie_name, movie_length
FROM movies
ORDER BY movie_length * 1.6;  -- sort by "minutes in km" just for fun

-- 42. Using ORDER BY with column name or column number
SELECT first_name, last_name
FROM actors
ORDER BY 2;  -- order by last_name (2nd column)

-- 43. Using ORDER BY with NULL values
SELECT * FROM actors
ORDER BY remove_date NULLS LAST;

-- 44. Using DISTINCT for selecting distinct values
SELECT DISTINCT nationality FROM directors;

-- 45. Comparison, Logical and Arithmetic operators
SELECT * FROM movies
WHERE movie_length > 120 AND age_cert <= 13;

-- 46. AND operator
SELECT * FROM actors
WHERE gender = 'Male' AND last_name LIKE 'H%';

-- 47. OR operator
SELECT * FROM actors
WHERE first_name = 'Emma' OR first_name = 'Tom';

-- 48. Combining AND, OR operators
SELECT * FROM movies
WHERE (movie_lang = 'English' OR movie_lang = 'French')
  AND release_date > '2000-01-01';

-- 49. What goes before and after WHERE clause
SELECT * FROM actors
WHERE gender = 'Female'
ORDER BY last_name;

-- 50. Execution order with AND, OR operators
SELECT * FROM actors
WHERE gender = 'Male' OR gender = 'Female' AND first_name LIKE 'R%';

-- 51. Can we use column aliases with WHERE?
-- No, alias only works in SELECT/ORDER BY. This fails:
-- SELECT first_name || ' ' || last_name AS full_name FROM actors WHERE full_name LIKE 'T%';

-- 52. Order of execution of WHERE, SELECT and ORDER BY clauses
-- WHERE → SELECT → ORDER BY
SELECT first_name, last_name
FROM actors
WHERE gender = 'Male'
ORDER BY last_name;

-- 53. Using Logical operators
SELECT * FROM actors
WHERE (gender = 'Female' AND date_of_birth > '1980-01-01')
   OR (gender = 'Male' AND date_of_birth < '1970-01-01');

-- 54. Using LIMIT and OFFSET
SELECT * FROM actors
ORDER BY actor_id
LIMIT 3 OFFSET 2;

-- 55. Using FETCH
SELECT * FROM actors
ORDER BY actor_id
OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;

-- 56. Using IN, NOT IN
SELECT * FROM actors
WHERE first_name IN ('Tom', 'Emma');

SELECT * FROM actors
WHERE first_name NOT IN ('Tom', 'Emma');

-- 57. Using BETWEEN and NOT BETWEEN
SELECT * FROM movies
WHERE release_date BETWEEN '1990-01-01' AND '2000-12-31';

SELECT * FROM movies
WHERE release_date NOT BETWEEN '1990-01-01' AND '2000-12-31';

-- 58. Using LIKE and ILIKE
SELECT * FROM actors
WHERE last_name LIKE 'W%';    -- case-sensitive

SELECT * FROM actors
WHERE last_name ILIKE 'w%';   -- case-insensitive

-- 59. Using IS NULL and IS NOT NULL keywords
SELECT * FROM actors WHERE remove_date IS NULL;
SELECT * FROM actors WHERE remove_date IS NOT NULL;

-- 60. Concatenation techniques
SELECT first_name || ' ' || last_name AS full_name
FROM actors;

-- 72. Array
-- Example: store multiple languages a movie is available in
CREATE TABLE movie_languages (
    movie_id INT REFERENCES movies(movie_id),
    languages TEXT[]
);

-- Insert array values
INSERT INTO movie_languages (movie_id, languages)
VALUES (1, ARRAY['English', 'French', 'Spanish']);

-- Query: find all movies available in English
SELECT movie_id, languages
FROM movie_languages
WHERE 'English' = ANY(languages);

-- Query: append a new language to array
UPDATE movie_languages
SET languages = array_append(languages, 'German')
WHERE movie_id = 1;

-- Query: check array length
SELECT movie_id, array_length(languages, 1) AS num_languages
FROM movie_languages;

-- 73. hstore
-- hstore is a key-value store inside a column (needs extension)
CREATE EXTENSION IF NOT EXISTS hstore;

-- Example: store movie metadata flexibly
CREATE TABLE movie_metadata (
    movie_id INT REFERENCES movies(movie_id),
    info hstore
);

-- Insert hstore values
INSERT INTO movie_metadata (movie_id, info)
VALUES (1, 'rating => PG-13, budget => 80000000, box_office => 150000000');

-- Query: get the budget of movie 1
SELECT info->'budget' AS budget
FROM movie_metadata
WHERE movie_id = 1;

-- Query: update/add a key-value
UPDATE movie_metadata
SET info = info || 'awards => Oscar'
WHERE movie_id = 1;

-- Query: filter by hstore key value
SELECT movie_id
FROM movie_metadata
WHERE info->'rating' = 'PG-13';


CREATE TABLE users_data (
    id SERIAL PRIMARY KEY,
    profile JSONB
);

INSERT INTO users_data (profile)
VALUES ('{ "name": "Emma", "skills": ["SQL", "Python"], "active": true }');

-- Query a nested key
SELECT profile->>'name' FROM users_data;
-- returns: Emma

-- Filter by JSONB field
SELECT * FROM users_data
WHERE profile->>'active' = 'true';

-- Index for fast search
CREATE INDEX idx_users_profile ON users_data USING gin (profile);

-- Query with index
SELECT * FROM users_data
WHERE profile @> '{"skills": ["SQL"]}';



