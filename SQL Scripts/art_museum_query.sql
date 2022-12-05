USE ART_MUSEUM;


-- Basic Retrieval
SELECT ID_no, Paint_type, Drawn_on, Style
FROM painting;


-- Retrieval with ordered results
SELECT Lname, Fname, Year_born
FROM artist 
ORDER BY Year_born;

-- Nested Retrieval Query
SELECT Fname, Lname
FROM artist
WHERE Fname IN (
	SELECT AFname
    FROM art_object
    WHERE ID_no IN (
		SELECT ID_no
        FROM painting
        WHERE Paint_type = 'Oil'
	)
);