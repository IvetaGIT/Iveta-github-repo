-- 1.otázka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
SELECT 
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
    	t.`year`,
		t.average_employees_or_wages AS avg_average_wages,
		t.unit_name,
		t.industry
    FROM t_iveta_kolinska_project_sql_primary_final t 
    WHERE t.value_type_code = 5958
    ) a 
JOIN (
    SELECT DISTINCT 
    	t.`year`,
		t.average_employees_or_wages AS avg_average_wages,
		t.unit_name,
		t.industry
    FROM t_iveta_kolinska_project_sql_primary_final t  
    WHERE t.value_type_code = 5958
    ) b
    ON a.`year` = b.`year` + 1 
	AND a.industry = b.industry
	WHERE a.`year` != '2006'
	ORDER BY growth_index, a.industry;