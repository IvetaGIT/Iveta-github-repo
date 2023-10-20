# Iveta-github-repo

-- PROJEKT

-- TVORBA TABULKY 1

-- za jaké období je tabulka czechia_price
SELECT 	
	DISTINCT YEAR (date_from),
	YEAR (date_to)
FROM czechia_price cp
ORDER BY YEAR (date_from);

-- za jaké období je tabulka czechia_payroll
SELECT 	
	DISTINCT payroll_year
FROM czechia_payroll cp 
ORDER BY payroll_year;

-- value = průměrná hrubá mzda na zaměstnance
SELECT *
FROM czechia_payroll cp 
WHERE value_type_code = 5958;

-- value = průměrný počet zaměstnanýcho osob
SELECT *
FROM czechia_payroll cp 
WHERE value_type_code = 316;

-- spojení tabulek payroll
SELECT 
	cpay.value AS average_employees_or_wages,
	cpay.unit_code,
	cpu.name,
	cpay.calculation_code,
	cpc.name,
	cpay.industry_branch_code,
	cpib.name,
	cpay.payroll_year
FROM czechia_payroll cpay 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cpay.calculation_code = cpc.code 
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cpay.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_unit cpu 
	ON cpay.unit_code = cpu.code 
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cpay.value_type_code = cpvt.code;


-- spojení tabulek price
SELECT 
	cp.value AS price,
	YEAR (cp.date_from) AS price_measured_from,
	YEAR (cp.date_to) AS price_measured_to,
	cp.category_code,
	cpc.name AS food_category,
	cpc.price_value,
	cpc.price_unit,
	cp.region_code,
	cr.name AS region_name
FROM czechia_price cp
LEFT JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code 
LEFT JOIN czechia_region cr 
	ON cp.region_code = cr.code;


-- jak rozdelit sloupec value
SELECT
    CASE
        WHEN value_type_code = 316 THEN value
        ELSE NULL
    END AS average_employees,
    CASE
        WHEN value_type_code = 5958 THEN value
        ELSE NULL
    END AS average_wages
FROM czechia_payroll cp;
 

-- tvorba WITH
SELECT 
		round(avg(value), 2) AS avg_price,
		category_code,
		YEAR (date_from) AS `year`, 
		region_code
	FROM czechia_price cp 
	GROUP BY YEAR (date_from), region_code, category_code
	ORDER BY YEAR (date_from), category_code;

   
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
   

-- 2.TABULKA

-- CREATE TABLE IF NOT EXISTS t_Iveta_Kolinska_project_SQL_secondary_final AS
SELECT
	c.country,
	c.capital_city,
	c.region_in_world,
	c.population,
	c.currency_name,
	c.currency_code,
	e.`year`,
	round( e.GDP / 1000000, 2 ) as GDP_mil_dollars,
	e.gini,
	e.taxes 
FROM countries c 
LEFT JOIN economies e 
	ON c.country = e.country 
WHERE c.continent = 'Europe'
AND e.`year` >= 2006 AND e.`year` <= 2018;
   

SELECT *
FROM t_Iveta_Kolinska_project_SQL_secondary_final;


-- 1.otázka (nove reseni): Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
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


-- 2.otázka (nové řešení): Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

SELECT 
	`year`,
	round(avg(average_employees_or_wages), 2) AS avg_wages,
	round(avg(avg_price), 2) AS avg_price_II,
	round(avg(average_employees_or_wages) / avg(avg_price), 0) AS how_many_possible_to_buy,
	category_code,
	food_category,
	price_value,
	price_unit 
FROM t_iveta_kolinska_project_sql_primary_final  
WHERE category_code IN ('114201', '111301')
	AND `year` IN ('2006', '2018')
	AND value_type_code = 5958
GROUP BY food_category, `year`
ORDER BY food_category;
    
   
  
    
   

