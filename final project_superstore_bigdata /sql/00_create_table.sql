-- =====================================================
-- Superstore Database Schema
-- =====================================================
-- This script creates the main table for the Superstore dataset
-- Designed for local PostgreSQL installation
-- =====================================================

-- Drop existing table if it exists (for clean setup)
DROP TABLE IF EXISTS superstore;

-- Create the main superstore table with proper data types
-- Column names match the actual CSV file structure
CREATE TABLE superstore (
    -- Primary key and order identification
    "Row ID" SERIAL PRIMARY KEY,                    -- Unique row identifier
    "Order ID" VARCHAR(20) NOT NULL,               -- Order identification number
    
    -- Date fields (will be parsed as dates)
    "Order Date" DATE NOT NULL,                    -- Date when order was placed
    "Ship Date" DATE NOT NULL,                     -- Date when order was shipped
    
    -- Shipping information
    "Ship Mode" VARCHAR(50) NOT NULL,              -- Shipping method used
    
    -- Customer information
    "Customer ID" VARCHAR(20) NOT NULL,            -- Unique customer identifier
    "Customer Name" VARCHAR(100) NOT NULL,         -- Customer full name
    "Segment" VARCHAR(50) NOT NULL,                -- Customer segment (Consumer, Corporate, Home Office)
    
    -- Geographic information
    "Country" VARCHAR(50) NOT NULL,                -- Country of customer
    "City" VARCHAR(50) NOT NULL,                   -- City of customer
    "State" VARCHAR(50) NOT NULL,                  -- State/Province of customer
    "Postal Code" VARCHAR(20) NOT NULL,            -- Postal/ZIP code
    "Region" VARCHAR(50) NOT NULL,                 -- Sales region
    
    -- Product information
    "Product ID" VARCHAR(50) NOT NULL,             -- Unique product identifier
    "Category" VARCHAR(50) NOT NULL,               -- Product category (Furniture, Office Supplies, Technology)
    "Sub-Category" VARCHAR(50) NOT NULL,           -- Product sub-category
    "Product Name" VARCHAR(255) NOT NULL,          -- Product full name
    
    -- Financial metrics
    "Sales" NUMERIC(10,2) NOT NULL,                -- Total sales amount
    "Quantity" INTEGER NOT NULL,                   -- Quantity sold
    "Discount" NUMERIC(5,4) NOT NULL,              -- Discount percentage (0.00 to 1.00)
    "Profit" NUMERIC(10,2) NOT NULL                -- Profit amount
);

-- Create indexes for better query performance
-- These indexes will speed up common analytical queries
CREATE INDEX idx_superstore_order_date ON superstore("Order Date");
CREATE INDEX idx_superstore_customer_id ON superstore("Customer ID");
CREATE INDEX idx_superstore_product_id ON superstore("Product ID");
CREATE INDEX idx_superstore_category ON superstore("Category");
CREATE INDEX idx_superstore_region ON superstore("Region");
CREATE INDEX idx_superstore_state ON superstore("State");

-- Add comments for documentation
COMMENT ON TABLE superstore IS 'Main table containing Superstore retail transaction data';
COMMENT ON COLUMN superstore."Row ID" IS 'Auto-incrementing primary key for each transaction record';
COMMENT ON COLUMN superstore."Order ID" IS 'Unique identifier for each order (may contain multiple products)';
COMMENT ON COLUMN superstore."Order Date" IS 'Date when the order was placed by the customer';
COMMENT ON COLUMN superstore."Ship Date" IS 'Date when the order was shipped from warehouse';
COMMENT ON COLUMN superstore."Ship Mode" IS 'Shipping method: Standard Class, Second Class, First Class, Same Day';
COMMENT ON COLUMN superstore."Customer ID" IS 'Unique identifier for each customer';
COMMENT ON COLUMN superstore."Customer Name" IS 'Full name of the customer';
COMMENT ON COLUMN superstore."Segment" IS 'Customer segment: Consumer, Corporate, or Home Office';
COMMENT ON COLUMN superstore."Country" IS 'Country where the customer is located';
COMMENT ON COLUMN superstore."City" IS 'City where the customer is located';
COMMENT ON COLUMN superstore."State" IS 'State/Province where the customer is located';
COMMENT ON COLUMN superstore."Postal Code" IS 'Postal/ZIP code of customer location';
COMMENT ON COLUMN superstore."Region" IS 'Sales region: Central, East, South, West';
COMMENT ON COLUMN superstore."Product ID" IS 'Unique identifier for each product';
COMMENT ON COLUMN superstore."Category" IS 'Product category: Furniture, Office Supplies, Technology';
COMMENT ON COLUMN superstore."Sub-Category" IS 'Product sub-category within main category';
COMMENT ON COLUMN superstore."Product Name" IS 'Full name/description of the product';
COMMENT ON COLUMN superstore."Sales" IS 'Total sales amount for this transaction line';
COMMENT ON COLUMN superstore."Quantity" IS 'Number of units sold in this transaction';
COMMENT ON COLUMN superstore."Discount" IS 'Discount percentage applied (0.00 = no discount, 1.00 = 100% discount)';
COMMENT ON COLUMN superstore."Profit" IS 'Profit amount for this transaction line';

-- Display table creation confirmation
SELECT 'Superstore table created successfully with indexes and comments' AS status;
