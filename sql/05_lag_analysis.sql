select sale_date,
sum(sale_price * quantity) as daily_revenue
from sales_data
group by sale_date 
order by sale_date;

with daily_sales as(
     select sale_date,
     sum(sale_price * quantity) as daily_revenue
     from sales_data
     group by sale_date
 )
 select sale_date, daily_revenue,
        lag(daily_revenue, 1) over (order by sale_date) as prev_day_revenue,
        daily_revenue - lag(daily_revenue, 1) over (order by sale_date) as revenue_diff,
        ROUND(
        (daily_revenue - LAG(daily_revenue, 1) OVER (ORDER BY sale_date)) 
        / LAG(daily_revenue, 1) OVER (ORDER BY sale_date) * 100
    , 2) as growth_rate_pct
 from daily_sales
 order by sale_date;
                