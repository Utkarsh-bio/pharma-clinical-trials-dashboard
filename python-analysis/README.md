# Pharma Clinical Trials — Python Analysis

A Python-based statistical and machine learning analysis of the same clinical trials dataset used in the Excel, SQL, and Power BI projects in this repo — completing a four-tool analytics pipeline (Excel → SQL → Power BI → Python) on a single dataset.

## What's in this folder

```
pharma-python-analysis/
├── analysis.py
└── data/
    └── clinical_trials.csv
```

Generated outputs (charts): `success_by_phase.png`, `stock_impact_vs_success.png`, `feature_importance.png`

## Workflow

**1. Data loading & inspection** — loaded the 599-row clinical trials dataset with pandas, checked column types and confirmed no missing values.

**2. Exploratory analysis**
- Success rate by trial phase (Phase 2: ~61%, Phase 3: ~44%)
- Success rate by sponsor
- Scatter plot of estimated stock impact % vs. trial success

**3. Statistical inference (statsmodels)** — built a logistic regression (`is_success ~ estimated_stock_impact_pct + phase + enrollment_n + duration_months`) to test which factors are *statistically significant* predictors of trial success.

**Result:** `estimated_stock_impact_pct` was the only statistically significant predictor (p < 0.001, Pseudo R² = 0.69). Sponsor, phase, enrollment size, and trial duration were **not** statistically significant. This independently validates a pattern first surfaced by Power BI's Key Influencers visual, this time with a full regression summary and formal p-values.

**4. Predictive modeling (scikit-learn)** — trained a logistic regression classifier on an 80/20 train-test split to predict trial success:

| Metric | Value |
|---|---|
| Accuracy | 88% |
| Precision (success class) | 0.91 |
| Recall (success class) | 0.89 |

Confusion matrix and a feature-importance bar chart (based on model coefficients) confirm that stock impact % dominates the other features in predictive weight.

## Key Insight

Across three independent analytical methods — Power BI's Key Influencers, a statsmodels logistic regression, and a scikit-learn classifier — the same conclusion holds: **estimated stock market impact is a far stronger predictor of clinical trial success than sponsor identity, trial phase, enrollment size, or trial duration.** This cross-validation across tools and techniques is the central finding of this four-part project.

## Libraries Used

pandas, matplotlib, statsmodels, scikit-learn
