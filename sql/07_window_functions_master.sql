/*
-------------------------------------------------------------------------
PROJECT: Pricing Analytics - Window Functions Master Sheet
AUTHOR: Aiden
DATE: 2025-12-20
DESCRIPTION: 
This script consolidates key SQL window functions used for time-series 
analysis and customer behavior modeling.

KEY CONCEPTS:
1. ROW_NUMBER: For Recency analysis (finding the latest record).
2. DENSE_RANK: For Ranking (finding top sellers).
3. LAG: For Growth Rate (comparing with previous periods).
4. LEAD: For Churn Prediction (forecasting next purchase).
-------------------------------------------------------------------------
*/

-- ======================================================================
-- SECTION 1: CUSTOMER RECENCY (ROW_NUMBER)
-- Business Question: What was the last item purchased by each customer?
-- Technical Choice: Used ROW_NUMBER() because we need a unique latest record 
-- for each customer, even if they bought multiple items on the same day.
-- ======================================================================

select * from (
 select customer_id, product_name, sale_date,
 -- Assign rank 1 to the most recent purchase
 row_number() over (partition by customer_id order by sale_date DESC) as rn
 from sales_data
 ) latest_transactions
 where rn = 1
 
 -- ======================================================================
-- SECTION 2: BEST SELLERS RANKING (DENSE_RANK)
-- Business Question: What are the top 3 best-selling products in each category?
-- Technical Choice: Used DENSE_RANK() to handle ties. If two products sell 
-- equally well, they should both be #1, and the next should be #2.
-- ======================================================================
 
SELECT * FROM (
    SELECT category, product_name, quantity,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY quantity DESC) as rk
    FROM sales_data
) rankings
WHERE rk <= 3;

-- ======================================================================
-- SECTION 3: REVENUE GROWTH (LAG)
-- Business Question: What is the day-over-day revenue growth rate?
-- Technical Choice: Used LAG() to access the previous row's data without 
-- needing a complex Self-Join.
-- ======================================================================

WITH daily_sales AS (
    SELECT 
        sale_date, 
        SUM(sale_price * quantity) as daily_revenue
    FROM sales_data
    GROUP BY sale_date
)
SELECT 
    sale_date,
    daily_revenue,
    LAG(daily_revenue, 1) OVER (ORDER BY sale_date) as prev_revenue,
    -- Growth Calculation: (Current - Previous) / Previous
    ROUND(
        (daily_revenue - LAG(daily_revenue, 1) OVER (ORDER BY sale_date)) 
        / NULLIF(LAG(daily_revenue, 1) OVER (ORDER BY sale_date), 0) * 100
    , 2) as growth_pct
FROM daily_sales;

-- ======================================================================
-- SECTION 4: CHURN RISK (LEAD)
-- Business Question: How many days elapse between customer orders?
-- Technical Choice: Used LEAD() to "look ahead" at the next transaction date.
-- Null values in 'next_order_date' indicate a potential churned customer.
-- ======================================================================

SELECT 
    customer_id,
    sale_date,
    LEAD(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) as next_order_date,
    -- Calculate gap
    LEAD(sale_date) OVER (PARTITION BY customer_id ORDER BY sale_date) - sale_date as days_gap
FROM sales_data;
 