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
    Main_style          VARCHAR(30),
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
    ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS other;
CREATE TABLE other(
    ID_no               INTEGER NOT NULL,
    Otype               VARCHAR(30),
    Style               VARCHAR(30),
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE ON UPDATE CASCADE
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
    ON DELETE CASCADE ON UPDATE CASCADE
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
    ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS permanent_collection;
CREATE TABLE permanent_collection(
    ID_no               INTEGER NOT NULL,
    Date_acquired       VARCHAR(30),
    Current_status      ENUM('Active', 'Inactive'),
    Cost                REAL,
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS exhibition;
CREATE TABLE exhibition(
    EName               VARCHAR(100) NOT NULL,
    Startdate           VARCHAR(30),
    Enddate             VARCHAR(30),
    PRIMARY KEY (EName)
);


DROP TABLE IF EXISTS exhibit;
CREATE TABLE exhibit(
    ID_no               INTEGER NOT NULL,
    EName               VARCHAR(100) NOT NULL,
    PRIMARY KEY (ID_no, EName),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (EName) REFERENCES exhibition(EName) ON DELETE CASCADE ON UPDATE CASCADE
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
    Date_borrowed       VARCHAR(30),
    Date_returned       VARCHAR(30),
    
    PRIMARY KEY (ID_no, Borrowed_from),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Borrowed_from) REFERENCES collections(CName)
    ON DELETE CASCADE ON UPDATE CASCADE
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
DELIMITER ;

DROP TRIGGER IF EXISTS add_painting;
DELIMITER //
CREATE TRIGGER add_painting
BEFORE INSERT ON painting
FOR EACH ROW
BEGIN
IF NEW.ID_no NOT IN (SELECT id_no FROM art_object)
THEN INSERT INTO art_object (id_no) VALUES (NEW.id_no);
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS add_sculpture;
DELIMITER //
CREATE TRIGGER add_sculpture
BEFORE INSERT ON sculpture
FOR EACH ROW
BEGIN
IF NEW.ID_no NOT IN (SELECT id_no FROM art_object)
THEN INSERT INTO art_object (id_no) VALUES (NEW.id_no);
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS add_statue;
DELIMITER //
CREATE TRIGGER add_statue
BEFORE INSERT ON statue
FOR EACH ROW
BEGIN
IF NEW.ID_no NOT IN (SELECT id_no FROM art_object)
THEN INSERT INTO art_object (id_no) VALUES (NEW.id_no);
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS add_other;
DELIMITER //
CREATE TRIGGER add_other
BEFORE INSERT ON other
FOR EACH ROW
BEGIN
IF NEW.ID_no NOT IN (SELECT id_no FROM art_object)
THEN INSERT INTO art_object (id_no) VALUES (NEW.id_no);
END IF;
END;//
DELIMITER ;

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
DELIMITER ;

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
DELIMITER ;

DROP TRIGGER IF EXISTS delete_painting;
DELIMITER //
CREATE TRIGGER delete_painting
AFTER DELETE ON painting
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object)) THEN
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS delete_statue;
DELIMITER //
CREATE TRIGGER delete_statue
AFTER DELETE ON statue
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object)) THEN
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS delete_sculpture;
DELIMITER //
CREATE TRIGGER delete_sculpture
AFTER DELETE ON sculpture
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object)) THEN
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS delete_other;
DELIMITER //
CREATE TRIGGER delete_other
AFTER DELETE ON other
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object)) THEN
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS delete_perm;
DELIMITER //
CREATE TRIGGER delete_perm
AFTER DELETE ON permanent_collection
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object)) THEN
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS delete_borrowed;
DELIMITER //
CREATE TRIGGER delete_borrowed
AFTER DELETE ON borrowed
FOR EACH ROW
BEGIN
IF (OLD.id_no in (SELECT id_no FROM art_object)) THEN
DELETE FROM art_object WHERE id_no = old.id_no;
END IF;
END;//
DELIMITER ;

DROP TRIGGER IF EXISTS update_painting;
DELIMITER //
CREATE TRIGGER update_painting
BEFORE UPDATE ON painting
FOR EACH ROW
BEGIN
IF (OLD.id_no <> NEW.id_no)
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'To change ID_no of painting, make the change in the art_object table.';
END IF;
END;//
DELIMITER ;

