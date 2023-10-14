-- 2.otázka: Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	`year`,
	round(avg(average_employees_or_wages), 2) AS avg_wages,
	round(avg(avg_price), 2) AS avg_price_II,
	round(avg(average_employees_or_wages) / avg(avg_price), 0) AS how_many_possible_to_buy,
	category_code,
	food_category,
	price_value,
	price_unit 
FROM t_iveta_kolinska_project_sql_primary_final tikpspf 
WHERE category_code IN ('114201', '111301')
	AND `year` IN ('2006', '2018')
	AND value_type_code = 5958
GROUP BY food_category, `year`
ORDER BY food_category;