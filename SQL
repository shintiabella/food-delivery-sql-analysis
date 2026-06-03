-- ============================================================
-- FOOD DELIVERY SQL ANALYSIS
-- ============================================================
-- Tools: PostgreSQL
-- Dataset:
--   - customers_medium
--   - orders_medium
--   - order_items
--   - restaurants
--   - menu_items
-- ============================================================


-- ============================================================
-- Question 1: Total Orders
-- ============================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders_medium;


-- ============================================================
-- Question 2: Total Revenue
-- ============================================================

SELECT
    ROUND(SUM(quantity * price), 2) AS total_revenue
FROM order_items;


-- ============================================================
-- Question 3: Average Order Value (AOV)
-- ============================================================

SELECT
    ROUND(
        SUM(quantity * price)
        / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;


-- ============================================================
-- Question 4: Top 5 Restaurants by Revenue
-- ============================================================

SELECT
    r.restaurant_id,
    r.cuisine,
    r.city,
    ROUND(
        SUM(oi.quantity * oi.price),
        2
    ) AS total_revenue
FROM restaurants r
JOIN orders_medium om
    ON r.restaurant_id = om.restaurant_id
JOIN order_items oi
    ON om.order_id = oi.order_id
GROUP BY
    r.restaurant_id,
    r.cuisine,
    r.city
ORDER BY total_revenue DESC
LIMIT 5;


-- ============================================================
-- Question 5: Monthly Order Trend
-- ============================================================

SELECT
    TO_CHAR(
        DATE_TRUNC('month', order_time),
        'Mon YYYY'
    ) AS month_year,
    COUNT(order_id) AS total_orders
FROM orders_medium
GROUP BY DATE_TRUNC('month', order_time)
ORDER BY DATE_TRUNC('month', order_time);


-- ============================================================
-- Question 6: Monthly Revenue Trend
-- ============================================================

SELECT
    TO_CHAR(
        DATE_TRUNC('month', om.order_time),
        'Mon YYYY'
    ) AS month_year,
    ROUND(
        SUM(oi.quantity * oi.price),
        2
    ) AS total_revenue
FROM orders_medium om
JOIN order_items oi
    ON om.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', om.order_time)
ORDER BY DATE_TRUNC('month', om.order_time);


-- ============================================================
-- Question 7: Top Cuisine by Revenue
-- ============================================================

SELECT
    r.cuisine,
    ROUND(
        SUM(oi.quantity * oi.price),
        2
    ) AS total_revenue
FROM restaurants r
JOIN orders_medium om
    ON r.restaurant_id = om.restaurant_id
JOIN order_items oi
    ON om.order_id = oi.order_id
GROUP BY r.cuisine
ORDER BY total_revenue DESC;


-- ============================================================
-- Question 8: Customer Spending Analysis
-- ============================================================

SELECT
    cm.customer_id,
    cm.city,
    ROUND(
        SUM(oi.quantity * oi.price),
        2
    ) AS total_spending
FROM customers_medium cm
JOIN orders_medium om
    ON cm.customer_id = om.customer_id
JOIN order_items oi
    ON om.order_id = oi.order_id
GROUP BY
    cm.customer_id,
    cm.city
ORDER BY total_spending DESC
LIMIT 10;


-- ============================================================
-- Question 9: Order Status Distribution
-- ============================================================

SELECT
    status,
    COUNT(order_id) AS total_orders
FROM orders_medium
GROUP BY status
ORDER BY total_orders DESC;


-- ============================================================
-- Question 10: Cancellation Rate
-- ============================================================

SELECT
    COUNT(
        CASE
            WHEN status = 'Cancelled'
            THEN 1
        END
    ) AS cancelled_orders,
    COUNT(order_id) AS total_orders,
    ROUND(
        COUNT(
            CASE
                WHEN status = 'Cancelled'
                THEN 1
            END
        ) * 100.0
        / COUNT(order_id),
        2
    ) AS cancellation_rate
FROM orders_medium;


-- ============================================================
-- Question 11: Top 5 Restaurants with Highest Rating
-- ============================================================

SELECT
    restaurant_id,
    cuisine,
    city,
    rating
FROM restaurants
ORDER BY rating DESC
LIMIT 5;


-- ============================================================
-- Question 12: Revenue by City
-- ============================================================

SELECT
    r.city,
    ROUND(
        SUM(oi.quantity * oi.price),
        2
    ) AS total_revenue
FROM restaurants r
JOIN orders_medium om
    ON r.restaurant_id = om.restaurant_id
JOIN order_items oi
    ON om.order_id = oi.order_id
GROUP BY r.city
ORDER BY total_revenue DESC;


-- ============================================================
-- Question 13: Repeat Customers
-- ============================================================

SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders_medium
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;


-- ============================================================
-- Question 14: Top Selling Menu Items
-- ============================================================

SELECT
    item_id,
    SUM(quantity) AS total_quantity_sold,
    ROUND(
        SUM(quantity * price),
        2
    ) AS total_revenue
FROM order_items
GROUP BY item_id
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- ============================================================
-- Question 15: Customer Signup Trend
-- ============================================================

SELECT
    TO_CHAR(
        DATE_TRUNC('month', signup_date),
        'Mon YYYY'
    ) AS month_year,
    COUNT(customer_id) AS total_new_customers
FROM customers_medium
GROUP BY DATE_TRUNC('month', signup_date)
ORDER BY DATE_TRUNC('month', signup_date);


-- ============================================================
-- Question 16: Rank Top Customers by Spending
-- ============================================================

WITH customer_spending AS (
    SELECT
        om.customer_id,
        ROUND(
            SUM(oi.quantity * oi.price),
            2
        ) AS total_spending
    FROM orders_medium om
    JOIN order_items oi
        ON om.order_id = oi.order_id
    GROUP BY om.customer_id
)

SELECT
    customer_id,
    total_spending,
    RANK() OVER (
        ORDER BY total_spending DESC
    ) AS customer_rank
FROM customer_spending;


-- ============================================================
-- Question 17: Running Monthly Revenue Total
-- ============================================================

SELECT
    TO_CHAR(
        DATE_TRUNC('month', om.order_time),
        'Mon YYYY'
    ) AS month_year,
    ROUND(
        SUM(oi.quantity * oi.price),
        2
    ) AS monthly_revenue,
    ROUND(
        SUM(
            SUM(oi.quantity * oi.price)
        ) OVER (
            ORDER BY DATE_TRUNC('month', om.order_time)
        ),
        2
    ) AS running_total_revenue
FROM orders_medium om
JOIN order_items oi
    ON om.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', om.order_time)
ORDER BY DATE_TRUNC('month', om.order_time);


-- ============================================================
-- Question 18: Restaurant Revenue Ranking
-- ============================================================

WITH restaurant_revenue AS (
    SELECT
        mi.restaurant_id,
        ROUND(
            SUM(oi.quantity * oi.price),
            2
        ) AS total_revenue
    FROM menu_items mi
    JOIN order_items oi
        ON mi.item_id = oi.item_id
    GROUP BY mi.restaurant_id
)

SELECT
    restaurant_id,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS restaurant_rank
FROM restaurant_revenue;


-- ============================================================
-- Question 19: Average Spending per Customer
-- ============================================================

WITH customer_spending AS (
    SELECT
        om.customer_id,
        COUNT(DISTINCT om.order_id) AS total_orders,
        SUM(oi.quantity * oi.price) AS total_spending
    FROM orders_medium om
    JOIN order_items oi
        ON om.order_id = oi.order_id
    GROUP BY om.customer_id
)

SELECT
    customer_id,
    ROUND(total_spending, 2) AS total_spending,
    total_orders,
    ROUND(
        total_spending / total_orders,
        2
    ) AS average_spending_per_order
FROM customer_spending
ORDER BY average_spending_per_order DESC;


-- ============================================================
-- Question 20: Delivered vs Cancelled Orders by Month
-- ============================================================

SELECT
    TO_CHAR(
        DATE_TRUNC('month', order_time),
        'Mon YYYY'
    ) AS month_year,
    COUNT(
        CASE
            WHEN status = 'Delivered'
            THEN 1
        END
    ) AS delivered_orders,
    COUNT(
        CASE
            WHEN status = 'Cancelled'
            THEN 1
        END
    ) AS cancelled_orders
FROM orders_medium
WHERE status IN ('Delivered', 'Cancelled')
GROUP BY DATE_TRUNC('month', order_time)
ORDER BY DATE_TRUNC('month', order_time);


-- ============================================================
-- Question 21: Top Customer in Each City
-- ============================================================

WITH customer_spending AS (
    SELECT
        cm.city,
        om.customer_id,
        SUM(oi.quantity * oi.price) AS total_spending
    FROM customers_medium cm
    JOIN orders_medium om
        ON cm.customer_id = om.customer_id
    JOIN order_items oi
        ON om.order_id = oi.order_id
    GROUP BY
        cm.city,
        om.customer_id
),
customer_rank AS (
    SELECT
        city,
        customer_id,
        total_spending,
        RANK() OVER (
            PARTITION BY city
            ORDER BY total_spending DESC
        ) AS city_rank
    FROM customer_spending
)

SELECT
    city,
    customer_id,
    ROUND(total_spending, 2) AS total_spending,
    city_rank
FROM customer_rank
WHERE city_rank = 1
ORDER BY city;


-- ============================================================
-- Question 22: Average Delivery Time
-- ============================================================

SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM (
                    delivery_time - order_time
                )
            ) / 60
        ),
        2
    ) AS avg_delivery_minutes
FROM orders_medium;
