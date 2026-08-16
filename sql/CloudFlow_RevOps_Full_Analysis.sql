-- =====================================================
-- CLOUDFLOW REVOPS FULL ANALYSIS
-- Q2 2026 Performance + Q3 Forecast
-- =====================================================

-- =====================================================
-- 1. What are the company targets?
-- =====================================================

-- Total Q2 2026 targets
SELECT *
FROM `fifth-flash-489402-h9.cloudflow_revops.targets`
WHERE Quarter = 'Q2 2026';

-- Company Target by Quarter
SELECT
  Quarter,
  New_ARR_Target
FROM `fifth-flash-489402-h9.cloudflow_revops.targets`
WHERE Target_Level = 'Company'
ORDER BY Quarter;

-- Segment Targets by Quarter
SELECT
  Quarter,
  SUM(New_ARR_Target) AS target
FROM `fifth-flash-489402-h9.cloudflow_revops.targets`
WHERE Target_Level = 'Segment'
GROUP BY Quarter
ORDER BY Quarter;

-- Account Executive Targets
SELECT
  Target_Name,
  New_ARR_Target
FROM `fifth-flash-489402-h9.cloudflow_revops.targets`
WHERE Quarter = 'Q2 2026'
  AND Target_Level = 'Account Executive';


-- =====================================================
-- 2. Q2 2026 Actual New ARR
-- =====================================================

SELECT
  COUNT(*) AS won_opportunities,
  SUM(Opportunity_ARR) AS actual_new_arr
FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`
WHERE Analysis_Quarter = 'Q2 2026'
  AND Quarter_End_Status = 'Closed Won';


-- =====================================================
-- 3. Quarter End Status Distribution
-- =====================================================

SELECT
  Quarter_End_Status,
  COUNT(*) AS opportunities,
  SUM(Opportunity_ARR) AS total_arr,
  ROUND(AVG(Opportunity_ARR),2) AS avg_deal_size
FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`
WHERE Analysis_Quarter = 'Q2 2026'
GROUP BY Quarter_End_Status
ORDER BY total_arr DESC;


-- =====================================================
-- 4. Target vs Actual (Q2 2026)
-- =====================================================

WITH target AS (

SELECT
  SUM(New_ARR_Target) AS company_target
FROM `fifth-flash-489402-h9.cloudflow_revops.targets`
WHERE Quarter = 'Q2 2026'
  AND Target_Level = 'Company'

),

