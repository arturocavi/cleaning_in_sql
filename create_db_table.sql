-- Create Database
CREATE DATABASE nashville
    WITH
        OWNER = postgres
        ENCODING = 'UTF8'
;

-- Create Tables
CREATE TABLE nashville_housing_2013(
    unique_id INT PRIMARY KEY,
    parcel_id VARCHAR(50),
    land_use VARCHAR(50),
    property_address VARCHAR(100),
    sale_date TIMESTAMP,
    sale_price NUMERIC,
    legal_reference VARCHAR(50),
    sold_as_vacant VARCHAR(50),
    owner_name VARCHAR(100),
    owner_address VARCHAR(100),
    acreage NUMERIC,
    tax_district VARCHAR(50),
    land_value INT,
    building_value INT,
    total_value INT,
    year_built SMALLINT,
    bedrooms SMALLINT,
    full_bath SMALLINT,
    half_bath SMALLINT
);

CREATE TABLE nashville_housing_2014(
    unique_id INT PRIMARY KEY,
    parcel_id VARCHAR(50),
    land_use VARCHAR(50),
    property_address VARCHAR(100),
    sale_date TIMESTAMP,
    sale_price NUMERIC,
    legal_reference VARCHAR(50),
    sold_as_vacant VARCHAR(50),
    owner_name VARCHAR(100),
    owner_address VARCHAR(100),
    acreage NUMERIC,
    tax_district VARCHAR(50),
    land_value INT,
    building_value INT,
    total_value INT,
    year_built SMALLINT,
    bedrooms SMALLINT,
    full_bath SMALLINT,
    half_bath SMALLINT
);


CREATE TABLE nashville_housing_2015(
    unique_id INT PRIMARY KEY,
    parcel_id VARCHAR(50),
    land_use VARCHAR(50),
    property_address VARCHAR(100),
    sale_date TIMESTAMP,
    sale_price NUMERIC,
    legal_reference VARCHAR(50),
    sold_as_vacant VARCHAR(50),
    owner_name VARCHAR(100),
    owner_address VARCHAR(100),
    acreage NUMERIC,
    tax_district VARCHAR(50),
    land_value INT,
    building_value INT,
    total_value INT,
    year_built SMALLINT,
    bedrooms SMALLINT,
    full_bath SMALLINT,
    half_bath SMALLINT
);

CREATE TABLE nashville_housing_2016(
    unique_id INT PRIMARY KEY,
    parcel_id VARCHAR(50),
    land_use VARCHAR(50),
    property_address VARCHAR(100),
    sale_date TIMESTAMP,
    sale_price NUMERIC,
    legal_reference VARCHAR(50),
    sold_as_vacant VARCHAR(50),
    owner_name VARCHAR(100),
    owner_address VARCHAR(100),
    acreage NUMERIC,
    tax_district VARCHAR(50),
    land_value INT,
    building_value INT,
    total_value INT,
    year_built SMALLINT,
    bedrooms SMALLINT,
    full_bath SMALLINT,
    half_bath SMALLINT
);

-- Import Data

COPY nashville_housing_2013
FROM 'D:\Users\Arturo\Documents\Varios\Projects\Data Cleaning in SQL\PostgreSQL\NashvilleHousingData2013.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    ENCODING 'WIN1252'
);

COPY nashville_housing_2014
FROM 'D:\Users\Arturo\Documents\Varios\Projects\Data Cleaning in SQL\PostgreSQL\NashvilleHousingData2014.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    ENCODING 'WIN1252'
);

COPY nashville_housing_2015
FROM 'D:\Users\Arturo\Documents\Varios\Projects\Data Cleaning in SQL\PostgreSQL\NashvilleHousingData2015.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    ENCODING 'WIN1252'
);

COPY nashville_housing_2016
FROM 'D:\Users\Arturo\Documents\Varios\Projects\Data Cleaning in SQL\PostgreSQL\NashvilleHousingData2016.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    ENCODING 'WIN1252'
);
