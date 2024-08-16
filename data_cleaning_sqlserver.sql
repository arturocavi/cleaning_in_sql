/*
Cleaning Data in SQL Queries Project
 Nashville Housing Data
 MS SQL Server Version
*/

---------------------------------------------------------------------------------------------------------------
-- Append Tables
CREATE TABLE NashvilleHousing AS
SELECT * FROM nashville_housing_2013
UNION ALL
SELECT * FROM nashville_housing_2014
UNION ALL
SELECT * FROM nashville_housing_2015
UNION ALL
SELECT * FROM nashville_housing_2016;


-- View Data
SELECT *
FROM NashvilleHousing;




---------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

-- Convert Sale Date column to date format
UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate);




---------------------------------------------------------------------------------------------------------------
-- Populate Property Address Data

-- Missing Addresses
SELECT
    UniqueID,
    PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY UniqueID;


-- Checking that properties with null values have the same parcel identifier as other properties with address
WITH NoPropertyAddress AS(
	SELECT ParcelID
	FROM NashvilleHousing
	WHERE PropertyAddress IS NULL
)

SELECT *
FROM NashvilleHousing
WHERE ParcelID IN (SELECT ParcelID FROM NoPropertyAddress)
ORDER BY ParcelID,PropertyAddress DESC;


-- Self-Join table where Parcel ID is the same but is not the same Unique ID and Property Address is null
SELECT
	a.ParcelID,
	a.UniqueID,
	a.PropertyAddress PropertyAddressA,
	b.PropertyAddress PropertyAddressB
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL
ORDER BY UniqueID;


-- Replace null Property Address values 
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;




---------------------------------------------------------------------------------------------------------------
-- Breaking out Property Address into Individual Columns (Address & City)
-- (Single Delimiter Case)

-- View Property Address Original Format
SELECT PropertyAddress
FROM NashvilleHousing;


-- Split Property Address into Street and City
SELECT
    PropertyAddress,
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS PropertyStreet,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)-1, LEN(PropertyAddress)) AS PropertyCity
FROM NashvilleHousing;


-- Modify table to add these columns for Property Address
ALTER TABLE NashvilleHousing
ADD PropertyStreet Nvarchar(250);

UPDATE NashvilleHousing
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


ALTER TABLE NashvilleHousing
ADD PropertyCity Nvarchar(250);

UPDATE NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)-1, LEN(PropertyAddress));


-- View Changes in Data Set
SELECT *
FROM NashvilleHousing;




---------------------------------------------------------------------------------------------------------------
-- Breaking out Owner Address into Individual Columns (Address, City, State)
-- (Multiple Delimiter Case)

-- View Owner Address Original Format
SELECT OwnerAddress
FROM NashvilleHousing;


-- Split Owner Address into Street, City and State
SELECT
    OwnerAddress,
	PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS OwnerSplitAddress,
	PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS OwnerSplitCity,
	PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS OwnerSplitState
FROM NashvilleHousing;


-- Modify table to add these columns for Property Address
ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(100);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3);


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(50);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2);


ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(50);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1);


-- View Changes in Data Set
SELECT *
FROM NashvilleHousing;




---------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

-- Check the values in "Sold as Vacant" field
SELECT 
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant) AS SoldAsVacantCount
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 DESC;


-- Standardize "Sold as Vacant" field
SELECT 
	SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END AS SoldAsVacantModified
FROM NashvilleHousing;


UPDATE NashvilleHousing
SET SoldAsVacant = 
	CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	END;




---------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS RowNum
	FROM NashvilleHousing
)

DELETE
FROM RowNumCTE
WHERE RowNum > 1




---------------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

-- View Current Columns in the Data Set
SELECT *
FROM NashvilleHousing;

-- Drop Unused Columns
ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict




---------------------------------------------------------------------------------------------------------------
-- Drop Table
-- (To avoid having a messy database)

DROP TABLE NashvilleHousing;