actual AS (

SELECT
  SUM(Opportunity_ARR) AS actual_new_arr
FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`
WHERE Analysis_Quarter = 'Q2 2026'
  AND Quarter_End_Status = 'Closed Won'

  )

SELECT
  company_target,
  actual_new_arr,
  company_target - actual_new_arr AS revenue_gap,
  ROUND(actual_new_arr / company_target * 100,2) AS attainment_pct
FROM target
CROSS JOIN actual;


-- =====================================================
-- 5. Pipeline Health by Current Stage
-- =====================================================

SELECT
  Current_Stage,
  COUNT(*) AS deals,
  SUM(Opportunity_ARR) AS total_arr,
  ROUND(AVG(Opportunity_ARR),2) AS avg_deal_size
FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`
WHERE Analysis_Quarter = 'Q2 2026'
GROUP BY Current_Stage
ORDER BY total_arr DESC;


-- =====================================================
-- 6. Closed Won vs Open - Slipped Comparison
-- =====================================================

SELECT
  Quarter_End_Status,
  COUNT(*) AS deals,
  SUM(Opportunity_ARR) AS total_arr,
  ROUND(AVG(Opportunity_ARR),2) AS avg_deal_size
FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`
WHERE Analysis_Quarter = 'Q2 2026'
  AND Quarter_End_Status IN ('Closed Won','Open - Slipped')
GROUP BY Quarter_End_Status
ORDER BY total_arr DESC;


-- =====================================================
-- 7. Lead Quality
-- =====================================================

-- Total Leads by Source

SELECT
  Lead_Source_Raw,
  COUNT(*) AS leads
FROM `fifth-flash-489402-h9.cloudflow_revops.leads`
WHERE Lead_Cohort_Quarter = 'Q2 2026'
GROUP BY Lead_Source_Raw
ORDER BY leads DESC;

-- Average Lead Score by Source

SELECT
  Lead_Source_Raw,
  COUNT(*) AS leads,
  ROUND(AVG(Lead_Score),2) AS avg_lead_score
FROM `fifth-flash-489402-h9.cloudflow_revops.leads`
WHERE Lead_Cohort_Quarter = 'Q2 2026'
GROUP BY Lead_Source_Raw
ORDER BY avg_lead_score DESC;


-- =====================================================
-- 8. MQL → SQL Conversion
-- =====================================================

SELECT
  Lead_Source_Raw,

  COUNT(*) AS total_leads,

  COUNT(MQL_Date) AS mqls,

  COUNT(SQL_Date) AS sqls,

  ROUND(COUNT(MQL_Date) * 100.0 / COUNT(*),2) AS lead_to_mql_rate,

  ROUND(COUNT(SQL_Date) * 100.0 / COUNT(*),2) AS lead_to_sql_rate,

  ROUND(COUNT(SQL_Date) * 100.0 / COUNT(MQL_Date),2) AS mql_to_sql_rate

FROM `fifth-flash-489402-h9.cloudflow_revops.leads`

WHERE Lead_Cohort_Quarter = 'Q2 2026'

GROUP BY Lead_Source_Raw

ORDER BY mql_to_sql_rate DESC;


-- =====================================================
-- 9. SQL → Opportunity Conversion
-- =====================================================

SELECT

  Lead_Source_Raw,

  COUNT(*) AS total_leads,

  COUNT(MQL_Date) AS mqls,

  COUNT(SQL_Date) AS sqls,

  COUNT(Linked_Opportunity_ID) AS opportunities,

  ROUND(COUNT(MQL_Date) * 100.0 / COUNT(*),2) AS lead_to_mql_rate,

  ROUND(COUNT(SQL_Date) * 100.0 / COUNT(*),2) AS lead_to_sql_rate,

  ROUND(COUNT(SQL_Date) * 100.0 / COUNT(MQL_Date),2) AS mql_to_sql_rate,

  ROUND(COUNT(Linked_Opportunity_ID) * 100.0 / COUNT(SQL_Date),2)
  AS sql_to_opportunity_rate

FROM `fifth-flash-489402-h9.cloudflow_revops.leads`

WHERE Lead_Cohort_Quarter = 'Q2 2026'

GROUP BY Lead_Source_Raw

ORDER BY sql_to_opportunity_rate DESC;


-- =====================================================
-- 10. Lead → Opportunity → Closed Won Funnel by Source
-- =====================================================

SELECT
  l.Lead_Source_Raw,

  COUNT(*) AS total_leads,

  COUNT(l.Linked_Opportunity_ID) AS opportunities,

  COUNT(CASE WHEN o.Quarter_End_Status = 'Closed Won' THEN 1 END
  ) AS closed_won,

  ROUND(COUNT(l.Linked_Opportunity_ID) * 100.0 / COUNT(*), 2
  ) AS lead_to_opp_rate,

  ROUND(COUNT(CASE WHEN o.Quarter_End_Status = 'Closed Won' THEN 1 END) * 100.0 / COUNT(*),2) AS lead_to_won_rate,

  ROUND(COUNT(CASE WHEN o.Quarter_End_Status = 'Closed Won' THEN 1 END) * 100.0 / COUNT(l.Linked_Opportunity_ID),2) AS opp_to_won_rate

FROM `fifth-flash-489402-h9.cloudflow_revops.leads` AS l

LEFT JOIN `fifth-flash-489402-h9.cloudflow_revops.opportunities` AS o
  ON l.Linked_Opportunity_ID = o.Opportunity_ID

WHERE l.Lead_Cohort_Quarter = 'Q2 2026'

GROUP BY l.Lead_Source_Raw

ORDER BY opp_to_won_rate DESC;


-- =====================================================
-- 11. Sales Cycle by Lead Source
-- =====================================================

SELECT
  l.Lead_Source_Raw,
  COUNT(*) AS closed_won_deals,
  ROUND(AVG(DATE_DIFF(o.Actual_Close_Date, l.Lead_Created_Date, DAY)),2) AS avg_days_to_close

FROM `fifth-flash-489402-h9.cloudflow_revops.leads` l

JOIN `fifth-flash-489402-h9.cloudflow_revops.opportunities` o
  ON l.Linked_Opportunity_ID = o.Opportunity_ID

WHERE l.Lead_Cohort_Quarter = 'Q2 2026'
  AND o.Quarter_End_Status = 'Closed Won'
  AND o.Actual_Close_Date >= l.Lead_Created_Date

GROUP BY l.Lead_Source_Raw

ORDER BY closed_won_deals DESC;


-- =====================================================
-- 12. Customer Segment Performance
-- =====================================================

SELECT
  Customer_Segment,
  COUNT(*) AS opportunities,

  COUNT(CASE WHEN Quarter_End_Status = 'Closed Won' THEN 1 END
  ) AS closed_won,

  SUM(CASE WHEN Quarter_End_Status = 'Closed Won' THEN Opportunity_ARR ELSE 0 END
  ) AS won_arr,

  ROUND(COUNT(CASE WHEN Quarter_End_Status = 'Closed Won' THEN 1 END) * 100.0 / COUNT(*),2) AS win_rate,

  ROUND(AVG(Opportunity_ARR), 2) AS avg_deal_size

FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`

WHERE Analysis_Quarter = 'Q2 2026'

GROUP BY Customer_Segment

ORDER BY won_arr DESC;


-- =====================================================
-- 13. Account Executive Performance
-- =====================================================

SELECT
  Account_Executive,
  COUNT(*) AS opportunities,

  COUNT(CASE WHEN Quarter_End_Status = 'Closed Won' THEN 1 END) AS closed_won,

  ROUND(SUM(CASE WHEN Quarter_End_Status = 'Closed Won' THEN Opportunity_ARR END),2) AS closed_won_arr,

  ROUND(COUNT(CASE WHEN Quarter_End_Status = 'Closed Won' THEN 1 END) * 100.0 / COUNT(*),2) AS win_rate,

  ROUND(AVG(Opportunity_ARR),2) AS avg_deal_size

FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities` o

WHERE Analysis_Quarter = 'Q2 2026'

GROUP BY Account_Executive

ORDER BY closed_won DESC;


-- =====================================================
-- 14. Forecast Accuracy by Forecast Category
-- =====================================================

SELECT
  Forecast_Category_at_Snapshot,

  COUNT(*) AS opportunities,

  ROUND(SUM(Sales_Forecast_ARR),2) AS forecast_arr,

  ROUND(SUM(Final_Actual_ARR),2) AS actual_arr,

  ROUND(SUM(Final_Actual_ARR)-SUM(Sales_Forecast_ARR),2) AS variance,
  ROUND(SUM(Final_Actual_ARR)*100/
  SUM(Sales_Forecast_ARR),2) AS forecast_accuracy

FROM `fifth-flash-489402-h9.cloudflow_revops.forecast_snapshots`

GROUP BY Forecast_Category_at_Snapshot

ORDER BY forecast_arr DESC;


-- =====================================================
-- 15. Deal Slippage Analysis
-- =====================================================

-- 15.1 Overall Slippage Rate

SELECT
  COUNT(*) AS total_closed_deals,

  COUNT(CASE WHEN Actual_Close_Date > Expected_Close_Date THEN 1 END) AS slipped_deals,

  ROUND(COUNT(CASE WHEN Actual_Close_Date > Expected_Close_Date THEN 1 END) * 100.0 / COUNT(*),2) AS slippage_rate

FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`

WHERE Analysis_Quarter = 'Q2 2026'
  AND Quarter_End_Status = 'Closed Won';

-- 15.2 Average Days Slipped

SELECT
  ROUND(AVG(DATE_DIFF(Actual_Close_Date,Expected_Close_Date,DAY)),2) AS avg_days_slipped

FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`

WHERE Analysis_Quarter = 'Q2 2026'
  AND Quarter_End_Status = 'Closed Won'
  AND Actual_Close_Date > Expected_Close_Date;


-- 15.3 Deal Slippage by Customer Segment

SELECT
  Customer_Segment,
  COUNT(*) AS closed_won_deals,

  COUNT(CASE WHEN Actual_Close_Date > Expected_Close_Date 
  THEN 1 END) AS slipped_deals,

  ROUND(COUNT(CASE WHEN Actual_Close_Date > Expected_Close_Date 
  THEN 1 END) * 100.0 / COUNT(*),2) AS slippage_rate,

  ROUND(AVG(CASE WHEN Actual_Close_Date > Expected_Close_Date
  THEN DATE_DIFF(Actual_Close_Date, Expected_Close_Date,DAY) END), 2) AS avg_days_slipped

FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`

WHERE Analysis_Quarter = 'Q2 2026'
  AND Quarter_End_Status = 'Closed Won'

GROUP BY Customer_Segment

ORDER BY slippage_rate DESC;


-- 15.4 Deal Slippage by Account Executive

SELECT
  Account_Executive,
  COUNT(*) AS closed_won_deals,

  COUNT(CASE WHEN Actual_Close_Date > Expected_Close_Date
  THEN 1 END) AS slipped_deals,

  ROUND(COUNT(CASE WHEN Actual_Close_Date > Expected_Close_Date THEN 1 END) * 100.0 / COUNT(*),2) AS slippage_rate,

  ROUND(AVG(CASE WHEN Actual_Close_Date > Expected_Close_Date
  THEN DATE_DIFF(Actual_Close_Date, Expected_Close_Date,DAY) END),2) AS avg_days_slipped

FROM `fifth-flash-489402-h9.cloudflow_revops.opportunities`

WHERE Analysis_Quarter = 'Q2 2026'
  AND Quarter_End_Status = 'Closed Won'

GROUP BY Account_Executive

ORDER BY slippage_rate DESC;

-- =====================================================
-- 16. Customer Renewals & Churn Analysis
-- =====================================================

-- =====================================================
-- 16.1 Overall Renewal Summary
-- =====================================================

SELECT
  COUNT(*) AS customers,
  SUM(ARR_Due_for_Renewal) AS renewal_arr,
  SUM(Renewed_Base_ARR) AS renewed_arr,
  SUM(Expansion_ARR) AS expansion_arr,
  SUM(Contraction_ARR) AS contraction_arr,
  SUM(Churned_ARR) AS churned_arr,
  SUM(Ending_ARR) AS ending_arr
FROM `fifth-flash-489402-h9.cloudflow_revops.customers_renewals_q2`;

-- =====================================================
-- 16.2 Renewal Rate
-- =====================================================

SELECT
  ROUND(SUM(Renewed_Base_ARR) * 100.0 /
  SUM(ARR_Due_for_Renewal),2) AS renewal_rate
FROM `fifth-flash-489402-h9.cloudflow_revops.customers_renewals_q2`;


-- =====================================================
-- 16.3 Churn Rate
-- =====================================================

SELECT
  ROUND(SUM(Churned_ARR) * 100.0 /
  SUM(ARR_Due_for_Renewal),2) AS churn_rate
FROM `fifth-flash-489402-h9.cloudflow_revops.customers_renewals_q2`;


-- =====================================================
-- 16.4 Net Revenue Retention (NRR)
-- =====================================================

SELECT
  ROUND(SUM(Ending_ARR) * 100.0 /
  SUM(ARR_Due_for_Renewal), 2) AS net_revenue_retention
FROM `fifth-flash-489402-h9.cloudflow_revops.customers_renewals_q2`;


-- =====================================================
-- 16.5 Retention by Customer Segment
-- =====================================================

SELECT
  Customer_Segment,
  COUNT(*) AS customers,
  SUM(ARR_Due_for_Renewal) AS renewal_arr,
  SUM(Renewed_Base_ARR) AS renewed_arr,
  SUM(Churned_ARR) AS churned_arr,
  SUM(Expansion_ARR) AS expansion_arr,
  SUM(Contraction_ARR) AS contraction_arr,
  SUM(Ending_ARR) AS ending_arr,

  ROUND(SUM(Ending_ARR) * 100.0 /
  SUM(ARR_Due_for_Renewal),2  ) AS nrr

FROM `fifth-flash-489402-h9.cloudflow_revops.customers_renewals_q2`

GROUP BY Customer_Segment

ORDER BY renewal_arr DESC;

-- =====================================================
-- 16.6 Top Churn Reasons
-- =====================================================

SELECT
  Churn_Reason,
  COUNT(*) AS churned_customers,
  SUM(Churned_ARR) AS churned_arr

FROM `fifth-flash-489402-h9.cloudflow_revops.customers_renewals_q2`

WHERE Renewal_Status = 'Churned'

GROUP BY Churn_Reason
ORDER BY churned_arr DESC;


--=====================================================
-- 17. Q3 Opening Pipeline Analysis
--=====================================================

-- 17.1 Overall Pipeline Summary

SELECT
  COUNT(*) AS opportunities,
  SUM(Opportunity_ARR) AS pipeline_arr
FROM `fifth-flash-489402-h9.cloudflow_revops.q3_opening_pipeline`;


-- 17.2 Pipeline by Stage

SELECT
  Current_Stage,
  COUNT(*) AS opportunities,
  SUM(Opportunity_ARR) AS pipeline_arr
FROM `fifth-flash-489402-h9.cloudflow_revops.q3_opening_pipeline`
GROUP BY Current_Stage
ORDER BY pipeline_arr DESC;


-- 17.3 Pipeline by Forecast Category

SELECT
  Forecast_Category,
  COUNT(*) AS opportunities,
  SUM(Opportunity_ARR) AS pipeline_arr
FROM `fifth-flash-489402-h9.cloudflow_revops.q3_opening_pipeline`
GROUP BY Forecast_Category
ORDER BY pipeline_arr DESC;


-- 17.4 Pipeline by Segment
SELECT
  Customer_Segment,
  COUNT(*) AS opportunities,
  SUM(Opportunity_ARR) AS pipeline_arr
FROM `fifth-flash-489402-h9.cloudflow_revops.q3_opening_pipeline`
GROUP BY Customer_Segment
ORDER BY pipeline_arr DESC;


-- 17.5 Biggest Deals

SELECT
  Opportunity_ID,
  Account_Executive,
  Customer_Segment,
  Current_Stage,
  Forecast_Category,
  Opportunity_ARR
FROM `fifth-flash-489402-h9.cloudflow_revops.q3_opening_pipeline`
ORDER BY Opportunity_ARR DESC
LIMIT 10;


-- 17.6 Pipeline Coverage

SELECT
  SUM(Opportunity_ARR) AS pipeline_arr,
  1600000 AS q3_target,
  ROUND( SUM(Opportunity_ARR)/1600000,2
  ) AS pipeline_coverage
FROM `fifth-flash-489402-h9.cloudflow_revops.q3_opening_pipeline`;


-- =====================================================
-- 18. Q3 Forecast Scenarios
-- =====================================================

SELECT

  ROUND(SUM(CASE WHEN Forecast_Category = 'Commit' THEN Opportunity_ARR * 0.50
  WHEN Forecast_Category = 'Best Case' THEN Opportunity_ARR * 0.20
  WHEN Forecast_Category = 'Pipeline' THEN Opportunity_ARR * 0.05
  ELSE 0 END),2 ) AS conservative_forecast,

  ROUND( SUM( CASE 
  WHEN Forecast_Category = 'Commit' THEN Opportunity_ARR * 0.70
  WHEN Forecast_Category = 'Best Case' THEN Opportunity_ARR * 0.40
  WHEN Forecast_Category = 'Pipeline' THEN Opportunity_ARR * 0.10
  ELSE 0 END), 2) AS expected_forecast,

  ROUND(SUM(
  CASE  WHEN Forecast_Category = 'Commit' THEN Opportunity_ARR * 0.90
  WHEN Forecast_Category = 'Best Case' THEN Opportunity_ARR * 0.60
  WHEN Forecast_Category = 'Pipeline' THEN Opportunity_ARR * 0.25
  ELSE 0 END), 2) AS optimistic_forecast

FROM `fifth-flash-489402-h9.cloudflow_revops.q3_opening_pipeline`;
