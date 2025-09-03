-- =====================================================
-- Customer RFM Analysis
-- =====================================================
-- This query performs RFM (Recency, Frequency, Monetary) analysis
-- to segment customers based on their purchasing behavior
-- =====================================================

WITH customer_rfm AS (
    SELECT 
        "Customer ID",
        "Customer Name",
        "Segment",
        "Region",
        -- Recency: Days since last purchase
        EXTRACT(DAY FROM (SELECT MAX("Order Date") FROM superstore) - MAX("Order Date")) AS recency_days,
        -- Frequency: Number of orders
        COUNT(DISTINCT "Order ID") AS frequency_orders,
        -- Monetary: Total revenue
        SUM("Sales") AS monetary_revenue,
        -- Additional metrics
        COUNT(*) AS total_items,
        AVG("Sales") AS avg_order_value,
        SUM("Profit") AS total_profit,
        MIN("Order Date") AS first_purchase,
        MAX("Order Date") AS last_purchase
    FROM superstore
    GROUP BY "Customer ID", "Customer Name", "Segment", "Region"
),
rfm_scores AS (
    SELECT 
        *,
        -- Recency Score (1-5, where 1 is most recent)
        NTILE(5) OVER (ORDER BY recency_days ASC) AS recency_score,
        -- Frequency Score (1-5, where 5 is most frequent)
        NTILE(5) OVER (ORDER BY frequency_orders DESC) AS frequency_score,
        -- Monetary Score (1-5, where 5 is highest value)
        NTILE(5) OVER (ORDER BY monetary_revenue DESC) AS monetary_score
    FROM customer_rfm
),
rfm_segments AS (
    SELECT 
        *,
        (recency_score + frequency_score + monetary_score) AS rfm_score,
        CASE 
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 3 AND frequency_score >= 1 AND monetary_score >= 3 THEN 'Big Spenders'
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 1 THEN 'Recent Customers'
            WHEN recency_score >= 2 AND frequency_score >= 2 AND monetary_score >= 2 THEN 'Promising'
            WHEN recency_score >= 2 AND frequency_score >= 1 AND monetary_score >= 1 THEN 'Needs Attention'
            WHEN recency_score >= 1 AND frequency_score >= 1 AND monetary_score >= 1 THEN 'At Risk'
            ELSE 'Lost'
        END AS customer_segment
    FROM rfm_scores
)
SELECT 
    "Customer ID",
    "Customer Name",
    "Segment",
    "Region",
    recency_days,
    frequency_orders,
    monetary_revenue,
    total_items,
    avg_order_value,
    total_profit,
    first_purchase,
    last_purchase,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score,
    customer_segment,
    ROUND(total_profit / NULLIF(monetary_revenue, 0) * 100, 2) AS profit_margin_pct,
    ROUND(monetary_revenue / frequency_orders, 2) AS avg_order_value_corrected
FROM rfm_segments
ORDER BY rfm_score DESC, monetary_revenue DESC;