INSERT INTO artist
VALUES 
('Bennedeto', 'da Rovezzano', '1474', '1552', 'Italy', 'Early Modern Period', 'Renaissance', 'Bennedeto was an Italian Architect and Sculptor who worked mainly in Florence.'),
('Hans', 'Holbein', '1497', '1543', 'Germany', 'Early Modern Period', 'Northern Renaissance', 'Holbein was a German-Swiss artist who is known as being one fo the best portraitists of the 16th century.'),
('Affabel', 'Partridge', 'UNKNOWN', 'UNKNOWN', 'Britain', 'Early Modern Period', 'Renaissance', 'Partridge was a goldsmith who worked in London, who is known for being tasked with improving old jewlery for Elizabeth I'),
('Earl', 'Robbins', '1922', '2010', 'United States', 'Postmodernity', 'Earthenware', 'Earl Robbins was a Native American artist from South Carolina.'),
('Vincent', 'van Gogh', '1853', '1890', 'Netherlands', 'Long Nineteenth Century', 'Post-Impressionist', 'Vincent Van Gogh was a Dutch painter who has become extremely well known in modern times, but did not receive much credit during his time.'),
('Louis', 'Richard', '1791', '1879', 'France', 'Long Nineteenth Century', 'Bronze Sculpting', 'Richard was a 19th century French scultor, known for creating realistic statues.'),
('Louis', 'Barrias', '1841', '1905', 'France', 'Long Nineteenth Century', 'Romantic Realist', 'Barrias was a frech sculptor known for his romantic realist style and marble work.'),
('Antoine', 'Barye', '1795', '1875', 'France', 'Romantic Period', 'Bronze Sculpting', 'Well known for his bronze sculptures, Antoine Barye was a French sculture during the romantic period.'),
('Nicolas', 'Coustou', '1658', '1733', 'France', 'Early Modern Period', 'Baroque', 'Coustou was a French sculptor and academic who created many art pieces in the Baroque style.');


INSERT INTO art_object
VALUES      
('001', 'Angel Bearing Candlestick', 'Sculpture of an Angel bearing a Candlestick', '1524', 'Early Modern Period', 'Italy', 'da Rovezzano', 'Bennedeto'),
('002', 'Candelabrum', 'Metalwork Candlestick', '1500', 'Early Modern Period', 'Italy', 'da Rovezzano', 'Bennedeto'),
('003', 'Henry VIII', 'Painting of Henry VIII', '1537', 'Early Modern Period', 'Germany', 'Holbein', 'Hans'),
('004', 'Ewer', 'Silver Ewer', '1562', 'Early Modern Period', 'Britain', 'Partridge', 'Affabel'),
('005', 'Cupid Jug', 'Native American Jug', '2000', 'Postmodernity', 'USA', 'Robbins', 'Earl'),
('006', "At Eternity's Gate", 'Painting of Gentleman Weeping', '1882', 'Long Nineteenth Century', 'Netherlands', 'van Gogh', 'Vincent'),
('007', 'Shoes', 'Painting of Shoes of Red-Tile Floor', '1888', 'Long Nineteenth Century', 'Netherlands', 'van Gogh', 'Vincent'),
('008', 'Beggarman', 'Bronze Statue of a Horse', '1841', 'Long Nineteenth Century', 'France', 'Richard', 'Louis'),
('009', 'Alexandre of Cyrene', 'Sculpture of Alexandre of Cyrene', '1914', 'Modern', 'Italy', NULL, NULL),
('010', 'Ours Debout', 'Sculpture of a Bronze Bear Standing', '1876', 'Long Nineteenth Century', 'France', 'Barye', 'Antoine'),
('011', 'Le Serment de Spartacus', 'Marble Statue of Spartacus', '1871', 'Long Nineteenth Century', 'France', 'Barrias', 'Louis'),
('012', 'Jules Cesar', 'Statue of Julius Cesear', '1696', 'Early Modern Period', 'France', 'Coustou', 'Nicolas'),
('013', "Tete d'Homme Age", 'Painting of an Old Gentleman', '1737', 'Early Modern Period', 'France', NULL, NULL);


INSERT INTO painting
VALUES
('003', 'Oil', 'Panel', 'Renaissance'),
('007', 'Oil', 'Canvas', 'Post-Impressionist'),
('006', 'Print', 'Transfer Lithograph', 'Post-Impressionist'),
('013', 'Oil', 'Canvas', 'Neoclassicism');

