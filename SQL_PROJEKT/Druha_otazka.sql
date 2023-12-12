-- 2.otázka: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	`year`,
	ROUND(AVG(average_employees_or_wages), 2) AS avg_wages,
	ROUND(AVG(avg_price), 2) AS AVG_avg_food_price,
	ROUND(AVG(average_employees_or_wages) / AVG(avg_price), 0) AS how_many_possible_to_buy,
	food_category,
	price_value,
	price_unit 
FROM t_iveta_kolinska_project_sql_primary_final  
WHERE category_code IN ('114201', '111301')
	AND `year` IN ('2006', '2018')
	AND value_type_code = 5958
GROUP BY food_category, `year`
ORDER BY food_category;