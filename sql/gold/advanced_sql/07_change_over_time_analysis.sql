/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: EXTRACT(), DATE_TRUNC(), TO_CHAR()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyze sales performance over time
-- Quick Date Functions using EXTRACT()
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date);

-- DATE_TRUNC()
-- Note: In PostgreSQL, the date part ('month') must be enclosed in single quotes.
SELECT
    DATE_TRUNC('month', order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);

-- TO_CHAR() (Equivalent to FORMAT in SQL Server)
-- Note: Replaced FORMAT() with TO_CHAR(). 
-- Also changed the ORDER BY to use MIN(order_date) to ensure chronological sorting, 
-- otherwise '2023-Apr' would sort alphabetically before '2023-Jan'.
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_date_formatted,
    SUM(sales_amount) AS total_sales,
    COUNT