-- 4. otázka: Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

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
WHERE (ROUND((a.avg_price_per_year - b.avg_price_per_year) / b.avg_price_per_year * 100, 2)) - (ROUND((a.avg_wages_per_year - b.avg_wages_per_year) / b.avg_wages_per_year * 100, 2)) >= 10;
