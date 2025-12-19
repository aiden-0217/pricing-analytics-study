DROP TABLE IF EXISTS sales_data;

CREATE TABLE sales_data (
    transaction_id INT,
    product_name VARCHAR(50),
    category VARCHAR(20),
    cost_price DECIMAL(10, 2),
    sale_price DECIMAL(10, 2),
    quantity INT,
    sale_date DATE
);

INSERT INTO sales_data VALUES 
(1, 'Sony WH-1000XM5', 'Electronics', 350.00, 499.00, 2, '2024-01-01'),
(2, 'Silent Pilot Pillow', 'Travel', 25.00, 55.00, 10, '2024-01-02'),
(3, 'USB-C Cable', 'Electronics', 2.00, 9.99, 50, '2024-01-02'),
(4, 'Travel Adapter', 'Travel', 10.00, 25.00, 5, '2024-01-03'),
(5, 'MacBook Air', 'Electronics', 900.00, 1200.00, 1, '2024-01-05'),
(6, 'Silent Pilot Pillow', 'Travel', 25.00, 50.00, 3, '2024-01-06'),
(7, 'Sony WH-1000XM5', 'Electronics', 350.00, 499.00, 1, '2024-01-07');

SELECT * FROM sales_data;

-- GROUP BY
select category,
AVG(sale_price) as avg_price
from sales_data
group by category;

-- OVER PARTITION BY
select product_name,
category,
sale_price,
avg(sale_price) over (partition by category) as avg_category_price,
sale_price - AVG(sale_price) over (partition by category) as diff_from_avg
from sales_data;