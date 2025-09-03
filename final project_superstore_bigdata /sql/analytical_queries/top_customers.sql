-- =====================================================
-- Top Customers Analysis
-- =====================================================
-- This query identifies the highest-value customers and provides
-- insights into customer behavior and purchasing patterns
-- =====================================================

SELECT 
    "Customer Name",
    "Segment",
    "Region",
    "State",
    COUNT(DISTINCT "Order ID") AS total_orders,
    SUM("Sales") AS total_revenue,
    SUM("Profit") AS total_profit,
    AVG("Sales") AS avg_order_value,
    COUNT(*) AS total_items_purchased,
    MIN("Order Date") AS first_purchase_date,
    MAX("Order Date") AS last_purchase_date,
    (MAX("Order Date") - MIN("Order Date")) AS customer_lifetime_days
FROM superstore
GROUP BY "Customer Name", "Segment", "Region", "State"
HAVING SUM("Sales") > 0  -- Filter out customers with no purchases
ORDER BY total_revenue DESC
LIMIT 10;
