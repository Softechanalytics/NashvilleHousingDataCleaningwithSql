# 🏡 Nashville Housing Data Cleaning Project

This project focuses on cleaning real-world housing data using **SQL** to ensure the dataset is ready for further analysis and visualization.

---

## 🗂 Dataset

- **File**: `Nashville Housing Data for Data Cleaning.xlsx`
- **Description**: Contains property records from Nashville with various inconsistencies, missing values, and formatting issues.

![link to Dataset](

![link to SQL Code](

---

## 🎯 Objectives

- Identify and handle null or missing values
- Standardize date and string formats
- Remove duplicates
- Split and normalize composite data fields
- Prepare clean, analysis-ready data using SQL

---

## 🔧 Tools Used

- **SQL** (Microsoft SQL Server / PostgreSQL)
- **Excel** (for initial inspection)
- **SSMS** or any SQL-based environment

---

## 🧹 Data Cleaning Steps

1. **Standardizing Date Format**
   - Converted inconsistent date values to standard `YYYY-MM-DD`.

2. **Populating Missing Property Address Data**
   - Used `JOIN` to backfill `PropertyAddress` where it was missing but available elsewhere.

3. **Splitting Columns**
   - Split `PropertyAddress` into `Street`, `City`
   - Split `OwnerAddress` into `OwnerStreet`, `OwnerCity`, `OwnerState`

4. **Standardizing Text**
   - Transformed `SoldAsVacant` values (e.g., `'Y'` / `'N'`) into standardized format (`'Yes'` / `'No'`)

5. **Removing Duplicates**
   - Identified and deleted exact duplicate records using CTE and `ROW_NUMBER()`

6. **Dropped Unused Columns**
   - Removed columns not required for analysis (e.g., `OwnerName`, `TaxDistrict`)

---

## 🚀 Outcome

Created a cleaned dataset ready for data analysis or dashboard creation.

Demonstrated SQL skills in:

String manipulation

Data type conversion

Conditional updates

De-duplication and normalization
---
## 📬 Author

Anyakwu Chukwuemeka Isaac
For questions or feedback, feel free to connect via LinkedIn or Email
---

## 🧾 Sample SQL Snippets

```sql
-- Split Property Address
SELECT 
  PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2) AS Street,
  PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) AS City
FROM NashvilleHousing;
sql
Copy
Edit
-- Remove Duplicates using CTE
WITH RowNumCTE AS (
  SELECT *, ROW_NUMBER() OVER (
    PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice
    ORDER BY UniqueID
  ) AS row_num
  FROM NashvilleHousing
)
DELETE FROM RowNumCTE WHERE row_num > 1;

 📁 Project Files

bash
Copy
Edit
├── Nashville Housing Data for Data Cleaning.xlsx   # Raw dataset
├── Nashville_Datacleaning_Sql.sql                 # SQL cleaning script
├── README.md                                       # Documentation


