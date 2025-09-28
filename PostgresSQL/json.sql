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
