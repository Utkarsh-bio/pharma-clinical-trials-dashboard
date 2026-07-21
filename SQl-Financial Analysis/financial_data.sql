create database financial_data;
use financial_data;
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
SELECT company_name, revenue_usd_bn, operating_margin_pct
FROM pharma_data
WHERE year = 2026
ORDER BY revenue_usd_bn DESC;
SELECT company_name, SUM(revenue_usd_bn) AS total_revenue
FROM pharma_data
WHERE year = 2026
GROUP BY company_name
ORDER BY total_revenue DESC
LIMIT 5;
SELECT company_name,
       (MAX(revenue_usd_bn) - MIN(revenue_usd_bn)) / MIN(revenue_usd_bn) * 100 AS growth_pct
FROM pharma_data
GROUP BY company_name
ORDER BY growth_pct DESC
LIMIT 5;
WITH ranked_revenue AS (
    SELECT company_name, year, revenue_usd_bn,
           RANK() OVER (PARTITION BY year ORDER BY revenue_usd_bn DESC) AS rev_rank
    FROM pharma_data
)
SELECT *
FROM ranked_revenue
WHERE rev_rank <= 3;
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
SELECT p.company_name, p.year, p.revenue_usd_bn, p.operating_margin_pct, d.pipeline_size_est
FROM pharma_data p
INNER JOIN pipeline_data d
ON p.company_name = d.company_name AND p.year = d.year
WHERE p.year = 2026
ORDER BY p.revenue_usd_bn DESC;
SELECT company_name, year, revenue_usd_bn,
       LAG(revenue_usd_bn) OVER (PARTITION BY company_name ORDER BY year) AS prev_year_revenue,
       (revenue_usd_bn - LAG(revenue_usd_bn) OVER (PARTITION BY company_name ORDER BY year)) / 
        LAG(revenue_usd_bn) OVER (PARTITION BY company_name ORDER BY year) * 100 AS yoy_growth_pct
FROM pharma_data
ORDER BY company_name desc;
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