INSERT INTO other
VALUES
('002', 'Candelabrum', 'Rennaissance'),
('004', 'Ewer', 'Rennaissance'),
('005', 'Jug', 'Post-Modern');

INSERT INTO statue
VALUES
('008', 'Bronze', '279', 'UNKNOWN', 'Modern'),
('009', 'Plaster', '72.5', 'UNKNOWN', 'Modern'),
('011', 'Marble', '210', 'UNKNOWN', 'Modern' ),
('012', 'Marble', '2422', 'UNKNOWN', 'Modern');

INSERT INTO sculpture
VALUES
('001', 'Bronze', '101', '141', 'Renaissance'),
('010', 'Bronze', '243', 'UNKNOWN', 'Modern');

INSERT INTO permanent_collection
VALUES
('001', '2001-09-11', 'Active', '42000'),
('002', '2001-09-11', 'Active', '69000'),
('003', '2001-09-11', 'Active', '0'),
('004', '2001-09-11', 'Inactive', '1000000'),
('005', '2001-09-11', 'Inactive', '0'),
('006', '2001-09-11', 'Active', '90000');

INSERT INTO collections
VALUES
('Louvre', 'Variety', 'The permanent collection of the Louvre containing a wide variety of art.', 'Jane Museum', '33140205317', 'Musée du Louvre, 75001 Paris, France');

INSERT INTO borrowed
VALUES
('008', 'Louvre', '2018-05-16', NULL),
('009', 'Louvre', '2012-03-12', '2015-05-16'),
('010', 'Louvre', '2014-01-23', NULL),
('011', 'Louvre', '2013-08-18', '2016-09-20'),
('012', 'Louvre', '2011-07-12', NULL),
('013', 'Louvre', '2003-05-08', '2005-05-08');

INSERT INTO exhibition
VALUES
('The Tudors: Art and Majesty in Renaissance England', '2022-10-10', '2023-01-08'),
('Van Gogh, Mondrian, and Munch: Selections from the Department of Drawings and Prints', '2022-07-07', '2022-10-11'),
('Romanticism in Sculpture', '2014-01-23',  NULL),
('Fine Arts', '2012-03-12', '2015-05-16' ),
('Tuileries Gardens', '2013-08-18', '2016-09-20'),
('Cour Puget', '2011-10-12', NULL);

INSERT INTO exhibit
VALUES 
('001', 'The Tudors: Art and Majesty in Renaissance England'),
('002', 'The Tudors: Art and Majesty in Renaissance England'),
('003', 'The Tudors: Art and Majesty in Renaissance England'),
('004', 'The Tudors: Art and Majesty in Renaissance England'),
('006', 'Van Gogh, Mondrian, and Munch: Selections from the Department of Drawings and Prints'),
('007', 'Van Gogh, Mondrian, and Munch: Selections from the Department of Drawings and Prints'),
('008', 'Romanticism in Sculpture'),
('009', 'Fine Arts'),
('010', 'Romanticism in Sculpture'),
('011', 'Tuileries Gardens'),
('012', 'Cour Puget');

DROP ROLE IF EXISTS db_admin@localhost, mid_access@localhost, read_access@localhost;
CREATE ROLE db_admin@localhost, mid_access@localhost, read_access@localhost;
GRANT ALL PRIVILEGES ON ART_MUSEUM.* TO db_admin@localhost;
GRANT SELECT, INSERT, DELETE, UPDATE ON ART_MUSEUM.* TO mid_access@localhost;
GRANT Select ON ART_MUSEUM.* TO read_access@localhost;

DROP USER IF EXISTS adm@localhost;
DROP USER IF EXISTS data_entry@localhost;
DROP USER IF EXISTS guest@localhost;

CREATE USER adm@localhost IDENTIFIED WITH mysql_native_password BY 'password';

CREATE USER guest@localhost;

CREATE USER data_entry@localhost IDENTIFIED WITH mysql_native_password BY 'password';

GRANT db_admin@localhost TO adm@localhost;
GRANT mid_access@localhost TO data_entry@localhost;
GRANT read_access@localhost TO guest@localhost;
SET DEFAULT ROLE ALL TO adm@localhost;
SET DEFAULT ROLE ALL TO data_entry@localhost;
SET DEFAULT ROLE ALL TO guest@localhost;