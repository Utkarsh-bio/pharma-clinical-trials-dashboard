# Pharma Clinical Trials — Power BI Dashboard
An interactive, 4-page Power BI dashboard analyzing clinical trial outcomes across sponsors, phases, and therapy areas. Built on the same clinical trials dataset used in the companion Excel and SQL projects in this repo, completing an end-to-end analytics narrative across three tools.

## Data Model

Star schema with 1 fact table and 4 dimension tables:

- *Fact_trials* — trial-level records (enrollment, duration, outcome, estimated stock impact %, success/failure flags)
- *Dim_sponsor* — sponsor lookup
- *Dim_phase* — trial phase lookup
- *Dim_TherapyArea* — therapy area lookup
- *Dim_date* — full calendar table (2010–2026), marked as the official date table, with Year, Month Name, Month Number, and Quarter columns for time intelligence

All dimension tables are joined to Fact_trials on one-to-many relationships.

## DAX Measures

| Measure | Formula logic |
|---|---|
| Total_trials | COUNTROWS(Fact_trials) |
| Success Rate | DIVIDE(SUM(is_success), COUNTROWS(Fact_trials)) |
| Avg Duration Months | AVERAGE(duration_months) |
| Avg Enrollment | AVERAGE(enrollment_n) |
| Target success rate | Fixed benchmark (0.5) used for KPI target tracking |

## Pages

*1. Overview* — KPI cards (total trials, success rate, avg enrollment, avg duration), a sponsor-wise trial count chart, a phase-wise success rate chart, and interactive year-range and phase slicers for cross-filtering.

*2. Deep Dive Analysis* — An AI Decomposition Tree that lets users drill from Total Trials down through sponsor → phase → therapy area, surfacing which combinations drive the highest/lowest trial volume.

*3. Success Predictors* — Power BI's Key Influencers visual (a statistical/ML-based visual) applied to is_success, explained by sponsor, phase, therapy area, and estimated stock impact %. It surfaced a non-obvious insight: *estimated stock impact percentage is a stronger predictor of trial success than sponsor or phase* — suggesting market signals may reflect trial confidence ahead of official outcomes. A supporting scatter plot (stock impact % vs. success rate, one point per trial) visualizes this relationship.

*4. Performance Matrix* — A sponsor × phase success rate matrix with red-yellow-green conditional formatting (heatmap), plus a KPI visual tracking success rate against a 50% target with a year-over-year trend sparkline.

All pages share a consistent Page Navigator for one-click navigation between views.

## Key Insight

Across 21 sponsors and 2 trial phases, sponsor identity and phase alone were weak predictors of trial success. The strongest predictor identified was estimated stock market impact percentage — a signal not typically foregrounded in trial-level reporting, but one that ties clinical outcomes directly to market expectations.

## Tools & Techniques Used

Star schema modeling, DAX measures, AI-powered visuals (Decomposition Tree, Key Influencers), conditional formatting / heatmaps, KPI visuals with target tracking, interactive slicers, and cross-page navigation.
