select customer_id,
sale_date as current_order_date,
product_name,
-- categorl by customer id
lead(sale_date) over (partition by customer_id order by sale_date) as next_order_date,
-- calculate the time between orders
lead(sale_date) over (partition by customer_id order by sale_date) - sale_date as days_since_last_order
from sales_data
order by customer_id, sale_date;