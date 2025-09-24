-- Example 1: Simple function (add two numbers)
CREATE OR REPLACE FUNCTION add_numbers(a INT, b INT)
RETURNS INT AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;

-- Test it
SELECT add_numbers(10, 20);  -- returns 30


-- Example 2: Function with logic (classify movie length)
CREATE OR REPLACE FUNCTION classify_movie(length_minutes INT)
RETURNS TEXT AS $$
BEGIN
    IF length_minutes < 90 THEN
        RETURN 'Short';
    ELSIF length_minutes <= 150 THEN
        RETURN 'Standard';
    ELSE
        RETURN 'Long';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Test it
SELECT classify_movie(120);  -- 'Standard'


-- Example 3: Function returning a TABLE
CREATE OR REPLACE FUNCTION get_actors_by_gender(g TEXT)
RETURNS TABLE (actor_id INT, first_name TEXT, last_name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT a.actor_id, a.first_name, a.last_name
    FROM actors a
    WHERE a.gender = g;
END;
$$ LANGUAGE plpgsql;

-- Test it
-- SELECT * FROM get_actors_by_gender('Female');


-- Example 4: Using variables + loops (sum of first n numbers)
CREATE OR REPLACE FUNCTION sum_first_n(n INT)
RETURNS INT AS $$
DECLARE
    total INT := 0;
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        total := total + i;
    END LOOP;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Test it
SELECT sum_first_n(10);  -- returns 55
