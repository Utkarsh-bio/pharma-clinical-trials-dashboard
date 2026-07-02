# Pharma Clinical Trials Dashboard

An Excel dashboard analyzing global pharma clinical trials data (2010-2026) across 22 pharmaceutical companies.

## Dataset
Source: [Global Healthcare & Pharma 2010-2026 (Kaggle)](https://www.kaggle.com/datasets/sergionefedov/global-healthcare-and-pharma-2010-2026)
- 599 clinical trials
- 22 pharma sponsors
- 10 therapy areas

## Skills Used
- Pivot Tables & Pivot Charts
- VLOOKUP, INDEX/MATCH, XLOOKUP
- Nested IF / AND-OR Logic
- Data Validation (Interactive Dropdown)
- Conditional Formatting (Color-coded KPIs)
- Statistical functions (AVERAGE, COUNTIF, SUMPRODUCT, FORECAST)

## Key Insights
- Overall trial success rate: 52%
- Cardiovascular trials: highest success rate (~80%)
- Neurology trials: lowest success rate (~27%)
- Pfizer: highest trial count (40 trials)
- Phase 3 trials (326) outnumber Phase 2 (273)

## Dashboard Features
- Sponsor-wise trial count (Bar Chart)
- Trial phase distribution (Pie Chart)
- Success rate by therapy area (Bar Chart)
- KPIs: Total Trials, Success Rate, Total Sponsors
- Interactive sponsor search with dropdown + XLOOKUP
- Risk Level classification (High/Medium/Low) using Nested IF

## Files
- `Book (1).xlsx` — Full dashboard with raw data, pivot tables, and Dashboard sheet
- `Screenshot` — Dashboard preview
## SQL Analysis (New Addition)

To demonstrate progressive depth on the same dataset, I replicated this project's core analysis in MySQL:

- Designed and created a normalized `trials` table schema (13 columns) matching the Excel dataset
- Cleaned and imported 599 records from the source CSV, resolving date-format compatibility issues during import
- Wrote queries covering filtering (WHERE), aggregation (GROUP BY, ORDER BY), conditional logic (CASE), subqueries, and window functions (RANK)

Files: [`sql-analysis/schema.sql`](sql-analysis/schema.sql) | [`sql-analysis/queries.sql`](sql-analysis/queries.sql)
