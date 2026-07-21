

-- Creating database and selecting it for use
CREATE DATABASE financial_data;
USE financial_data;

-- Main table storing yearly financial data of pharma companies
-- Includes revenue, margins, R&D spend, and pipeline size by country/segment
CREATE TABLE pharma_data (
    year INT,
    company_name VARCHAR(100),
    ticker VARCHAR(10),
    country_iso3 CHAR(3),
    segment VARCHAR(50),
    revenue_usd_bn DECIMAL(10,2),
    operating_margin_pct DECIMAL(5,2),
    operating_income_usd_bn DECIMAL(10,2),
    rd_spend_usd_bn DECIMAL(10,2),
    pipeline_size_est INT
);

-- Query 1: Basic filter + sort
-- Shows all companies' revenue and margin for the year 2026, sorted highest revenue first
SELECT company_name, revenue_usd_bn, operating_margin_pct
FROM pharma_data
WHERE year = 2026
ORDER BY revenue_usd_bn DESC;

-- Query 2: Aggregation (GROUP BY)
-- Finds the top 5 companies by total revenue in 2026
SELECT company_name, SUM(revenue_usd_bn) AS total_revenue
FROM pharma_data
WHERE year = 2026
GROUP BY company_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Query 3: Growth calculation using MAX/MIN
-- Calculates % growth for each company by comparing its highest vs lowest revenue year on record
SELECT company_name,
       (MAX(revenue_usd_bn) - MIN(revenue_usd_bn)) / MIN(revenue_usd_bn) * 100 AS growth_pct
FROM pharma_data
GROUP BY company_name
ORDER BY growth_pct DESC
LIMIT 5;

-- Query 4: CTE + Window Function (RANK)
-- Ranks companies by revenue within each year, then picks only the top 3 per year
WITH ranked_revenue AS (
    SELECT company_name, year, revenue_usd_bn,
           RANK() OVER (PARTITION BY year ORDER BY revenue_usd_bn DESC) AS rev_rank
    FROM pharma_data
)
SELECT *
FROM ranked_revenue
WHERE rev_rank <= 3;

-- Secondary table storing R&D pipeline size (separate from main financial data)
-- Used later to demonstrate JOIN across two tables
CREATE TABLE pipeline_data (
    company_name VARCHAR(100),
    year INT,
    pipeline_size_est INT
);

INSERT INTO pipeline_data (company_name, year, pipeline_size_est)
VALUES
('Pfizer', 2026, 95),
('Novo Nordisk', 2026, 60),
('Eli Lilly', 2026, 72);

-- Query 5: INNER JOIN
-- Combines financial data with pipeline data to see revenue + margin + pipeline size together
SELECT p.company_name, p.year, p.revenue_usd_bn, p.operating_margin_pct, d.pipeline_size_est
FROM pharma_data p
INNER JOIN pipeline_data d
ON p.company_name = d.company_name AND p.year = d.year
WHERE p.year = 2026
ORDER BY p.revenue_usd_bn DESC;

-- Query 6: Window function (LAG) for Year-over-Year growth
-- Compares each company's current year revenue to its own previous year revenue
-- and calculates the YoY growth percentage
SELECT company_name, year, revenue_usd_bn,
       LAG(revenue_usd_bn) OVER (PARTITION BY company_name ORDER BY year) AS prev_year_revenue,
       (revenue_usd_bn - LAG(revenue_usd_bn) OVER (PARTITION BY company_name ORDER BY year)) / 
        LAG(revenue_usd_bn) OVER (PARTITION BY company_name ORDER BY year) * 100 AS yoy_growth_pct
FROM pharma_data
ORDER BY company_name DESC;

-- Query 7: CASE statement for segmentation
-- Buckets companies into revenue tiers (High/Medium/Low/Emerging)
-- and shows total revenue + company count per tier for 2026
SELECT 
       CASE 
           WHEN revenue_usd_bn >= 100 THEN 'High Revenue'
           WHEN revenue_usd_bn BETWEEN 50 AND 99 THEN 'Medium Revenue'
           WHEN revenue_usd_bn BETWEEN 20 AND 49 THEN 'Low Revenue'
           ELSE 'Emerging'
       END AS revenue_segment,
       SUM(revenue_usd_bn) AS total_revenue,
       COUNT(*) AS company_count
FROM pharma_data
WHERE year = 2026
GROUP BY revenue_segment
ORDER BY total_revenue DESC;

-- Query 8: Subquery + CASE + RANK combined
-- For each revenue segment (High/Medium/Low/Emerging), finds the #1 company 
-- (highest revenue) within that segment for 2026
SELECT company_name, year, revenue_usd_bn, revenue_segment
FROM (
    SELECT company_name, year, revenue_usd_bn,
           CASE 
               WHEN revenue_usd_bn >= 100 THEN 'High Revenue'
               WHEN revenue_usd_bn BETWEEN 50 AND 99 THEN 'Medium Revenue'
               WHEN revenue_usd_bn BETWEEN 20 AND 49 THEN 'Low Revenue'
               ELSE 'Emerging'
           END AS revenue_segment,
           RANK() OVER (
               PARTITION BY 
                   CASE 
                       WHEN revenue_usd_bn >= 100 THEN 'High Revenue'
                       WHEN revenue_usd_bn BETWEEN 50 AND 99 THEN 'Medium Revenue'
                       WHEN revenue_usd_bn BETWEEN 20 AND 49 THEN 'Low Revenue'
                       ELSE 'Emerging'
                   END
               ORDER BY revenue_usd_bn DESC
           ) AS rank_in_segment
    FROM pharma_data
    WHERE year = 2026
) ranked
WHERE rank_in_segment = 1;
--using view 
CREATE VIEW top_companies_2026 AS
SELECT company_name, revenue_usd_bn, operating_margin_pct
FROM pharma_data
WHERE year = 2026
ORDER BY revenue_usd_bn DESC
LIMIT 5;
SELECT * FROM top_companies_2026;
