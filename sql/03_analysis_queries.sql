USE urbannest_retail;

-- =========================================================
-- 01. BASIC KPIs
-- Concepts: SELECT, COUNT, COUNT DISTINCT, SUM, AVG, ROUND, WHERE
-- =========================================================
SELECT
 COUNT(*) AS total_orders,
 COUNT(DISTINCT customer_id) AS unique_customers,
 ROUND(SUM(order_total), 2) AS total_revenue,
 ROUND(AVG(order_total), 2) AS average_order_value
FROM orders
WHERE order_status <> 'Cancelled';

-- =========================================================
-- 02. HIGH-VALUE ORDERS
-- Concepts: WHERE, AND, ORDER BY, LIMIT
-- =========================================================
SELECT
 order_id,
 customer_id,
 order_date,
 order_total
FROM orders
WHERE order_status <> 'Cancelled'
 AND order_total >= 5000
ORDER BY order_total DESC
LIMIT 10;

-- =========================================================
-- 03. MONTHLY ORDER TREND
-- Concepts: DATE_FORMAT, GROUP BY, ORDER BY
-- =========================================================
SELECT
 DATE_FORMAT(order_date, '%Y-%m') AS order_month,
 COUNT(*) AS order_count,
 ROUND(SUM(order_total), 2) AS monthly_revenue
FROM orders
WHERE order_status <> 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;

-- =========================================================
-- 04. CATEGORY PERFORMANCE
-- Concepts: JOIN, GROUP BY, SUM, aggregate functions
-- =========================================================
SELECT
 p.category,
 SUM(oi.quantity) AS units_sold,
 ROUND(SUM(oi.quantity * oi.unit_price), 2) AS category_revenue
FROM order_items oi
JOIN products p
 ON oi.product_id = p.product_id
JOIN orders o
 ON oi.order_id = o.order_id
WHERE o.order_status <> 'Cancelled'
GROUP BY p.category
ORDER BY category_revenue DESC;

-- =========================================================
-- 05. REPEAT / HIGH-VALUE CUSTOMERS
-- Concepts: JOIN, GROUP BY, HAVING
-- =========================================================
SELECT
 c.customer_id,
 c.customer_name,
 COUNT(o.order_id) AS order_count,
 ROUND(SUM(o.order_total), 2) AS customer_revenue
FROM customers c
JOIN orders o
 ON c.customer_id = o.customer_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2
ORDER BY customer_revenue DESC;

-- =========================================================
-- 06. CUSTOMER SEGMENTATION
-- Concepts: CASE WHEN, JOIN, GROUP BY
-- =========================================================
SELECT
 c.customer_id,
 c.customer_name,
 ROUND(SUM(o.order_total), 2) AS total_spend,
 CASE
 WHEN SUM(o.order_total) >= 10000 THEN 'High Value'
 WHEN SUM(o.order_total) >= 5000 THEN 'Medium Value'
 ELSE 'Standard'
 END AS customer_segment
FROM customers c
JOIN orders o
 ON c.customer_id = o.customer_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spend DESC;

-- =========================================================
-- 07. CITY-WISE PERFORMANCE
-- Concepts: JOIN, GROUP BY, COUNT, SUM
-- =========================================================
SELECT
 c.city,
 c.state,
 COUNT(o.order_id) AS total_orders,
 ROUND(SUM(o.order_total), 2) AS revenue
FROM customers c
JOIN orders o
 ON c.customer_id = o.customer_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.city, c.state
ORDER BY revenue DESC;

-- =========================================================
-- 08. PAYMENT METHOD ANALYSIS
-- Concepts: GROUP BY, COUNT, SUM, AVG
-- =========================================================
SELECT
 payment_method,
 COUNT(*) AS payment_count,
 ROUND(SUM(amount), 2) AS payment_value,
 ROUND(AVG(amount), 2) AS average_payment
FROM payments
WHERE payment_status = 'Paid'
GROUP BY payment_method
ORDER BY payment_value DESC;

