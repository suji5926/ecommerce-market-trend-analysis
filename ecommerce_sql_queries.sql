

-- Query 1: Total number of orders
SELECT COUNT(*)
FROM ecommerce_orders;

---------------------------------------------------------------------------------------------

-- Query 2: Preview the first 5 rows
SELECT *
FROM ecommerce_orders
LIMIT 5;

---------------------------------------------------------------------------------------------
-- Query 3: Total revenue across all orders
SELECT
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders;

---------------------------------------------------------------------------------------------
-- Query 4: Monthly revenue, highest month first
SELECT
    order_month,
    ROUND(SUM(net_amount), 2) AS monthly_revenue
FROM ecommerce_orders
GROUP BY order_month
ORDER BY monthly_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 5: Orders and revenue by order status
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_amount), 2) AS total_net_amount
FROM ecommerce_orders
GROUP BY order_status
ORDER BY total_net_amount DESC;

---------------------------------------------------------------------------------------------
-- Query 6: Total net amount (overall)
SELECT
    ROUND(SUM(net_amount), 2) AS total_net_amount
FROM ecommerce_orders;

---------------------------------------------------------------------------------------------
-- Query 7: Average order value
SELECT
    ROUND(AVG(net_amount), 2) AS average_order_value
FROM ecommerce_orders;

---------------------------------------------------------------------------------------------

-- Query 8: Monthly revenue trend in chronological order
SELECT
    order_month,
    ROUND(SUM(net_amount), 2) AS monthly_revenue
FROM ecommerce_orders
GROUP BY order_month
ORDER BY order_month;

---------------------------------------------------------------------------------------------

-- Query 9: Orders, units sold and revenue by category
SELECT
    main_category,
    COUNT(*) AS total_orders,
    SUM(total_quantity) AS units_sold,
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders
GROUP BY main_category
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 10: Orders, units sold and revenue by brand
SELECT
    main_brand,
    COUNT(*) AS total_orders,
    SUM(total_quantity) AS units_sold,
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders
GROUP BY main_brand
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 11: Average order value by category
SELECT
    main_category,
    COUNT(*) AS total_orders,
    ROUND(AVG(net_amount), 2) AS avg_order_value
FROM ecommerce_orders
GROUP BY main_category
ORDER BY avg_order_value DESC;

---------------------------------------------------------------------------------------------

-- Query 12: Orders and revenue by gender
SELECT
    gender,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_amount), 2) AS total_revenue,
    ROUND(AVG(net_amount), 2) AS avg_order_value
FROM ecommerce_orders
GROUP BY gender
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 13: Orders and revenue by age group
SELECT
    CASE
        WHEN age < 25 THEN '18-24'
        WHEN age < 35 THEN '25-34'
        WHEN age < 45 THEN '35-44'
        WHEN age < 55 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_amount), 2) AS total_revenue,
    ROUND(AVG(net_amount), 2) AS avg_order_value
FROM ecommerce_orders
GROUP BY
    CASE
        WHEN age < 25 THEN '18-24'
        WHEN age < 35 THEN '25-34'
        WHEN age < 45 THEN '35-44'
        WHEN age < 55 THEN '45-54'
        ELSE '55+'
    END
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 14: Orders and revenue by loyalty tier
SELECT
    loyalty_tier,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_amount), 2) AS total_revenue,
    ROUND(AVG(net_amount), 2) AS avg_order_value
FROM ecommerce_orders
GROUP BY loyalty_tier
ORDER BY avg_order_value DESC;

---------------------------------------------------------------------------------------------

-- Query 15: Orders and revenue by acquisition channel
SELECT
    acquisition_channel,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders
GROUP BY acquisition_channel
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 16: Share of orders by payment method (%)
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecommerce_orders),
        2
    ) AS order_percentage
FROM ecommerce_orders
GROUP BY payment_method
ORDER BY total_orders DESC;

---------------------------------------------------------------------------------------------

-- Query 17: Orders and revenue by device
SELECT
    device,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_amount), 2) AS total_revenue,
    ROUND(AVG(net_amount), 2) AS avg_order_value
FROM ecommerce_orders
GROUP BY device
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 18:  Cancellation rate and return rate
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        AS cancelled_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        AS returned_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS cancellation_rate_pct,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS return_rate_pct
FROM ecommerce_orders;

---------------------------------------------------------------------------------------------

-- Query 19:  Average delivery days by order status
SELECT
    order_status,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    COUNT(*) AS total_orders
