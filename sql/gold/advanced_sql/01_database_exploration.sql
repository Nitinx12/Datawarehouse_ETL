/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - information_schema.tables
    - information_schema.columns
===============================================================================
*/

-- Retrieve a list of all user-defined tables in the database
-- Filtered out 'pg_catalog' and 'information_schema' to hide Postgres system tables
SELECT 
    table_catalog, 
    table_schema, 
    table_name, 
    table_type
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

-- Retrieve all columns for a specific table (dim_customers)
-- Added table_schema = 'public' filter (best practice in Postgres to avoid cross-schema duplicates)
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    character_maximum_length
FROM information_schema.columns
WHERE table_name = 'dim_customers'
  AND table_schema = 'public';