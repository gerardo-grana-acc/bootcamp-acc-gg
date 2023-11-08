
-- a) Muestra todos los libros de la tabla Libros.
SELECT * FROM Libros;

-- b) Muestra los libros publicados después de 2010.
SELECT * FROM Libros WHERE publicacion > 2010;

-- c) Muestra los libros escritos por un autor específico que elijas.
SELECT * FROM Libros WHERE autor = 'John Kennedy Toole';

-- d) Muestra los libros publicados por una editorial específica que elijas.

SELECT * FROM Libros WHERE editorial = 'Pan Books';

-- Elimina un libro de la tabla Libros basado en un criterio 
DELETE FROM Libros WHERE publicacion > 1985

-- Agrega al menos dos libros más a la tabla.
INSERT INTO Libros (id, titulo, autor, publicacion, editorial) 
	VALUES (00006, '¿Dónde estoy?', 'Bruno Latour', 2021, 'Editions La Decouverte')
	UNION ALL
    VALUES (00007, 'Infocracy: Digitization and the Crisis of Democracy', 'Byun Chul Han', 2022, 'Polity Pres')
;

-- Realiza una consulta que combine múltiples condiciones
SELECT * FROM Libros WHERE publicacion >= 2020 AND publicacion <= 2022