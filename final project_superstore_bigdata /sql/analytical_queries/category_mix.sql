-- =====================================================
-- Category Performance Analysis
-- =====================================================
-- This query analyzes product category performance including
-- revenue, profitability, market share, and growth metrics
-- =====================================================

WITH category_totals AS (
    SELECT 
        SUM("Sales") AS total_revenue,
        SUM("Profit") AS total_profit,
        COUNT(*) AS total_transactions
    FROM superstore
),
category_analysis AS (
    SELECT 
        "Category",
        "Sub-Category",
        COUNT(*) AS transaction_count,
        SUM("Sales") AS revenue,
        SUM("Profit") AS profit,
        AVG("Sales") AS avg_sale_value,
        AVG("Quantity") AS avg_quantity,
        COUNT(DISTINCT "Product ID") AS unique_products,
        COUNT(DISTINCT "Customer ID") AS unique_customers,
        COUNT(DISTINCT "Order ID") AS unique_orders
    FROM superstore
    GROUP BY "Category", "Sub-Category"
)
SELECT 
    ca."Category",
    ca."Sub-Category",
    ca.transaction_count,
    ca.revenue,
    ca.profit,
    ROUND((ca.revenue / ct.total_revenue) * 100, 2) AS revenue_market_share,
    ROUND((ca.profit / ct.total_profit) * 100, 2) AS profit_market_share,
    ROUND(ca.profit / NULLIF(ca.revenue, 0) * 100, 2) AS profit_margin_pct,
    ca.avg_sale_value,
    ca.avg_quantity,
    ca.unique_products,
    ca.unique_customers,
    ca.unique_orders,
    ROUND(ca.revenue / ca.unique_customers, 2) AS revenue_per_customer,
    ROUND(ca.revenue / ca.unique_orders, 2) AS avg_order_value
FROM category_analysis ca
CROSS JOIN category_totals ct
ORDER BY ca.revenue DESC;
