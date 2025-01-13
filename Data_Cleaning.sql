/*
  Data Cleaning in SQL Queries
  This script demonstrates various techniques for cleaning and standardizing data in SQL,
  including handling missing values, correcting data formats, and splitting columns.
*/

-- View all data in the Housing table
SELECT * 
FROM PortfolioProject..Housing;


-- ------------------------------------------------------
-- Standardize Date Format
-- ------------------------------------------------------


-- Convert SaleDate to a proper date format
SELECT SaleDate, TRY_CONVERT(DATE, SaleDate) 
FROM PortfolioProject..Housing;

-- Identify rows where SaleDate could not be converted to a date
SELECT SaleDate
FROM PortfolioProject..Housing
WHERE TRY_CONVERT(DATE, SaleDate) IS NULL;

-- Update SaleDate to the standardized date format
UPDATE PortfolioProject..Housing
SET SaleDate = TRY_CONVERT(DATE, SaleDate);

-- Add a new column to store converted SaleDate
ALTER TABLE PortfolioProject..Housing
ADD SaleDateConverted DATE;

-- Populate the new SaleDateConverted column
UPDATE PortfolioProject..Housing
SET SaleDateConverted = CONVERT(DATE, SaleDate);

-- View the new SaleDateConverted column
SELECT SaleDateConverted
FROM PortfolioProject..Housing;




-- ------------------------------------------------------
-- Populate Property Address Data
-- ------------------------------------------------------


-- View all PropertyAddress data
SELECT *
FROM PortfolioProject..Housing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

-- Identify rows where PropertyAddress is missing and attempt to join with other rows with the same ParcelID
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..Housing a
JOIN PortfolioProject..Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

-- Update PropertyAddress by replacing NULL values with values from matching rows
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..Housing a
JOIN PortfolioProject..Housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;




-- ------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)
-- ------------------------------------------------------

-- View PropertyAddress column to identify structure
SELECT PropertyAddress
FROM PortfolioProject..Housing;

-- Extract the address and city from PropertyAddress by splitting on the comma
SELECT 
    -- Extract part before the comma (Address)
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,

    -- Extract part after the comma (City or State)
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject..Housing;

-- Add a new column to store the extracted Address
ALTER TABLE PortfolioProject..Housing
ADD PropertySplitAddress NVARCHAR(255);

-- Populate the new PropertySplitAddress column
UPDATE PortfolioProject..Housing
SET PropertySplitAddress = 
    CASE 
        WHEN CHARINDEX(',', PropertyAddress) > 0
        THEN SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
        ELSE PropertyAddress  -- If no comma, return the whole PropertyAddress as Address
    END;

-- Add a new column to store the extracted City/State
ALTER TABLE PortfolioProject..Housing
ADD PropertySplitCity NVARCHAR(255);

-- Update PropertySplitCity column to hold the value after the comma (City/State)
UPDATE PortfolioProject..Housing
SET PropertySplitCity = 
    CASE 
        WHEN CHARINDEX(',', PropertyAddress) > 0
        THEN SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress))
        ELSE NULL  -- If no comma, set PropertySplitCity to NULL
    END;

-- View all data in the Housing table after updates
SELECT * 
FROM PortfolioProject..Housing;




-- ------------------------------------------------------
-- Looking at Owner Address
-- ------------------------------------------------------

-- View OwnerAddress data
SELECT OwnerAddress
FROM PortfolioProject..Housing;

-- Split OwnerAddress into individual parts (Address, City, State) using PARSENAME function
SELECT 
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS OwnerAddressPart1,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS OwnerAddressPart2,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS OwnerAddressPart3
FROM PortfolioProject..Housing;

-- Add new columns to split OwnerAddress into separate parts
ALTER TABLE PortfolioProject..Housing
ADD OwnerSplitAddress NVARCHAR(255);

-- Update OwnerSplitAddress with the first part of the address
UPDATE PortfolioProject..Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE PortfolioProject..Housing
ADD OwnerSplitCity NVARCHAR(255);

-- Update OwnerSplitCity with the second part of the address (City)
UPDATE PortfolioProject..Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE PortfolioProject..Housing
ADD OwnerSplitState NVARCHAR(255);

-- Update OwnerSplitState with the third part of the address (State)
UPDATE PortfolioProject..Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);



-- ------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
-- ------------------------------------------------------

-- View distinct values of SoldAsVacant
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..Housing
GROUP BY SoldAsVacant;

-- Change 'Y' and 'N' values to 'YES' and 'NO'
SELECT SoldAsVacant,
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'YES'
        WHEN SoldAsVacant = 'N' THEN 'NO'
        ELSE SoldAsVacant
    END AS SoldAsVacant_Updated
FROM PortfolioProject..Housing;

-- Update SoldAsVacant field to replace 'Y' with 'YES' and 'N' with 'NO'
UPDATE PortfolioProject..Housing
SET SoldAsVacant = 
    CASE 
        WHEN SoldAsVacant = 'Y' THEN 'YES'
        WHEN SoldAsVacant = 'N' THEN 'NO'
        ELSE SoldAsVacant
    END;

-- View the updated SoldAsVacant column
SELECT SoldAsVacant 
FROM PortfolioProject..Housing;




-- ------------------------------------------------------
-- Delete Unused Columns
-- ------------------------------------------------------

-- Drop unused columns from the Housing table
ALTER TABLE PortfolioProject..Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

-- View all remaining data in the Housing table
SELECT *
FROM PortfolioProject..Housing;
