-- Insert two new records to simulate "tied sales" scenarios
-- 1. Insert a Webcam, quantity 50 (tied with the existing USB Cable)
INSERT INTO sales_data VALUES 
(8, 104, 'Logitech Webcam', 'Electronics', 80.00, 120.00, 50, '2024-01-08');

-- 2. Insert Earbuds, quantity 50 (continuing the tie)
INSERT INTO sales_data VALUES 
(9, 105, 'Samsung Buds', 'Electronics', 100.00, 150.00, 50, '2024-01-09');

/*
Difference between RANK vs DENSE_RANK:
Hypothetical Scenario: Three students have scores: 100, 100, 90.

1. RANK() -> "Skips numbers" (Gaps in ranking)
   Result: 1, 1, 3 
   (Two 1st places occupy two spots, so the next person becomes 3rd).

2. DENSE_RANK() -> "No skipping" (Dense = Compact)
   Result: 1, 1, 2
   (Regardless of how many 1st places exist, the next person is ranked 2nd).
*/

-- Day 17: Compare two ranking methods
SELECT 
    category,
    product_name,
    quantity,
    -- Method 1: Standard Rank (with gaps)
    RANK() OVER (PARTITION BY category ORDER BY quantity DESC) as ranking_skipped,
    -- Method 2: Dense Rank (no gaps - usually better for business reports)
    DENSE_RANK() OVER (PARTITION BY category ORDER BY quantity DESC) as ranking_dense
FROM sales_data
WHERE category = 'Electronics' -- Filter for 'Electronics' only for demonstration
ORDER BY quantity DESC;

-- Practice: Extract the Top 3 Best-selling Products per Category
SELECT * FROM (
    SELECT 
        category,
        product_name,
        quantity,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY quantity DESC) as rk
    FROM sales_data
) t
WHERE rk <= 3;