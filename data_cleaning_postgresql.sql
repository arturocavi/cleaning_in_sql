/*
Cleaning Data in SQL Queries Project
 Nashville Housing Data
 PostgreSQL Version
*/

---------------------------------------------------------------------------------------------------------------
-- Append Tables
CREATE TABLE nashville_housing AS
SELECT * FROM nashville_housing_2013
UNION ALL
SELECT * FROM nashville_housing_2014
UNION ALL
SELECT * FROM nashville_housing_2015
UNION ALL
SELECT * FROM nashville_housing_2016;


-- View Data
SELECT *
FROM nashville_housing;




---------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

-- Convert Sale Date column to date format
ALTER TABLE nashville_housing
ALTER COLUMN sale_date TYPE DATE;




---------------------------------------------------------------------------------------------------------------
-- Populate Property Address Data

-- Missing Addresses
SELECT
	unique_id,
	property_address
FROM nashville_housing
WHERE property_address IS NULL
ORDER BY unique_id


-- Checking that properties with null values have the same parcel identifier as other properties with address
WITH no_address AS(
	SELECT parcel_id
	FROM nashville_housing
	WHERE property_address IS NULL
)

SELECT *
FROM nashville_housing
WHERE parcel_id IN (SELECT parcel_id FROM no_address)
ORDER BY parcel_id, property_address DESC;


-- Self-Join table where Parcel ID is the same but is not the same Unique ID and Property Address is null
SELECT
	a.parcel_id,
	a.unique_id,
	a.property_address property_address_a,
	b.property_address property_address_b
FROM nashville_housing a
JOIN nashville_housing b
ON a.parcel_id = b.parcel_id
AND a.unique_id <> b.unique_id
WHERE a.property_address IS NULL
ORDER BY a.unique_id;


-- Replace null Property Address values 
UPDATE nashville_housing a
SET property_address = b.property_address
FROM nashville_housing b
WHERE a.parcel_id = b.parcel_id
AND a.unique_id <> b.unique_id
AND a.property_address IS NULL
AND b.property_address IS NOT NULL;




---------------------------------------------------------------------------------------------------------------
-- Breaking out Property Address into Individual Columns (Address & City)
-- (Single Delimiter Case)

-- View Property Address Original Format
SELECT property_address
FROM nashville_housing;


-- Split Property Address into Street and City
SELECT
	property_address,
    LEFT(property_address, POSITION(',' IN property_address) - 1) AS property_street,
    RIGHT(property_address, LENGTH(property_address) - POSITION(',' IN property_address)) AS property_city
FROM nashville_housing


-- Modify table to add these columns for Property Street
ALTER TABLE nashville_housing
ADD property_street VARCHAR(100);

UPDATE nashville_housing
SET property_street = LEFT(property_address, POSITION(',' IN property_address) - 1);


ALTER TABLE nashville_housing
ADD property_city VARCHAR(50);

UPDATE nashville_housing
SET property_city = RIGHT(property_address, LENGTH(property_address) - POSITION(',' IN property_address));


-- View Changes in Data Set
SELECT *
FROM nashville_housing;




---------------------------------------------------------------------------------------------------------------
-- Breaking out Owner Address into Individual Columns (Address, City, State)
-- (Multiple Delimiter Case)

-- View Owner Address Original Format
SELECT owner_address
FROM nashville_housing;


-- Split Owner Address into Street, City and State
SELECT
	owner_address,
	SPLIT_PART(owner_address, ',', 1) AS owner_street,
	TRIM(LEADING  ' ' FROM SPLIT_PART(owner_address, ',', 2)) AS owner_city,
	TRIM(LEADING ' ' FROM SPLIT_PART(owner_address, ',', 3)) AS owner_state
FROM nashville_housing


-- Modify table to add these columns for Property Street
ALTER TABLE nashville_housing
ADD owner_street VARCHAR(100);

UPDATE nashville_housing
SET owner_street = SPLIT_PART(owner_address, ',', 1);


ALTER TABLE nashville_housing
ADD owner_city VARCHAR(50);

UPDATE nashville_housing
SET owner_city = TRIM(LEADING  ' ' FROM SPLIT_PART(owner_address, ',', 2));


ALTER TABLE nashville_housing
ADD owner_state CHAR(2);

UPDATE nashville_housing
SET owner_state = TRIM(LEADING ' ' FROM SPLIT_PART(owner_address, ',', 3));


-- View Changes in Data Set
SELECT *
FROM nashville_housing;




---------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

-- Check the values in "Sold as Vacant" field
SELECT
	sold_as_vacant,
	COUNT(*)
FROM nashville_housing
GROUP BY 1
ORDER BY 2 DESC;


-- Standardize "Sold as Vacant" field
SELECT
	sold_as_vacant,
	CASE
		WHEN sold_as_vacant = 'Y' THEN 'Yes'
		WHEN sold_as_vacant = 'N' THEN 'No'
		ELSE sold_as_vacant
	END AS sold_as_vacant_cleaned
FROM nashville_housing;


UPDATE nashville_housing
SET sold_as_vacant = 
	CASE
		WHEN sold_as_vacant = 'Y' THEN 'Yes'
		WHEN sold_as_vacant = 'N' THEN 'No'
		ELSE sold_as_vacant
	END;




---------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH rn_cte AS(
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY parcel_id, property_address, sale_price, sale_date, legal_reference ORDER BY unique_id) AS rn
	FROM nashville_housing
)

SELECT *
FROM rn_cte
WHERE rn < 2;




---------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

-- View Current Columns in the Data Set
SELECT *
FROM nashville_housing;

-- Drop Unused Columns
ALTER TABLE nashville_housing
DROP COLUMN property_address,
DROP COLUMN owner_address,
DROP COLUMN tax_district;




---------------------------------------------------------------------------------------------------------------
-- Drop Table
-- (To avoid having a messy database)

DROP TABLE nashville_housing;
