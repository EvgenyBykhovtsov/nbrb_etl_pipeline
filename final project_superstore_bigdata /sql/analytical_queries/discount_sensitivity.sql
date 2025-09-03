-- =====================================================
-- Discount Sensitivity Analysis
-- =====================================================
-- This query analyzes the relationship between discounts and
-- sales performance to identify optimal pricing strategies
-- =====================================================

WITH discount_bins AS (
    SELECT 
        CASE 
            WHEN "Discount" = 0 THEN 'No Discount (0%)'
            WHEN "Discount" <= 0.1 THEN 'Low Discount (1-10%)'
            WHEN "Discount" <= 0.2 THEN 'Medium Discount (11-20%)'
            WHEN "Discount" <= 0.3 THEN 'High Discount (21-30%)'
            WHEN "Discount" <= 0.5 THEN 'Very High Discount (31-50%)'
            ELSE 'Extreme Discount (>50%)'
        END AS discount_range,
        "Discount",
        "Sales",
        "Profit",
        "Quantity",
        "Category",
        "Segment"
    FROM superstore
),
discount_analysis AS (
    SELECT 
        discount_range,
        COUNT(*) AS transaction_count,
        SUM("Sales") AS total_revenue,
        SUM("Profit") AS total_profit,
        AVG("Sales") AS avg_sale_value,
        AVG("Profit") AS avg_profit,
        AVG("Quantity") AS avg_quantity,
        COUNT(DISTINCT "Category") AS categories_affected,
        COUNT(DISTINCT "Segment") AS segments_affected,
        ROUND(AVG("Profit" / NULLIF("Sales", 0)) * 100, 2) AS avg_profit_margin_pct,
        ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100, 2) AS total_profit_margin_pct
    FROM discount_bins
    GROUP BY discount_range
)
SELECT 
    discount_range,
    transaction_count,
    total_revenue,
    total_profit,
    avg_sale_value,
    avg_profit,
    avg_quantity,
    categories_affected,
    segments_affected,
    avg_profit_margin_pct,
    total_profit_margin_pct,
    ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) AS revenue_share_pct,
    ROUND((total_profit / SUM(total_profit) OVER ()) * 100, 2) AS profit_share_pct
FROM discount_analysis
ORDER BY 
    CASE discount_range
        WHEN 'No Discount (0%)' THEN 1
        WHEN 'Low Discount (1-10%)' THEN 2
        WHEN 'Medium Discount (11-20%)' THEN 3
        WHEN 'High Discount (21-30%)' THEN 4
        WHEN 'Very High Discount (31-50%)' THEN 5
        WHEN 'Extreme Discount (>50%)' THEN 6
    END;