FROM ecommerce_orders
GROUP BY order_status
ORDER BY avg_delivery_days;

---------------------------------------------------------------------------------------------

-- Query 20: Orders and revenue by state
SELECT
    state,
    COUNT(*) AS total_orders,
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders
GROUP BY state
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 21: Coupon vs non-coupon orders (discount, AOV, revenue)
SELECT
    coupon_used,
    COUNT(*) AS total_orders,
    ROUND(AVG(discount_pct), 2) AS avg_discount_pct,
    ROUND(AVG(net_amount), 2) AS avg_order_value,
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders
GROUP BY coupon_used
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 22: Performance by discount group
SELECT
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct <= 10 THEN 'Low Discount'
        WHEN discount_pct <= 20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_group,
    COUNT(*) AS total_orders,
    ROUND(AVG(net_amount), 2) AS avg_order_value,
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders
GROUP BY
    CASE
        WHEN discount_pct = 0 THEN 'No Discount'
        WHEN discount_pct <= 10 THEN 'Low Discount'
        WHEN discount_pct <= 20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY total_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 23: Competitor price vs our average order value by category
SELECT
    main_category,
    ROUND(AVG(avg_competitor_price), 2) AS avg_competitor_price,
    ROUND(AVG(net_amount), 2) AS avg_net_amount
FROM ecommerce_orders
GROUP BY main_category
ORDER BY avg_competitor_price DESC;

---------------------------------------------------------------------------------------------

-- Query 24: Monthly market growth, industry ad spend and revenue
SELECT
    order_month,
    ROUND(AVG(market_growth_pct), 2) AS avg_market_growth_pct,
    ROUND(AVG(industry_ad_spend_cr), 2) AS avg_ad_spend_cr,
    ROUND(SUM(net_amount), 2) AS total_revenue
FROM ecommerce_orders
GROUP BY order_month
ORDER BY order_month;

---------------------------------------------------------------------------------------------

-- Query 25: Rank categories by revenue (DENSE_RANK)
SELECT
    main_category,
    ROUND(SUM(net_amount), 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(net_amount) DESC
    ) AS revenue_rank
FROM ecommerce_orders
GROUP BY main_category;

---------------------------------------------------------------------------------------------

-- Query 26: Top 3 brands by revenue (CTE + DENSE_RANK)
WITH brand_revenue AS (
    SELECT
        main_brand,
        ROUND(SUM(net_amount), 2) AS total_revenue
    FROM ecommerce_orders
    GROUP BY main_brand
),
ranked_brands AS (
    SELECT
        main_brand,
        total_revenue,
        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS revenue_rank
    FROM brand_revenue
)
SELECT *
FROM ranked_brands
WHERE revenue_rank <= 3
ORDER BY revenue_rank;

---------------------------------------------------------------------------------------------

-- Query 27: Month-over-month revenue growth % (CTE + LAG)
WITH monthly_revenue AS (
    SELECT
        order_month,
        SUM(net_amount) AS revenue
    FROM ecommerce_orders
    GROUP BY order_month
),
monthly_comparison AS (
    SELECT
        order_month,
        revenue,
        LAG(revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    order_month,
    ROUND(revenue, 2) AS current_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        100.0 * (revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_pct
FROM monthly_comparison
ORDER BY order_month;

---------------------------------------------------------------------------------------------

-- Query 28: All orders above the average order value (subquery)
SELECT *
FROM ecommerce_orders
WHERE net_amount > (
    SELECT AVG(net_amount)
    FROM ecommerce_orders
)
ORDER BY net_amount DESC;

---------------------------------------------------------------------------------------------

-- Query 29: Each category's contribution to total revenue (%)
SELECT
    main_category,
    ROUND(SUM(net_amount), 2) AS category_revenue,
    ROUND(
        100.0 * SUM(net_amount)
        / (SELECT SUM(net_amount) FROM ecommerce_orders),
        2
    ) AS revenue_contribution_pct
FROM ecommerce_orders
GROUP BY main_category
ORDER BY category_revenue DESC;

---------------------------------------------------------------------------------------------

-- Query 30: Top 20 highest-value orders above average
SELECT
    order_id,
    customer_id,
    order_month,
    main_category,
    net_amount
FROM ecommerce_orders
WHERE net_amount > (
    SELECT AVG(net_amount)
    FROM ecommerce_orders
)
ORDER BY net_amount DESC
LIMIT 20;