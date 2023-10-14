-- TABULKA 1

CREATE TABLE IF NOT EXISTS t_Iveta_Kolinska_project_SQL_primary_final AS   
WITH czechia_price_avg AS (
	SELECT
		ROUND(AVG(value), 2) AS avg_price,
		category_code,
		YEAR(date_from) AS year,
		region_code
	FROM czechia_price cp
	GROUP BY YEAR(date_from), region_code, category_code
),
czechia_payroll_join AS (
	SELECT
	cpay.value AS average_employees_or_wages,
	cpay.value_type_code,
		cpay.unit_code,
		cpu.name AS unit_name,
		cpay.calculation_code,
		cpcal.name AS calculation_name,
		cpay.industry_branch_code,
		cpib.name AS industry,
		cpay.payroll_year AS `year`,
		cpa.avg_price,
		cpa.category_code,
		cpc.name AS food_category,
		cpc.price_value,
		cpc.price_unit,
		cpa.region_code,
		cr.name AS region_name
	FROM czechia_payroll cpay
	LEFT JOIN czechia_price_avg cpa ON cpay.payroll_year = cpa.`year`
	LEFT JOIN czechia_price_category cpc ON cpa.category_code = cpc.code
	LEFT JOIN czechia_region cr ON cpa.region_code = cr.code
	LEFT JOIN czechia_payroll_calculation cpcal ON cpay.calculation_code = cpcal.code
	LEFT JOIN czechia_payroll_industry_branch cpib ON cpay.industry_branch_code = cpib.code
	LEFT JOIN czechia_payroll_unit cpu ON cpay.unit_code = cpu.code
	WHERE cpay.value IS NOT NULL
)
SELECT * FROM czechia_payroll_join WHERE region_code IS NOT null;
  
   
 SELECT *
 FROM t_iveta_kolinska_project_sql_primary_final;