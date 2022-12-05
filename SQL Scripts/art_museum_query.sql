USE ART_MUSEUM;


-- Basic Retrieval
SELECT ID_no, Paint_type, Drawn_on, Style
FROM painting;


-- Retrieval with ordered results
SELECT Lname, Fname, Year_born
FROM artist 
ORDER BY Year_born;