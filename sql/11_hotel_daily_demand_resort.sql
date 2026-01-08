-- =============================================
-- File: 1.04_daily_demand.sql
-- to obtain the data we need used in Prophet model
-- =============================================

SELECT 
    TO_DATE(
        CAST(arrival_date_year AS TEXT) || '-' || arrival_date_month || '-' || CAST(arrival_date_day_of_month AS TEXT),
        'YYYY-Month-DD'
    ) AS arrival_date,
    COUNT(*) AS daily_bookings,
    ROUND(AVG(adr), 2) AS avg_price
FROM hotel_bookings
WHERE is_canceled = 0          
  AND hotel = 'Resort Hotel'   
GROUP BY 
    arrival_date_year, 
    arrival_date_month, 
    arrival_date_day_of_month
ORDER BY arrival_date;