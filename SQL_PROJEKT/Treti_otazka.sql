-- 3. otázka: Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH year_on_year_avg_price_growth AS (
	SELECT 
		ROUND((a.avg_price_per_year - b.avg_price_per_year) / b.avg_price_per_year * 100, 2) AS avg_price_growth,
		a.food_category
	FROM (
		SELECT
			t.`year`,
			ROUND(AVG(t.avg_price), 2) AS avg_price_per_year,
			t.category_code,
			t.food_category
		FROM t_iveta_kolinska_project_sql_primary_final t
		GROUP BY t.`year`, t.food_category
		) a 
	JOIN (
		SELECT
			t.`year`,
			ROUND(AVG(t.avg_price), 2) AS avg_price_per_year,
			t.category_code,
			t.food_category
		FROM t_iveta_kolinska_project_sql_primary_final t
		GROUP BY t.`year`, t.food_category
		) b 
		ON a.category_code = b.category_code
		AND a.`year` = b.`year` + 1
	ORDER BY a.food_category)
SELECT 
	ROUND(AVG(avg_price_growth), 2) AS AVG_avg_price_growth_pct,
	food_category
FROM year_on_year_avg_price_growth
GROUP BY food_category
ORDER BY AVG(avg_price_growth)
LIMIT 1;