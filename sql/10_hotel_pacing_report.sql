-- =============================================
-- File: 10_hotel_pacing_report.sql
-- Topic: Strategic Revenue Science - Day 02
-- Business Goal: Reconstruct historical booking curves (Pacing) from transaction logs
-- Technical Skill: Advanced SQL Window Functions (SUM OVER)
-- =============================================

CREATE OR REPLACE VIEW v_hotel_pacing AS
WITH Raw_Dates AS (
    SELECT 
        hotel,
        is_canceled,
        lead_time,
        TO_DATE(
            CAST(arrival_date_year AS TEXT) || '-' || arrival_date_month || '-' || CAST(arrival_date_day_of_month AS TEXT),
            'YYYY-Month-DD'
        ) AS stay_date
    FROM hotel_bookings
)
SELECT 
    hotel,
    stay_date,
    lead_time,
    (stay_date - (lead_time || ' days')::interval)::date AS booking_date,
    is_canceled,
    1 AS room_nights
FROM Raw_Dates;

-- ---------------------------------------------

WITH Daily_Pickup AS (
    SELECT 
        stay_date,
        lead_time,
        SUM(room_nights) AS pickup 
    FROM v_hotel_pacing
    WHERE is_canceled = 0         
      AND hotel = 'Resort Hotel'
    GROUP BY stay_date, lead_time
),
Cumulative_Curve AS (
    SELECT 
        stay_date,
        lead_time,
        pickup,
        SUM(pickup) OVER (
            PARTITION BY stay_date 
            ORDER BY lead_time DESC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS otb_rooms
    FROM Daily_Pickup
)

SELECT * FROM Cumulative_Curve
WHERE stay_date = '2016-08-15' 
  AND lead_time <= 100 
ORDER BY lead_time DESC;