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
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)    
);

DROP TABLE IF EXISTS other;
CREATE TABLE other(
    ID_no               INTEGER NOT NULL,
    Otype               VARCHAR(30),
    Style               VARCHAR(30),
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
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
);


DROP TABLE IF EXISTS permanent_collection;
CREATE TABLE permanent_collection(
    ID_no               INTEGER NOT NULL,
    Date_acquired       DATE,
    Current_status      ENUM('Active', 'Inactive'),
    Cost                REAL,
    PRIMARY KEY (ID_no),
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no)
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
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no),
    FOREIGN KEY (EName) REFERENCES exhibition(EName)
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
    FOREIGN KEY (ID_no) REFERENCES art_object(ID_no),
    FOREIGN KEY (Borrowed_from) REFERENCES collections(CName)
);