-- =========================================================
-- 09. ORDER STATUS & CANCELLATION RATE
-- Concepts: conditional aggregation, CASE
-- =========================================================
SELECT
 COUNT(*) AS total_orders,
 SUM(CASE WHEN order_status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
 SUM(CASE WHEN order_status = 'Shipped' THEN 1 ELSE 0 END) AS shipped_orders,
 SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS pending_orders,
 SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
 ROUND(
 100 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
 / COUNT(*),
 2
 ) AS cancellation_rate_pct
FROM orders;

-- =========================================================
-- 10. ORDERS ABOVE AVERAGE
-- Concepts: scalar subquery
-- =========================================================
SELECT
 order_id,
 customer_id,
 order_date,
 order_total
FROM orders
WHERE order_status <> 'Cancelled'
 AND order_total > (
 SELECT AVG(order_total)
 FROM orders
 WHERE order_status <> 'Cancelled'
 )
ORDER BY order_total DESC;

-- =========================================================
-- 11. TOP 5 CUSTOMERS
-- Concepts: CTE, GROUP BY, JOIN, ORDER BY, LIMIT
-- =========================================================
WITH customer_revenue AS (
 SELECT
 c.customer_id,
 c.customer_name,
 ROUND(SUM(o.order_total), 2) AS revenue
 FROM customers c
 JOIN orders o
 ON c.customer_id = o.customer_id
 WHERE o.order_status <> 'Cancelled'
 GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM customer_revenue
ORDER BY revenue DESC
LIMIT 5;

-- =========================================================
-- 12. PRODUCT RANKING WITHIN CATEGORY
-- Concepts: CTE, RANK(), PARTITION BY, window function
-- =========================================================
WITH product_sales AS (
 SELECT
 p.product_id,
 p.product_name,
 p.category,
 ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
 FROM products p
 JOIN order_items oi
 ON p.product_id = oi.product_id
 JOIN orders o
 ON oi.order_id = o.order_id
 WHERE o.order_status <> 'Cancelled'
 GROUP BY p.product_id, p.product_name, p.category
)
SELECT
 product_id,
 product_name,
 category,
 revenue,
 RANK() OVER (
 PARTITION BY category
 ORDER BY revenue DESC
 ) AS category_rank
FROM product_sales
ORDER BY category, category_rank;

-- =========================================================
-- 13. MONTH-OVER-MONTH REVENUE GROWTH
-- Concepts: CTE, LAG(), window function, NULLIF, date functions
-- =========================================================
WITH monthly_sales AS (
 SELECT
 DATE_FORMAT(order_date, '%Y-%m') AS order_month,
 SUM(order_total) AS revenue
 FROM orders
 WHERE order_status <> 'Cancelled'
 GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
monthly_with_previous AS (
 SELECT
 order_month,
 revenue,
 LAG(revenue) OVER (
 ORDER BY order_month
 ) AS previous_month_revenue
 FROM monthly_sales
)
SELECT
 order_month,
 ROUND(revenue, 2) AS revenue,
 ROUND(previous_month_revenue, 2) AS previous_month_revenue,
 ROUND(
 100 * (revenue - previous_month_revenue)
 / NULLIF(previous_month_revenue, 0),
 2
 ) AS mom_growth_pct
FROM monthly_with_previous
ORDER BY order_month;

-- =========================================================
-- 14. DATA QUALITY CHECKS
-- Concepts: LEFT JOIN, UNION ALL, validation logic
-- =========================================================
SELECT
 'Missing Customer Reference' AS issue_type,
 CAST(o.order_id AS CHAR) AS record_id
FROM orders o
LEFT JOIN customers c
 ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
 'Missing Product Reference' AS issue_type,
 CAST(oi.order_id AS CHAR) AS record_id
FROM order_items oi
LEFT JOIN products p
 ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT
 'Negative Order Total' AS issue_type,
 CAST(order_id AS CHAR) AS record_id
FROM orders
WHERE order_total < 0;

-- =========================================================
-- 15. PAYMENT VS ORDER VALIDATION
-- Concepts: JOIN, comparison logic, ABS
-- =========================================================
SELECT
 o.order_id,
 o.order_total,
 p.amount AS payment_amount,
 ROUND(o.order_total - p.amount, 2) AS amount_difference
FROM orders o
JOIN payments p
 ON o.order_id = p.order_id
WHERE o.order_status <> 'Cancelled'
 AND ABS(o.order_total - p.amount) > 0.01
ORDER BY ABS(o.order_total - p.amount) DESC;
