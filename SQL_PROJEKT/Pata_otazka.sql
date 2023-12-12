/*
 * 5.otázka: Má výška HDP vliv na změny ve mzdách a cenách potravin? 
 * Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */ 

WITH T1 AS (
    SELECT 
	a.`year`,
	b.`year` AS prev_year,
	ROUND((a.avg_wages_per_year - b.avg_wages_per_year) / b.avg_wages_per_year * 100, 2) AS avg_wages_growth,
	ROUND((a.avg_price_per_year - b.avg_price_per_year) / b.avg_price_per_year * 100, 2) AS avg_price_growth
FROM (
	SELECT
		t.`year`,
		ROUND(AVG(t.average_employees_or_wages), 2) AS avg_wages_per_year,
		ROUND(AVG(t.avg_price), 2) AS avg_price_per_year
	FROM t_iveta_kolinska_project_sql_primary_final t
	WHERE t.value_type_code = 5958
	GROUP BY t.`year`
	) a 
JOIN (
	SELECT
		t.`year`,
		ROUND(AVG(t.average_employees_or_wages), 2) AS avg_wages_per_year,
		ROUND(AVG(t.avg_price), 2) AS avg_price_per_year
	FROM t_iveta_kolinska_project_sql_primary_final t
	WHERE t.value_type_code = 5958
	GROUP BY t.`year`
	) b 
	ON a.`year` = b.`year` + 1
),
T2 AS (
    SELECT 
	c.`year`,
	d.`year`AS prev_year,
	ROUND((c.GDP_mil_dollars - d.GDP_mil_dollars) / d.GDP_mil_dollars * 100, 2) AS GDP_growth
FROM ( 
	SELECT 
		t2.`year`,
		t2.GDP_mil_dollars 
	FROM t_iveta_kolinska_project_sql_secondary_final t2 
	WHERE country = 'Czech Republic') c
JOIN ( 
	SELECT 
		t2.`year`,
		t2.GDP_mil_dollars 
	FROM t_iveta_kolinska_project_sql_secondary_final t2 
	WHERE country = 'Czech Republic') d
	ON c.`year` = d.`year` + 1
)
SELECT T1.`year`, T1.prev_year, avg_wages_growth, avg_price_growth, GDP_growth
FROM T1
LEFT JOIN T2 ON T1.`year` = T2.`year`
ORDER BY T1.`year`;