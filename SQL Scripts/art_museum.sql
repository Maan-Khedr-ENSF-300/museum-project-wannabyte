DROP DATABASE IF EXISTS ART_MUSEUM;
CREATE DATABASE ART_MUSEUM; 
USE ART_MUSEUM;

DROP TABLE IF EXISTS artist;
CREATE TABLE artist(
    Fname               VARCHAR(30) NOT NULL,
    Lname               VARCHAR(30) NOT NULL,
    Year_born           VARCHAR(30) NOT NULL DEFAULT 'UNKNOWN',
    Year_died           VARCHAR(30) NOT NULL DEFAULT 'UNKNOWN',
    Country_of_origin   VARCHAR(30),
    Epoch               VARCHAR(30),
    Main_stlye          VARCHAR(30),
    Descrip             VARCHAR(255),
    PRIMARY KEY (Fname, Lname)
);


DROP TABLE IF EXISTS art_object;
CREATE TABLE art_object (
    ID_no               INTEGER NOT NULL,
    Title               VARCHAR(255),
    Descrip             VARCHAR(255),
    year_created        VARCHAR(30) DEFAULT 'UNKNOWN',
    Epoch               VARCHAR(30),
    Country_of_origin   VARCHAR(30),
    ALname              VARCHAR(30),
    AFname              VARCHAR(30),
    PRIMARY KEY (ID_no),
    FOREIGN KEY (AFname, ALname) REFERENCES artist(Fname, Lname)
);

DROP TABLE IF EXISTS painting;
CREATE TABLE painting (
    ID_no               INTEGER NOT NULL,
    Paint_type          VARCHAR(30),
    Drawn_on            VARCHAR(30),
    Style               VARCHAR(30),
    PRIMARY KEY (ID_no),
    CONSTRAINT FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)   
    ON DELETE CASCADE
);

DROP TABLE IF EXISTS other;
CREATE TABLE other(
    ID_no               INTEGER NOT NULL,
    Otype               VARCHAR(30),
    Style               VARCHAR(30),
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE
);


DROP TABLE IF EXISTS sculpture;
CREATE TABLE sculpture(
    ID_no               INTEGER NOT NULL,
    Material            VARCHAR(30),
    Height              VARCHAR(30)DEFAULT 'UNKNOWN',
    Weight_in_kg        VARCHAR(30)DEFAULT 'UNKNOWN',
    Style               VARCHAR(30),
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE
);


DROP TABLE IF EXISTS statue;
CREATE TABLE statue(
    ID_no               INTEGER NOT NULL,
    Material            VARCHAR(30),
    Height              VARCHAR(30) DEFAULT 'UNKNOWN',
    Weight_in_kg        VARCHAR(30) DEFAULT 'UNKNOWN',
    Style               VARCHAR(30),
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE
);


DROP TABLE IF EXISTS permanent_collection;
CREATE TABLE permanent_collection(
    ID_no               INTEGER NOT NULL,
    Date_acquired       DATE,
    Current_status      ENUM('Active', 'Inactive'),
    Cost                REAL,
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE
);


DROP TABLE IF EXISTS exhibition;
CREATE TABLE exhibition(
    EName               VARCHAR(100),
    Startdate           DATE,
    Enddate             DATE,
    PRIMARY KEY (EName)
);


DROP TABLE IF EXISTS exhibit;
CREATE TABLE exhibit(
    ID_no               INTEGER NOT NULL,
    EName               VARCHAR(100),
    PRIMARY KEY (ID_no, EName),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no) ON DELETE CASCADE,
    FOREIGN KEY (EName) REFERENCES exhibition(EName) ON DELETE CASCADE
);


DROP TABLE IF EXISTS collections;
CREATE TABLE collections(
    CName               VARCHAR(30) NOT NULL,
    CType               VARCHAR(30) DEFAULT 'UNKNOWN',
    Descrip             VARCHAR(255),
    Contact_person      VARCHAR(30),
    Phone               VARCHAR(30),
    Address			    VARCHAR(100),
    PRIMARY KEY (CName)
);


DROP TABLE IF EXISTS borrowed;
CREATE TABLE borrowed(
    ID_no               INTEGER NOT NULL,
    Borrowed_from       VARCHAR(30),
    Date_borrowed       DATE,
    Date_returned       DATE,
    
    PRIMARY KEY (ID_no, Borrowed_from),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE,
    FOREIGN KEY (Borrowed_from) REFERENCES collections(CName)
    ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS add_art;
DELIMITER //
CREATE TRIGGER add_art
BEFORE INSERT ON art_object
FOR EACH ROW
BEGIN
IF ((NEW.ALname IS NOT NULL) AND (NEW.AFname IS NOT NULL) AND (NEW.ALname NOT IN (SELECT Lname FROM artist)))
THEN INSERT INTO artist(Fname, Lname) VALUES (NEW.AFname, NEW.ALname);
END IF;
END;//

DROP TRIGGER IF EXISTS add_borrowed_from;
DELIMITER //
CREATE TRIGGER add_borrowed_from
BEFORE INSERT ON borrowed
FOR EACH ROW
BEGIN
IF ((NEW.Borrowed_from IS NOT NULL) AND (NEW.Borrowed_from NOT IN (SELECT Cname FROM collections)))
THEN INSERT INTO collections(Cname) VALUES (NEW.Borrowed_from);
END IF;
END;//

DROP TRIGGER IF EXISTS delete_artist;
DELIMITER //
CREATE TRIGGER delete_artist
BEFORE DELETE ON artist
FOR EACH ROW
BEGIN
IF (OLD.Lname IN (SELECT ALname FROM art_object))
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete artist with existing art objects';
END IF;
END;//

DROP TRIGGER IF EXISTS delete_painting;
DELIMITER //
CREATE TRIGGER delete_painting
AFTER DELETE ON painting
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object))
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//

DROP TRIGGER IF EXISTS delete_statue;
DELIMITER //
CREATE TRIGGER delete_statue
AFTER DELETE ON statue
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object))
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//

DROP TRIGGER IF EXISTS delete_sculpture;
DELIMITER //
CREATE TRIGGER delete_sculpture
AFTER DELETE ON sculpture
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object))
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//

DROP TRIGGER IF EXISTS delete_other;
DELIMITER //
CREATE TRIGGER delete_other
AFTER DELETE ON other
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object))
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//

DROP TRIGGER IF EXISTS delete_perm;
DELIMITER //
CREATE TRIGGER delete_perm
AFTER DELETE ON permanent_collection
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object))
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//

DROP TRIGGER IF EXISTS delete_borrowed;
DELIMITER //
CREATE TRIGGER delete_borrowed
AFTER DELETE ON borrowed
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object))
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//


