<<<<<<< HEAD
SELECT 
    d.*,
    (
        SELECT json_agg(x) AS all_movies
        FROM (
            SELECT movie_name
            FROM Movies
            WHERE director_id = d.director_id
        ) AS x
    )
FROM directors d;



SELECT 
    d.*,
    (
        SELECT json_agg(y) AS all_movies
        FROM (
            SELECT m.movie_name
            FROM movies m
            WHERE m.director_id = d.director_id
        ) AS y
    )
FROM directors d;
=======
INSERT INTO directors_docs(body)

SELECT  row_to_json(a)::jsonb FROM
    (
        director_id,
        first_name,
        last_name,
        date_of_birth,
        nationality,
        (
            SELECT json_agg(x) as all_movies FROM
            (
                SELECT
                      movie_name
                FROM movies
                WHERE director_id = directors.director_id
            ) x
        )
        FROM directors
    ) as a
>>>>>>> b05b598 (new stuff)
