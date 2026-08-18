# CloudFlow Revenue Operations Analytics Project

A Revenue Operations analytics project built with Google BigQuery, SQL, and Looker Studio.

This project analyzes Q2 2026 revenue performance for CloudFlow, a fictional B2B SaaS company, and builds a data-driven outlook for Q3.

The goal of the project is not only to calculate business metrics, but to understand why the company missed its revenue target and identify the areas that should receive the most attention going into Q3.

The analysis follows the revenue journey from leads and sales opportunities through closed revenue, forecasting, deal slippage, customer retention, and Q3 pipeline.

---

## Business Problem

CloudFlow had a Q2 2026 New ARR target of **$1.50M**, but finished the quarter with only **$1.12M in Actual New ARR**.

This resulted in:

- **Target:** $1.50M
- **Actual New ARR:** $1.12M
- **Revenue Gap:** $380K
- **Target Attainment:** 74.67%

The main business question became:

> Why did CloudFlow miss its Q2 revenue target, and what should the company focus on to improve Q3 performance?

To answer this, I analyzed several areas of the revenue process:

- Lead quality and conversion
- Sales funnel performance
- Customer segment performance
- Sales execution and deal slippage
- Forecast reliability
- Customer retention and churn
- Q3 opening pipeline
- Q3 forecast scenarios

---

## Tech Stack

- **Data Warehouse:** Google BigQuery
- **Language:** SQL
- **Visualization:** Looker Studio
- **Version Control:** Git & GitHub

---

## Analytical Approach

I structured the analysis as a sequence of business questions rather than starting directly with dashboard creation.

The process was:

**Revenue Target → Actual Performance → Revenue Gap → Lead Quality → Funnel Conversion → Segment Performance → Forecast Reliability → Deal Slippage → Retention → Q3 Pipeline → Q3 Forecast**

This allowed me to move from identifying the revenue problem to investigating possible causes and finally evaluating the outlook for the next quarter.

---

# Step 1: Establish the Q2 Revenue Baseline

Before analyzing leads, sales execution, or forecasting, I first needed to understand the basic revenue performance of the company.

The first questions were:

1. What was the Q2 revenue target?
2. How much New ARR was actually closed?
3. What was the revenue gap?
4. What percentage of the target was achieved?

## Why I Started Here

Without establishing the revenue baseline, it would be difficult to evaluate whether problems in the funnel, forecasting, or customer segments were materially affecting company performance.

The baseline gives me a clear starting point for the rest of the analysis.
