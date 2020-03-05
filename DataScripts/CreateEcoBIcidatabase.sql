--This SQL script creates the database of EcoBici trips
--DROP TABLE ecobicidf;

CREATE TABLE ecobicidf (
	ID SERIAL PRIMARY KEY,
	Genero_Usuario VARCHAR,
	Edad_Usuario INT,
	Bici VARCHAR,
	Ciclo_Estacion_Retiro INT,
	Fecha_Retiro DATE,
	Mes_Retiro INT,
	Anio_Retiro INT,
	Hora_Retiro TIME,
	Ciclo_Estacion_Arribo INT,
	Fecha_Arribo DATE,
	Hora_Arribo TIME
);

DELETE FROM ecobicidf WHERE edad_usuario<15;
DELETE FROM ecobicidf WHERE edad_usuario>85;
DELETE FROM ecobicidf WHERE genero_usuario IS NULL;

DELETE FROM ecobicidf WHERE (((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) IS NULL);
DELETE FROM ecobicidf WHERE (((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>'02:00:00');
DELETE FROM ecobicidf WHERE (((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:00:00');