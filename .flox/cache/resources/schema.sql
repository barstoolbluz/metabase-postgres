-- Iowa Liquor Sales Import Script
-- Usage: psql -d your_database_name -f this_script_file.sql

-- Drop table if it exists already (comment this out if you want to keep existing data)
DROP TABLE IF EXISTS iowa_liquor_sales;

-- Create the table with appropriate data types
CREATE TABLE iowa_liquor_sales (
    invoice_item_number VARCHAR(50),
    date VARCHAR(50),  -- Using VARCHAR initially to avoid date format issues
    store_number INTEGER,
    store_name VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(50),
    zip_code VARCHAR(10),
    store_location VARCHAR(100),
    county_number FLOAT,
    county VARCHAR(50),
    category INTEGER,
    category_name VARCHAR(100),
    vendor_number INTEGER,
    vendor_name VARCHAR(100),
    item_number INTEGER,
    item_description VARCHAR(200),
    pack INTEGER,
    bottle_volume_ml INTEGER,
    state_bottle_cost NUMERIC(10,2),
    state_bottle_retail NUMERIC(10,2),
    bottles_sold INTEGER,
    sale_dollars NUMERIC(10,2),
    volume_sold_liters NUMERIC(10,2),
    volume_sold_gallons NUMERIC(10,2)
);

-- Performance optimization: disable logging temporarily
ALTER TABLE iowa_liquor_sales SET UNLOGGED;

-- Note: You need to replace '/path/to/your/iowa_file.csv' with the actual file path
\echo 'Starting data import...'
\copy iowa_liquor_sales FROM './iowa_liquor_sales.csv' WITH CSV HEADER;
\echo 'Data import completed'

-- Convert date string to actual DATE type (if needed)
ALTER TABLE iowa_liquor_sales ADD COLUMN date_formatted DATE;
UPDATE iowa_liquor_sales SET date_formatted = TO_DATE(date, 'MM/DD/YYYY');  -- Adjust format if necessary
ALTER TABLE iowa_liquor_sales DROP COLUMN date;
ALTER TABLE iowa_liquor_sales RENAME COLUMN date_formatted TO date;

-- Re-enable logging
ALTER TABLE iowa_liquor_sales SET LOGGED;

-- Create indexes for better query performance
\echo 'Creating indexes...'
CREATE INDEX idx_iowa_date ON iowa_liquor_sales(date);
CREATE INDEX idx_iowa_store ON iowa_liquor_sales(store_number);
CREATE INDEX idx_iowa_item ON iowa_liquor_sales(item_number);
CREATE INDEX idx_iowa_county ON iowa_liquor_sales(county);
\echo 'Indexes created'

-- Run ANALYZE to update statistics
ANALYZE iowa_liquor_sales;

\echo 'Import process completed successfully'
