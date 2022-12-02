DROP DATABASE IF EXISTS ART_MUSEUM;
CREATE DATABASE ART_MUSEUM; 
USE ART_MUSEUM;

DROP TABLE IF EXISTS art_object;
CREATE TABLE art_object (
    ID_no               INTEGER,
    Title               VARCHAR(255),
    Descrip             VARCHAR(255),
    year_created        INTEGER,
    Epoch               VARCHAR(30),
    Country_of_origin   VARCHAR(30)
    PRIMARY KEY (ID_no)
);


