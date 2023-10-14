# my-github-repo

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


-- 1.otazka: Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

SELECT 
	t.`year`,
	t2.`year` AS year_prev,
	t.unit_name,
	t.industry,
	round((t.average_wages - t2.average_wages) / t2.average_wages * 100, 2) AS avg_wages_growth
FROM t_iveta_kolinska_project_sql_primary_final t 
JOIN t_iveta_kolinska_project_sql_primary_final t2 
	ON t.`year` = t2.`year` + 1
WHERE t.average_wages IS NOT NULL
GROUP BY t.industry;



-- POMOC: Z tabulky economies spočítejte meziroční procentní nárůst populace a procentní nárůst HDP pro každou zemi.
SELECT e.country, e.year, e2.year + 1 as year_prev, 
    round( ( e.GDP - e2.GDP ) / e2.GDP * 100, 2 ) as GDP_growth,
    round( ( e.population - e2.population ) / e2.population * 100, 2) as pop_growth_percent
FROM economies e 
JOIN economies e2 
    ON e.country = e2.country 
    AND e.year = e2.year + 1
    AND e.year < 2020
    
   
  
    
   

