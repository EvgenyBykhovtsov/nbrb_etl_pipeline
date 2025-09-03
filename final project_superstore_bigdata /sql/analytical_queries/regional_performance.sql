-- =====================================================
-- Regional Performance Analysis
-- =====================================================
-- This query analyzes sales performance by geographic regions
-- including states, cities, and regional trends
-- =====================================================

WITH regional_totals AS (
    SELECT 
        SUM("Sales") AS total_revenue,
        SUM("Profit") AS total_profit,
        COUNT(*) AS total_transactions
    FROM superstore
),
state_analysis AS (
    SELECT 
        "State",
        "Region",
        COUNT(*) AS transaction_count,
        SUM("Sales") AS revenue,
        SUM("Profit") AS profit,
        COUNT(DISTINCT "Customer ID") AS unique_customers,
        COUNT(DISTINCT "Order ID") AS unique_orders,
        AVG("Sales") AS avg_order_value,
        ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
    FROM superstore
    GROUP BY "State", "Region"
),
city_analysis AS (
    SELECT 
        "City",
        "State",
        "Region",
        COUNT(*) AS transaction_count,
        SUM("Sales") AS revenue,
        SUM("Profit") AS profit,
        COUNT(DISTINCT "Customer ID") AS unique_customers,
        AVG("Sales") AS avg_order_value,
        ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
    FROM superstore
    GROUP BY "City", "State", "Region"
    HAVING COUNT(*) >= 10  -- Filter cities with at least 10 transactions
)
SELECT 
    'State Level' AS analysis_level,
    sa."State",
    sa."Region",
    sa.transaction_count,
    sa.revenue,
    sa.profit,
    sa.unique_customers,
    sa.unique_orders,
    sa.avg_order_value,
    sa.profit_margin_pct,
    ROUND((sa.revenue / rt.total_revenue) * 100, 2) AS revenue_share_pct,
    ROUND((sa.profit / rt.total_profit) * 100, 2) AS profit_share_pct,
    ROUND(sa.revenue / sa.unique_customers, 2) AS revenue_per_customer
FROM state_analysis sa
CROSS JOIN regional_totals rt

UNION ALL

SELECT 
    'City Level' AS analysis_level,
    ca."City" AS location,
    ca."Region",
    ca.transaction_count,
    ca.revenue,
    ca.profit,
    ca.unique_customers,
    NULL AS unique_orders,
    ca.avg_order_value,
    ca.profit_margin_pct,
    ROUND((ca.revenue / rt.total_revenue) * 100, 2) AS revenue_share_pct,
    ROUND((ca.profit / rt.total_profit) * 100, 2) AS profit_share_pct,
    ROUND(ca.revenue / ca.unique_customers, 2) AS revenue_per_customer
FROM city_analysis ca
CROSS JOIN regional_totals rt
WHERE ca.revenue > 10000  -- Focus on significant cities

ORDER BY analysis_level, revenue DESC;



