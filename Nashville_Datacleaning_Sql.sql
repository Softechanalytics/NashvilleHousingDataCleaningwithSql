use Nashville;
select *
from nashvillehousing;

-- Standardize Date format

Select 
	Saledate, cast(saledate as Date) SalesDate
from NashvilleHousing;

-- Update the SaleDate

Update NashvilleHousing
Set SaleDate = Cast(SaleDate as Date); -- Sometime this does work, so we have to create a new Date field as below

Alter Table NashvilleHousing
Add SaleDateConverted Date;

upDate NashvilleHousing
Set SaleDateConverted = cast(saledate as Date);

Select SaleDateConverted, saleDate
From NashvilleHousing;

-- Populate the Propertu Address Data
Select * 
From NashvilleHousing
Where PropertyAddress is null;

-- Note, We have some Property without an address and this is very important
-- So the solution would be to use, a self Join based on the ParcelID., if the ParcelID, is null then we would do a replace.

Select a.ParcelID, 
		a.PropertyAddress, 
		b.ParcelID, 
		b.PropertyAddress, 
		ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]


Where a.PropertyAddress is null

-- Now let use the update command, to update the null value

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville.dbo.NashvilleHousing a
JOIN Nashville.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;


-- Breaking out address into Individual Column (Address, City, State)

Select 
	PropertyAddress
From Nashville.dbo.NashvilleHousing

-- to see the seperation
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City

From Nashville.dbo.NashvilleHousing

-- We have to create 2 new column Address and City, then update it


Alter Table NashvilleHousing
Add Address1 varchar(255);

Alter Table NashvilleHousing
Add City varchar(255);

Update NashvilleHousing
Set Address1 =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

Update NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress));

select *
From NashvilleHousing;


-- using ParseName, to seperate. but note parsename work only on period, so therefore, let replace the comma with period

Select OwnerAddress
From Nashville.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Nashville.dbo.NashvilleHousing

-- Next step is to create the columns and then replace the values
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select *
from nashvillehousing;


-- Change Y and N yp Yes and No in 'Sold as Vacant' Field

Select soldasvacant,
count(*)
from nashvillehousing
group by soldasvacant;

update nashvillehousing
set soldasvacant = 'Yes'
where soldasvacant = 'Y';

update nashvillehousing
set soldasvacant = 'No'
where soldasvacant = 'N';

-- Another method is via the Case statement

Select soldasvacant,

	Case when soldasvacant = 'Y' then 'Yes'
	     when soldasvacant = 'N' then 'No'
	else soldasvacant
	End
From NashvilleHousing;


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville.dbo.NashvilleHousing

--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- 104 duplicates identify, new steps is to delete them

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville.dbo.NashvilleHousing

--order by ParcelID
)
Delete 
From RowNumCTE
Where row_num > 1
--This would delete the 104 duplicates row


-- Delete Unused Columns



Select *
From Nashville.dbo.NashvilleHousing;

ALTER TABLE Nashville.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
