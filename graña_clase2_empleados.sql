CREATE SCHEMA EMPRESA;

USE EMPRESA;
CREATE TABLE EMPLEADOS (
	EMP_ID int auto_increment,
    EMP_NOMBRE varchar(30),
    EMP_APELLIDO varchar(30),
    EMP_DNI int,
    EMP_TELEFONO int,
    EMP_DIRECCION varchar(30),
    EMP_FECHA_ALTA date,
    EMP_FECHA_NAC date,
    EMP_PROVINCIA_ID INT,
    EMP_PUESTO_ID INT,
    foreign key (EMP_PROVINCIA_ID) REFERENCES PROVINCIAS(ID),
    foreign key (EMP_PUESTO_ID) REFERENCES PUESTOS(ID),
    PRIMARY KEY(EMP_ID)
);

USE EMPRESA;
CREATE TABLE PROVINCIAS (
	ID int auto_increment,
    PROVINCIA varchar (30),
    PRIMARY KEY(ID)
);

USE EMPRESA;
CREATE TABLE PUESTOS (
	ID int auto_increment,
    PUESTO varchar (30),
    PRIMARY KEY(ID)
);

CREATE TABLE EMPLEADOS (
	EMP_ID INT AUTO_INCREMENT,
    EMP_NOMBRE VARCHAR(30),
    EMP_APELLIDO VARCHAR(30),
    EMP_DNI INT,
    EMP_TELEFONO INT,
    EMP_DIRECCION VARCHAR(30),
    PROV_ID INT,
    EMP_FECHA_ALTA DATE,
    EMP_FECHA_NAC DATE,
    EMP_CARGO VARCHAR(50),
    PRIMARY KEY(EMP_ID),
    FOREIGN KEY (PROV_ID) REFERENCES PROVINCIAS (PROV_ID)
);

-- INSERSIONES DE DATOS
-- EMPLEADOS
INSERT INTO EMPLEADOS (EMP_NOMBRE, EMP_APELLIDO, EMP_DNI, EMP_TELEFONO, EMP_DIRECCION, EMP_FECHA_ALTA, EMP_FECHA_NAC, EMP_PROVINCIA_ID, EMP_PUESTO_ID) VALUES ("Carolina", "Herrera", "99999999", "1111111111", "Av. 9 de Julio 1111", "2000-12-11", "2020-12-31", 1, 1);
INSERT INTO EMPLEADOS (EMP_NOMBRE, EMP_APELLIDO, EMP_DNI, EMP_TELEFONO, EMP_DIRECCION, EMP_FECHA_ALTA, EMP_FECHA_NAC, EMP_PROVINCIA_ID, EMP_PUESTO_ID) VALUES ("Juan", "Perez", "99999990", "1111111112", "Av. 9 de Julio 2222", "2000-10-31", "2020-10-31", 2, 2);
INSERT INTO EMPLEADOS (EMP_NOMBRE, EMP_APELLIDO, EMP_DNI, EMP_TELEFONO, EMP_DIRECCION, EMP_FECHA_ALTA, EMP_FECHA_NAC, EMP_PROVINCIA_ID, EMP_PUESTO_ID) VALUES ("Sandra", "Perez", "99999991", "1111111113", "Av. 9 de Julio 3333", "2000-09-30", "2020-09-30", 3, 3);

-- PROVINCIAS
INSERT INTO PROVINCIAS (PROVINCIA)
	VALUES ('MENDOZA')
    UNION ALL
    VALUES ('CORDOBA')
    UNION ALL
    VALUES ('SANTA CRUZ');

-- PUESTOS
INSERT INTO PUESTOS (PUESTO)
	VALUES ('DATA ENGINEER')
    UNION ALL
    VALUES ('DATA SCIENTIST')
    UNION ALL
    VALUES (3, 'DATA VISUALIZATION');
    
    
-- -----------------------------------
USE empresa;
CREATE TABLE RENDIMIENTOS (
	ID INT AUTO_INCREMENT,
	RENDIMIENTO VARCHAR(10),
	PRIMARY KEY (ID)
);

-- 
ALTER TABLE EMPLEADOS ADD (EMP_SALARIO INT);
ALTER TABLE EMPLEADOS ADD (EMP_RENDIMIENTO_ID INT);
ALTER TABLE EMPLEADOS ADD FOREIGN KEY (EMP_RENDIMIENTO_ID) REFERENCES RENDIMIENTOS (ID);

-- POBLAR TABLAS 
-- RENDIMIENTO
INSERT INTO RENDIMIENTOS (RENDIMIENTO)
	VALUES ('BAJO')
    UNION ALL
    VALUES('MEDIO')
    UNION ALL
    VALUES ('ALTO');

-- EMPLEADOS
UPDATE EMPLEADOS SET EMP_SALARIO = 10000 WHERE EMP_ID > 0;
UPDATE EMPLEADOS SET EMP_RENDIMIENTO_ID = 1 WHERE EMP_ID = 1;
UPDATE EMPLEADOS SET EMP_RENDIMIENTO_ID = 2 WHERE EMP_ID = 2;
UPDATE EMPLEADOS SET EMP_RENDIMIENTO_ID = 3 WHERE EMP_ID = 3;

-- INCREMENTO
UPDATE EMPLEADOS SET EMP_SALARIO =
CASE
	WHEN EMP_RENDIMIENTO_ID = 1 THEN EMP_SALARIO * 0.90 
	WHEN EMP_RENDIMIENTO_ID = 2 THEN EMP_SALARIO * 1.05
    ELSE EMP_SALARIO * 1.10
    END;
    
/*
UPDATE EMPLEADOS SET EMP_APELLIDO = "Gonzalez" WHERE EMP_ID = 2;

UPDATE EMPLEADOS SET EMP_FECHA_ALTA = "2020-12-31" WHERE EMP_ID = 1;
UPDATE EMPLEADOS SET EMP_FECHA_NAC = "2000-12-31" WHERE EMP_ID = 1;

SELECT * FROM EMPLEADOS
WHERE EMP_APELLIDO = "Perez";

DELETE FROM EMPLEADOS WHERE EMP_ID = 3;

*/