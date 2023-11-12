-- MEDIDAS

CREATE OR REPLACE VIEW ventas_totales AS
SELECT
	SUM(MONTO) AS MONTO_TOTAL
FROM
	ventas
;

CREATE OR REPLACE VIEW prod_cant_venta AS
SELECT
	PRODUCTO_ID,
	SUM(CANTIDAD) AS CANTIDAD
FROM
	ventas
GROUP BY
	PRODUCTO_ID
;

CREATE OR REPLACE VIEW avg_transaccion_venta AS
SELECT
	AVG(MONTO) AS PROMEDIO
FROM
	ventas
;

CREATE OR REPLACE VIEW avg_transaccion_venta AS
SELECT
	AVG(MONTO) AS PROMEDIO
FROM
	ventas
