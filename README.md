# cloudflow-revops-analysis
Revenue Operations analysis of Q2 performance, sales funnel, forecasting, retention, and Q3 pipeline using SQL and BigQuery.
# CloudFlow Revenue Operations Analysis

Revenue Operations analysis of Q2 2026 performance and Q3 pipeline for a fictional B2B SaaS company.

The goal of this project was to understand why CloudFlow missed its Q2 New ARR target and identify actions that could improve sales performance, forecasting, retention, and Q3 execution.

## Business Problem

CloudFlow had a Q2 New ARR target of $1.5M but generated $1.12M, reaching 74.7% of target and leaving a $380K revenue gap.

The analysis focused on:

- Revenue performance vs. target
- Lead funnel and SQL → Opportunity conversion
- Sales performance by customer segment
- Deal slippage
- Forecast reliability
- Customer retention and churn
- Q3 pipeline health and forecast scenarios

## Key Findings

- Q2 New ARR: **$1.12M vs. $1.50M target (74.7% attainment)**
- Revenue gap: **$380K**
- Small Business win rate: **28%**
- Mid-Market win rate: **20%**, with higher deal values
- **44.74%** of won deals closed later than expected
- Mid-Market deal slippage reached **60%**
- Only **14.39%** of Commit opportunities became Closed Won
- Overall NRR: **93.06%**
- Small Business NRR: **84.33%**
- Main churn drivers: **Budget Reduction ($162K)** and **Low Adoption ($128K)**

## Q3 Outlook

| Metric | Result |
|---|---:|
| Q3 Target | $1.60M |
| Opening Pipeline | $4.40M |
| Pipeline Coverage | 2.75x |
| Conservative Forecast | $1.233M |
| Expected Forecast | $1.978M |
| Optimistic Forecast | $2.813M |

The expected scenario is above the Q3 target, but historical forecast performance and deal slippage indicate execution risk.

## Recommendations

1. **Improve Lead Funnel Performance** — focus on lead sources that generate stronger SQL → Opportunity conversion.
2. **Improve Forecast Discipline** — tighten Commit criteria and review forecast categories weekly.
3. **Reduce Deal Slippage** — identify at-risk opportunities before expected close dates, especially in Mid-Market.
4. **Improve Small Business Retention** — prioritize low-adoption and at-risk customers before renewal.
5. **Prioritize Q3 Pipeline** — focus Sales on high-value, late-stage opportunities most likely to close.

## Tools Used

- Google BigQuery
- SQL
- Excel
- GitHub

## Project Files

- `sql/CloudFlow_RevOps_Full_Analysis.sql` — complete SQL analysis
- `CloudFlow_Executive_Summary.pdf` — executive summary with findings and recommendations

## Skills Demonstrated

SQL analysis • Revenue Operations • Sales funnel analysis • Forecasting • Pipeline analysis • Retention analysis • Business recommendations
