
DROP TABLE IF EXISTS sales_data;

CREATE TABLE sales_data (
    transaction_id INT,
    customer_id INT,         
    product_name VARCHAR(50),
    category VARCHAR(20),
    cost_price DECIMAL(10, 2),
    sale_price DECIMAL(10, 2),
    quantity INT,
    sale_date DATE
);

INSERT INTO sales_data VALUES 
(1, 101, 'Sony WH-1000XM5', 'Electronics', 350.00, 499.00, 2, '2024-01-01'),
(2, 102, 'Silent Pilot Pillow', 'Travel', 25.00, 55.00, 10, '2024-01-02'),
(3, 101, 'USB-C Cable', 'Electronics', 2.00, 9.99, 50, '2024-01-02'),
(4, 103, 'Travel Adapter', 'Travel', 10.00, 25.00, 5, '2024-01-03'),
(5, 101, 'MacBook Air', 'Electronics', 900.00, 1200.00, 1, '2024-01-05'),
(6, 102, 'Silent Pilot Pillow', 'Travel', 25.00, 50.00, 3, '2024-01-06');

select * from (
select customer_id, product_name, sale_date, sale_price,
row_number() over (partition by customer_id order by sale_date desc) as rn
from sales_data
) sub_table
where rn = 1; 