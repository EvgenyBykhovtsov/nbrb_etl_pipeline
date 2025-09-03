-- =====================================================
-- Monthly Revenue Analysis
-- =====================================================
-- This query analyzes revenue trends over time with
-- year-over-year comparisons and growth metrics
-- =====================================================

WITH monthly_data AS (
    SELECT 
        DATE_TRUNC('month', "Order Date") AS month,
        EXTRACT(YEAR FROM "Order Date") AS year,
        EXTRACT(MONTH FROM "Order Date") AS month_num,
        SUM("Sales") AS revenue,
        SUM("Profit") AS profit,
        COUNT(DISTINCT "Order ID") AS order_count,
        COUNT(*) AS item_count
    FROM superstore
    GROUP BY DATE_TRUNC('month', "Order Date"), 
             EXTRACT(YEAR FROM "Order Date"), 
             EXTRACT(MONTH FROM "Order Date")
),
revenue_with_growth AS (
    SELECT 
        month,
        year,
        month_num,
        revenue,
        profit,
        order_count,
        item_count,
        LAG(revenue, 1) OVER (ORDER BY month) AS prev_month_revenue,
        LAG(revenue, 12) OVER (ORDER BY month) AS prev_year_revenue,
        (revenue - LAG(revenue, 1) OVER (ORDER BY month)) / 
        NULLIF(LAG(revenue, 1) OVER (ORDER BY month), 0) * 100 AS month_over_month_growth,
        (revenue - LAG(revenue, 12) OVER (ORDER BY month)) / 
        NULLIF(LAG(revenue, 12) OVER (ORDER BY month), 0) * 100 AS year_over_year_growth
    FROM monthly_data
)
SELECT 
    month,
    year,
    month_num,
    revenue,
    profit,
    order_count,
    item_count,
    prev_month_revenue,
    prev_year_revenue,
    ROUND(month_over_month_growth, 2) AS mom_growth_pct,
    ROUND(year_over_year_growth, 2) AS yoy_growth_pct,
    CASE 
        WHEN month_num IN (12, 1, 2) THEN 'Winter'
        WHEN month_num IN (3, 4, 5) THEN 'Spring'
        WHEN month_num IN (6, 7, 8) THEN 'Summer'
        WHEN month_num IN (9, 10, 11) THEN 'Fall'
    END AS season
FROM revenue_with_growth
ORDER BY month;
