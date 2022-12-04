USE ART_MUSEUM;
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