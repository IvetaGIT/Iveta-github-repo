-- TABULKA 1

CREATE TABLE IF NOT EXISTS t_iveta_kolinska_project_sql_primary_final AS 
SELECT  
		a.avg_price,
		a.category_code,
		a.food_category,
		a.price_value,
		a.price_unit,
		a.`year`,
		a.region_code,
		a.region_name,
		b.average_employees_or_wages,
		b.value_type_code,
		b.unit_code,
		b.unit_name,
		b.calculation_code,
		b.calculation_name,
		b.industry_branch_code,
		b.industry
FROM (
	SELECT
		round(avg(cp.value), 2) AS avg_price,
		cp.category_code,
		cpc.name AS food_category,
		cpc.price_value,
		cpc.price_unit,
		YEAR(cp.date_from) AS `year`,
		cp.region_code,
		cr.name AS region_name
	FROM czechia_price cp
	LEFT JOIN czechia_price_category cpc ON cp.category_code = cpc.code
	LEFT JOIN czechia_region cr ON cp.region_code = cr.code
	WHERE region_code IS NOT null
	GROUP BY YEAR(date_from), region_code, category_code
	) a
LEFT JOIN (
	SELECT
		round(avg(cpay.value), 2) AS average_employees_or_wages,
		cpay.value_type_code,
		cpay.unit_code,
		cpu.name AS unit_name,
		cpay.calculation_code,
		cpcal.name AS calculation_name,
		cpay.industry_branch_code,
		cpib.name AS industry,
		cpay.payroll_year AS `year`
	FROM czechia_payroll cpay
	LEFT JOIN czechia_payroll_calculation cpcal ON cpay.calculation_code = cpcal.code
	LEFT JOIN czechia_payroll_industry_branch cpib ON cpay.industry_branch_code = cpib.code
	LEFT JOIN czechia_payroll_unit cpu ON cpay.unit_code = cpu.code
	WHERE cpay.value IS NOT NULL AND cpay.industry_branch_code IS NOT NULL
	GROUP BY `year`, industry, cpay.value_type_code
	) b
		ON a.`year` = b.`year`
	ORDER BY a.`year`;

  
   
 SELECT *
 FROM t_iveta_kolinska_project_sql_primary_final;