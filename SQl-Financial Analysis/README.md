# Pharma Financial Analysis (SQL)

SQL-based analysis of pharma company financials (revenue, margins, R&D spend, pipeline size) for 2026, built in MySQL Workbench.

## Database
- `financial_data` database with two tables:
  - `pharma_data` — yearly revenue, operating margin, R&D spend, pipeline size by company/segment/country
  - `pipeline_data` — R&D pipeline size by company (used for JOIN demo)

## Concepts covered

| # | Query | What it does |
|---|-------|---------------|
| 1 | Basic filter + sort | Lists all companies' revenue & margin for 2026, sorted by revenue |
| 2 | GROUP BY + SUM | Finds top 5 companies by total revenue |
| 3 | MAX/MIN growth calc | Calculates % growth per company using highest vs lowest revenue on record |
| 4 | CTE + RANK() | Ranks companies by revenue per year, returns top 3 each year |
| 5 | INNER JOIN | Combines financial data with pipeline data for a fuller view |
| 6 | LAG() window function | Calculates year-over-year (YoY) revenue growth per company |
| 7 | CASE statement | Segments companies into High/Medium/Low/Emerging revenue tiers |
| 8 | Subquery + CASE + RANK | Finds the top company within each revenue segment |
| 9 | VIEW | Creates `top_companies_2026` — a saved view returning the top 5 companies by revenue for 2026, reusable without rewriting the full query each time |

## Key insights
- (fill in: which company had highest revenue in 2026, which had highest YoY growth, etc.)

## Tools
MySQL Workbench

## Files
- `pharma_financial_analysis.sql` — core queries (filtering, aggregation, CTE, window functions, JOIN, CASE)
- `views.sql` — VIEW definition for reusable top-5 revenue report
