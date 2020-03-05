SELECT ciclo_estacion_retiro AS station_begin, ciclo_estacion_arribo AS station_end, 
	COUNT(*) AS tot, 
AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS triptime FROM ecobicidf WHERE(ciclo_estacion_retiro<>ciclo_estacion_arribo) GROUP BY 1,2 ORDER BY tot DESC LIMIT 10;

	COUNT(*) AS tot, 
    SUM(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS tot, 
    SUM(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN (hora_retiro>='00:00:00' AND hora_retiro<'06:00:00') THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN (hora_retiro>='06:00:00' AND hora_retiro<'12:00:00') THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN (hora_retiro>='12:00:00' AND hora_retiro<'18:00:00') THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN (hora_retiro>='18:00:00') THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:00:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:10:00' THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:10:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:20:00' THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:20:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:30:00' THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:30:00' THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN edad_usuario BETWEEN 0 AND 25 THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN edad_usuario BETWEEN 26 AND 35 THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN edad_usuario BETWEEN 36 AND 45 THEN 1 ELSE 0 END) AS tot, 
	SUM(CASE WHEN edad_usuario>=46 THEN 1 ELSE 0 END) AS tot, 


WITH sub AS(SELECT fecha_retiro, 
    SUM(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS tot_fem,
    SUM(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS tot_masc
FROM ecobicidf GROUP BY(fecha_retiro)) SELECT EXTRACT(YEAR FROM fecha_retiro) AS ddate, 
	AVG(tot_fem) AS tot_fem,
	AVG(tot_masc) AS tot_masc,
FROM sub GROUP BY EXTRACT(YEAR FROM fecha_retiro);

--YEARLY
SELECT EXTRACT(YEAR FROM fecha_retiro) as ddate, 
    SUM(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS tot_fem,
    SUM(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS tot_masc,
    100*AVG(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS pct_fem,
    100*AVG(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS pct_masc,
	AVG(CASE WHEN genero_usuario = 'F' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_fem,
	AVG(CASE WHEN genero_usuario = 'M' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_masc,
	AVG(CASE WHEN genero_usuario = 'F' THEN edad_usuario ELSE NULL END) AS age_fem,
	AVG(CASE WHEN genero_usuario = 'M' THEN edad_usuario ELSE NULL END) AS age_masc
FROM ecobicidf GROUP BY EXTRACT(YEAR FROM fecha_retiro);






WITH sub AS(SELECT fecha_retiro, 
			 COUNT(*) AS tot 
FROM ecobicidf GROUP BY(fecha_retiro)) SELECT EXTRACT(YEAR FROM fecha_retiro) AS ddate, 
AVG(tot) AS tot 
FROM sub GROUP BY EXTRACT(YEAR FROM fecha_retiro);


WITH sub AS(SELECT fecha_retiro, 
			 COUNT(*) AS tot 
FROM ecobicidf GROUP BY(fecha_retiro)) SELECT TO_CHAR(fecha_retiro,'Dy') AS ddate, 
AVG(tot) AS tot, TO_CHAR(fecha_retiro, 'D') AS junk 
FROM sub GROUP BY(TO_CHAR(fecha_retiro,'Dy'),TO_CHAR(fecha_retiro,'D')) ORDER BY junk;


WITH sub AS(SELECT fecha_retiro, 
			 COUNT(*) AS tot 
FROM ecobicidf GROUP BY(fecha_retiro)) SELECT TO_CHAR(fecha_retiro,'Mon') AS ddate, 
AVG(tot) AS tot, TO_CHAR(fecha_retiro, 'MM') AS junk 
FROM sub GROUP BY(TO_CHAR(fecha_retiro,'MM'), TO_CHAR(fecha_retiro,'Mon')) ORDER BY junk;




SELECT COUNT(*) FROM ecobicidf;

--YEARLY
SELECT EXTRACT(YEAR FROM fecha_retiro) AS ddate, COUNT(*) FROM ecobicidf GROUP BY(EXTRACT(YEAR FROM fecha_retiro));

--YEARLY
SELECT EXTRACT(YEAR FROM fecha_retiro) as ddate, 
    SUM(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS tot_fem,
    SUM(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS tot_masc,
    100*AVG(CASE WHEN genero_usuario = 'F' THEN 1 ELSE 0 END) AS pct_fem,
    100*AVG(CASE WHEN genero_usuario = 'M' THEN 1 ELSE 0 END) AS pct_masc,
	AVG(CASE WHEN genero_usuario = 'F' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_fem,
	AVG(CASE WHEN genero_usuario = 'M' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_masc,
	AVG(CASE WHEN genero_usuario = 'F' THEN edad_usuario ELSE NULL END) AS age_fem,
	AVG(CASE WHEN genero_usuario = 'M' THEN edad_usuario ELSE NULL END) AS age_masc
FROM ecobicidf GROUP BY EXTRACT(YEAR FROM fecha_retiro);

--YEARLY
SELECT EXTRACT(YEAR FROM fecha_retiro) as ddate,
	SUM(CASE WHEN (hora_retiro>='00:00:00' AND hora_retiro<'06:00:00') THEN 1 ELSE 0 END) AS tot_beg,
	SUM(CASE WHEN (hora_retiro>='06:00:00' AND hora_retiro<'12:00:00') THEN 1 ELSE 0 END) AS tot_mor,
	SUM(CASE WHEN (hora_retiro>='12:00:00' AND hora_retiro<'18:00:00') THEN 1 ELSE 0 END) AS tot_aft,
	SUM(CASE WHEN (hora_retiro>='18:00:00') THEN 1 ELSE 0 END) AS tot_eve,
	100*AVG(CASE WHEN (hora_retiro>='00:00:00' AND hora_retiro<'06:00:00') THEN 1 ELSE 0 END) AS pct_beg,
	100*AVG(CASE WHEN (hora_retiro>='06:00:00' AND hora_retiro<'12:00:00') THEN 1 ELSE 0 END) AS pct_mor,
	100*AVG(CASE WHEN (hora_retiro>='12:00:00' AND hora_retiro<'18:00:00') THEN 1 ELSE 0 END) AS pct_aft,
	100*AVG(CASE WHEN (hora_retiro>='18:00:00') THEN 1 ELSE 0 END) AS pct_eve,
	AVG(CASE WHEN (hora_retiro>='00:00:00' AND hora_retiro<'06:00:00') THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_beg,
	AVG(CASE WHEN (hora_retiro>='06:00:00' AND hora_retiro<'12:00:00') THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_mor,
	AVG(CASE WHEN (hora_retiro>='12:00:00' AND hora_retiro<'18:00:00') THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_aft,
	AVG(CASE WHEN (hora_retiro>='18:00:00') THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_eve,
	AVG(CASE WHEN (hora_retiro>='00:00:00' AND hora_retiro<'06:00:00') THEN edad_usuario ELSE NULL END) AS age_beg,
	AVG(CASE WHEN (hora_retiro>='06:00:00' AND hora_retiro<'12:00:00') THEN edad_usuario ELSE NULL END) AS age_mor,
	AVG(CASE WHEN (hora_retiro>='12:00:00' AND hora_retiro<'18:00:00') THEN edad_usuario ELSE NULL END) AS age_aft,
	AVG(CASE WHEN (hora_retiro>='18:00:00') THEN edad_usuario ELSE NULL END) AS age_eve
FROM ecobicidf GROUP BY EXTRACT(YEAR FROM fecha_retiro);

SELECT EXTRACT(YEAR FROM fecha_retiro) as ddate,
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:00:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:10:00' THEN 1 ELSE 0 END) AS tot_zeroten,
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:10:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:20:00' THEN 1 ELSE 0 END) AS tot_tentwenty,
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:20:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:30:00' THEN 1 ELSE 0 END) AS tot_tewntythirty,
	SUM(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:30:00' THEN 1 ELSE 0 END) AS tot_thritymore,
	100*AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:00:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:10:00' THEN 1 ELSE 0 END) AS pct_zeroten,
	100*AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:10:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:20:00' THEN 1 ELSE 0 END) AS pct_tentwenty,
	100*AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:20:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:30:00' THEN 1 ELSE 0 END) AS pct_tewntythirty,
	100*AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:30:00' THEN 1 ELSE 0 END) AS pct_thritymore,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:00:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:10:00' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_zeroten,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:10:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:20:00' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_tentwenty,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:20:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:30:00' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_tewntythirty,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:30:00' THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_thritymore,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:00:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:10:00' THEN edad_usuario ELSE NULL END) AS age_zeroten,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:10:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:20:00' THEN edad_usuario ELSE NULL END) AS age_tentwenty,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:20:00' AND ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:30:00' THEN edad_usuario ELSE NULL END) AS age_tewntythirty,
	AVG(CASE WHEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>='00:30:00' THEN edad_usuario ELSE NULL END) AS age_thritymore
FROM ecobicidf GROUP BY EXTRACT(YEAR FROM fecha_retiro);


--YEARLY
SELECT EXTRACT(YEAR FROM fecha_retiro) as ddate,
	SUM(CASE WHEN edad_usuario BETWEEN 0 AND 25 THEN 1 ELSE 0 END) AS tot_you,
	SUM(CASE WHEN edad_usuario BETWEEN 26 AND 35 THEN 1 ELSE 0 END) AS tot_mid,
	SUM(CASE WHEN edad_usuario BETWEEN 36 AND 45 THEN 1 ELSE 0 END) AS tot_old,
	SUM(CASE WHEN edad_usuario>=46 THEN 1 ELSE 0 END) AS tot_eld,
	100*AVG(CASE WHEN edad_usuario BETWEEN 0 AND 25 THEN 1 ELSE 0 END) AS pct_you,
	100*AVG(CASE WHEN edad_usuario BETWEEN 26 AND 35 THEN 1 ELSE 0 END) AS pct_mid,
	100*AVG(CASE WHEN edad_usuario BETWEEN 36 AND 45 THEN 1 ELSE 0 END) AS pct_old,
	100*AVG(CASE WHEN edad_usuario>=46 THEN 1 ELSE 0 END) AS pct_eld,
	AVG(CASE WHEN edad_usuario BETWEEN 0 AND 25 THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_you,
	AVG(CASE WHEN edad_usuario BETWEEN 26 AND 35 THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_mid,
	AVG(CASE WHEN edad_usuario BETWEEN 36 AND 45 THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_old,
	AVG(CASE WHEN edad_usuario>=46 THEN ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) ELSE NULL END) AS time_eld,
	AVG(CASE WHEN edad_usuario BETWEEN 0 AND 25 THEN edad_usuario ELSE NULL END) AS age_you,
	AVG(CASE WHEN edad_usuario BETWEEN 26 AND 35 THEN edad_usuario ELSE NULL END) AS age_mid,
	AVG(CASE WHEN edad_usuario BETWEEN 36 AND 45 THEN edad_usuario ELSE NULL END) AS age_old,
	AVG(CASE WHEN edad_usuario>=46 THEN edad_usuario ELSE NULL END) AS age_eld
FROM ecobicidf GROUP BY EXTRACT(YEAR FROM fecha_retiro);



--DAILY
SELECT fecha_retiro AS ddate,

GROUP BY(fecha_retiro) ORDER BY(fecha_retiro);


--
SELECT
	EXTRACT(YEAR FROM fecha_retiro),
	(SELECT EXTRACT(YEAR FROM fecha_retiro), COUNT(*) FROM ecobicidf WHERE genero_usuario='F' GROUP BY(EXTRACT(YEAR FROM fecha_retiro))) AS femenino,
	(SELECT EXTRACT(YEAR FROM fecha_retiro), COUNT(*) FROM ecobicidf WHERE genero_usuario='M' GROUP BY(EXTRACT(YEAR FROM fecha_retiro))) AS masculino,
	COUNT(*)
	FROM ecobicidf GROUP BY(EXTRACT(YEAR FROM fecha_retiro));

SELECT fecha_retiro, t.cate AS category, COUNT(*)
FROM (
  SELECT fecha_retiro, CASE
    WHEN genero_usuario='M' THEN 'M'
    WHEN genero_usuario='F' THEN 'F'
	END AS cate
  FROM ecobicidf) t
GROUP BY t.cate, fecha_retiro;


--
SELECT fecha_retiro, hora_retiro, fecha_arribo, hora_arribo, ((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS lapse FROM ecobicidf ORDER BY lapse DESC;

--
with mes as
(select genero_usuario, 
 mes_retiro, 
 count(genero_usuario) as numero_usuarios, 
 avg(edad_usuario) as edad_promedio, 
 AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime
 
 from ecobicidf
 
 where anio_retiro in (2017)
 group by 1,2
)

select genero_usuario,  
 sum(numero_usuarios) as numero_usuarios, 
 avg(edad_promedio) as avg_edad, 
 AVG(avgtime) AS avg_time,
 avg(numero_usuarios) as avg_usuarios

 from mes
 group by 1

SELECT genero_usuario, COUNT(*), AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime, AVG(edad_usuario) AS age FROM ecobicidf GROUP BY(genero_usuario);

select * from ecobicidf limit 10



--YEARLY
SELECT EXTRACT(YEAR FROM fecha_retiro) AS ddate, COUNT(*), AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime FROM ecobicidf WHERE(fecha_retiro IS NOT NULL ) GROUP BY(EXTRACT (YEAR FROM fecha_retiro)) ORDER BY (EXTRACT (YEAR FROM fecha_retiro));

--MONTHLY
SELECT TO_CHAR(DATE_TRUNC('month',fecha_retiro)::DATE,'Mon-YYYY') AS ddate, COUNT(*), AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime FROM ecobicidf WHERE(fecha_retiro IS NOT NULL) GROUP BY(DATE_TRUNC('month',fecha_retiro)::date ) ORDER BY (DATE_TRUNC('month',fecha_retiro)::DATE);

--DAILY
SELECT fecha_retiro AS ddate, COUNT(*), AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime FROM ecobicidf WHERE(fecha_retiro IS NOT NULL) GROUP BY(fecha_retiro) ORDER BY(fecha_retiro);

--BY DAY OF WEEK
SELECT TO_CHAR(fecha_retiro,'Dy') AS ddate, COUNT(*), AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime, TO_CHAR(fecha_retiro, 'D') AS junk FROM ecobicidf WHERE(fecha_retiro IS NOT NULL) GROUP BY(TO_CHAR(fecha_retiro,'Dy'),TO_CHAR(fecha_retiro,'D')) ORDER BY 4;

--BY MONTH
SELECT TO_CHAR(fecha_retiro,'Mon') AS ddate, COUNT(*), AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) AS avgtime, TO_CHAR(fecha_retiro, 'MM') AS junk FROM ecobicidf WHERE(fecha_retiro IS NOT NULL) GROUP BY(TO_CHAR(fecha_retiro,'MM'), TO_CHAR(fecha_retiro,'Mon')) ORDER BY 4;



----TODO LO DEMAS ESTA SUCIO






SELECT to_char(fecha_retiro,'Dy') as ddate, COUNT(*) FROM ecobicidf WHERE(fecha_retiro IS NOT NULL AND (genero_usuario='M') AND (edad_usuario>=26 AND edad_usuario<=35) AND (hora_retiro>='06:00:00' AND hora_retiro<='11:59:59')) GROUP BY(EXTRACT(DOW FROM fecha_retiro));



SELECT EXTRACT(YEAR, MONTH FROM fecha_retiro) as ddate, COUNT(*) FROM ecobicidf WHERE(fecha_retiro IS NOT NULL AND (genero_usuario='M') AND (edad_usuario>=26 AND edad_usuario<=35) AND (hora_retiro>='06:00:00' AND hora_retiro<='11:59:59')) GROUP BY(EXTRACT (YEAR, MONTH FROM fecha_retiro));

SELECT (EXTRACT(YEAR FROM fecha_retiro)+EXTRACT(MONTH FROM fecha_retiro)) as ddate, COUNT(*) FROM ecobicidf WHERE(fecha_retiro IS NOT NULL AND (genero_usuario='M') AND (edad_usuario>=26 AND edad_usuario<=35) AND (hora_retiro>='06:00:00' AND hora_retiro<='11:59:59')) GROUP BY((EXTRACT(YEAR FROM fecha_retiro)+EXTRACT(MONTH FROM fecha_retiro)));

SELECT genero_usuario, COUNT(*) FROM ecobicidf GROUP BY(genero_usuario);

SELECT COUNT(*) FROM ecobicidf WHERE(fecha_retiro IS NOT NULL);

Select ciclo_estacion_retiro, ciclo_estacion_arribo, count(genero_usuario) as count, avg((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) as average from ecobicidf where (average>='00:10:00') group by 1,2 order by count desc limit 10;

SELECT anio_retiro, mes_retiro, COUNT(*) FROM ecobicidf GROUP BY (anio_retiro, mes_retiro) ORDER BY anio_retiro, mes_retiro;

SELECT AVG((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) FROM ecobicidf WHERE (hora_retiro>='23:50:00') GROUP BY (EXTRACT (MONTH FROM fecha_retiro))  ;

SELECT AVG((hora_arribo)-(hora_retiro)) FROM ecobicidf WHERE (hora_retiro>='23:50:00') GROUP BY (EXTRACT (MONTH FROM fecha_retiro))  ;

SELECT (fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro), (hora_arribo)-(hora_retiro), fecha_retiro, hora_retiro, fecha_arribo, hora_arribo FROM ecobicidf WHERE (hora_retiro>='23:50:00') LIMIT 10  ;
SELECT* FROM ecobicidf LIMIT 10;
--Some queries we might use for graph creation

--Checking date and time variables work
SELECT MAX(fecha_arribo) FROM ecobicidf;
SELECT MIN(fecha_arribo) FROM ecobicidf;

SELECT MIN(fecha_retiro) FROM ecobicidf;
SELECT MAX(fecha_retiro) FROM ecobicidf;

SELECT MIN(hora_arribo) FROM ecobicidf;
SELECT MAX(hora_arribo) FROM ecobicidf;

SELECT MIN(hora_retiro) FROM ecobicidf;
SELECT MAX(hora_retiro) FROM ecobicidf;

--All observations
SELECT COUNT(*) FROM ecobicidf;

-- Count by gender
SELECT genero_usuario, COUNT(*) FROM ecobicidf GROUP BY genero_usuario;

-- Count total trips in 2015
SELECT COUNT(*) FROM ecobicidf WHERE EXTRACT(YEAR FROM fecha_retiro)=2015;

--Calculating average time of a trip
SELECT AVG(TIMEDIFF())


SELECT EXTRACT(MONTH FROM fecha_retiro), COUNT(*) FROM ecobicidf WHERE EXTRACT(DAY FROM fecha_retiro)=2010;

SELECT * FROM ecobicidf LIMIT 5;


DELETE FROM ecobicidf WHERE edad_usuario<15;
DELETE FROM ecobicidf WHERE edad_usuario>85;
DELETE FROM ecobicidf WHERE genero_usuario IS NULL;

DELETE FROM ecobicidf WHERE (((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro)) IS NULL);
DELETE FROM ecobicidf WHERE (((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))>'02:00:00');
DELETE FROM ecobicidf WHERE (((fecha_arribo+hora_arribo)-(fecha_retiro+hora_retiro))<'00:00:00');



DELETE FROM ecobicidf WHERE anio_retiro=2019 and mes_retiro=3;