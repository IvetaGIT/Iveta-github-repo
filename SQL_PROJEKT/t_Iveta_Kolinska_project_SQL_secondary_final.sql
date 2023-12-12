-- 2.TABULKA

CREATE TABLE IF NOT EXISTS t_Iveta_Kolinska_project_SQL_secondary_final AS
SELECT
	c.country,
	c.capital_city,
	c.region_in_world,
	c.population,
	c.currency_name,
	c.currency_code,
	e.`year`,
	ROUND( e.GDP / 1000000, 2 ) AS GDP_mil_dollars,
	e.gini,
	e.taxes 
FROM countries c 
LEFT JOIN economies e 
	ON c.country = e.country 
WHERE c.continent = 'Europe'
AND e.`year` >= 2006 AND e.`year` <= 2018;
   

SELECT *
FROM t_Iveta_Kolinska_project_SQL_secondary_final;