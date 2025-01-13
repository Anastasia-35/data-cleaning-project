# Data Cleaning Project

## Description

This project demonstrates various techniques for cleaning and standardizing data using SQL. The goal is to handle missing values, convert and standardize data formats, and split combined fields into individual components to make the dataset cleaner and more usable for analysis. The project focuses on data stored in the `PortfolioProject..Housing` table.

## Features

- **Date Formatting**: Standardized date format in the `SaleDate` column.
- **Address Data Cleaning**: Cleaned and split the `PropertyAddress` and `OwnerAddress` columns into separate fields (Address, City, State).
- **Handling Missing Values**: Replaced missing values in `PropertyAddress` by joining records with the same `ParcelID`.
- **Replaced Values**: Transformed values in the `SoldAsVacant` column (Y/N to YES/NO).
- **Removed Unused Columns**: Dropped unnecessary columns such as `OwnerAddress`, `TaxDistrict`, and `SaleDate`.

## Technologies Used

- **SQL Server**: Queries run on Microsoft SQL Server Management Studio (SSMS) to manipulate and clean the data.

## Setup

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/Anastasia-35/Data_Cleaning-project.git
