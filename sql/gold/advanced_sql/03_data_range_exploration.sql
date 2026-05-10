/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), AGE(), EXTRACT(), CURRENT_DATE
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
-- Note: We extract years and months from the AGE() interval and calculate the total months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 + 
    EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS order_range_months
FROM gold.fact_sales;

-- Find the youngest and oldest customer based on birthdate
-- Note: AGE(CURRENT_DATE, date) calculates the interval, and EXTRACT pulls just the years
SELECT
    MIN(birthdate) AS oldest_birthdate,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(birthdate))) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, MAX(birthdate))) AS youngest_age
FROM gold.dim_customers;