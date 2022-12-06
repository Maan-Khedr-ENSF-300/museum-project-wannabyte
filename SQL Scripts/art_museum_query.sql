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

-- Same as above but not nested and has column with oil
SELECT a.Fname, a.Lname, p.Paint_type
FROM artist AS a, painting AS p, art_object AS o
WHERE a.Fname = o.AFname
AND o.ID_no = p.ID_no
AND p.Paint_type = 'Oil';

-- Update operation
UPDATE art_object
SET Country_of_origin = 'Canada'
WHERE ID_no = 010;

SELECT Country_of_origin
FROM art_object
WHERE ID_no = 010;

-- Update showing custom trigger called
UPDATE painting SET ID_no = '100'
WHERE ID_no = '003';

SELECT * FROM painting;

