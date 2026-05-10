/*
=============================================================
Create Database (Step 1)
=============================================================
WARNING:
    Running this script will drop the 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted.
*/

-- 1. Terminate any active connections to the database (Equivalent to SET SINGLE_USER)
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'DataWarehouse' AND pid <> pg_backend_pid();

-- 2. Drop the database if it exists
DROP DATABASE IF EXISTS "DataWarehouse";

-- 3. Create the new database
CREATE DATABASE "DataWarehouse";


/*
=============================================================
Create Schemas (Step 2)
=============================================================
Script Purpose:
    Sets up the three layered schemas within the active database.
*/

CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;