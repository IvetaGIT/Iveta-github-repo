-- 1.otázka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT distinct 
	a.`year`,
	b.`year` AS year_prev,
	CASE
		WHEN ((a.avg_average_wages - b.avg_average_wages) > 0) THEN 1 
		ELSE 0
	END AS growth_index,
	a.avg_average_wages,
	b.avg_average_wages AS prev_avg_average_wages,
	a.unit_name,
	a.industry
FROM (
	SELECT DISTINCT  
		`year`,
    	ROUND(AVG(average_employees_or_wages), 2) AS avg_average_wages,
		unit_name,
		industry
	FROM t_iveta_kolinska_project_sql_primary_final t 
	WHERE value_type_code = 5958
	GROUP BY `year`, industry
	) a
LEFT JOIN (
	SELECT DISTINCT  
		`year`,
    	ROUND(AVG(average_employees_or_wages), 2) AS avg_average_wages,
		unit_name,
		industry
	FROM t_iveta_kolinska_project_sql_primary_final t 
	WHERE value_type_code = 5958
	GROUP BY `year`, industry
	) b
		ON a.`year` = b.`year` + 1 
		AND a.industry = b.industry
WHERE a.`year` != '2006';