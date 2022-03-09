--Cleaning Data in SQL Queries

Select *
From Portfolio_1.dbo.Nashville_Housing

-- Standardize Date Format

Select SaleDateConverted, Convert(Date,SaleDate)
From Portfolio_1.dbo.Nashville_Housing

update Nashville_Housing
Set SaleDate = Convert(Date,SaleDate)

ALTER TABLE Nashville_Housing
add SaleDateConverted Date; 

update Nashville_Housing
Set SaleDateConverted = Convert(Date,SaleDate)

--Populate Property Address Data

Select *
From Portfolio_1.dbo.Nashville_Housing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio_1.dbo.Nashville_Housing a
JOIN Portfolio_1.dbo.Nashville_Housing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio_1.dbo.Nashville_Housing a
JOIN Portfolio_1.dbo.Nashville_Housing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]

--Breaking out Address into Individual Colums (Address, City, State)

Select PropertyAddress
From Portfolio_1.dbo.Nashville_Housing
--Where PropertyAddress is null
--Order by ParcelID

Select
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City

From Portfolio_1.dbo.Nashville_Housing

ALTER TABLE Nashville_Housing
add PropertySplitAddress Nvarchar(255); 

update Nashville_Housing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashville_Housing
add PropertySplitCity Nvarchar(255); 

update Nashville_Housing
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))





Select OwnerAddress
From Portfolio_1.dbo.Nashville_Housing

Select
PARSENAME(Replace(OwnerAddress,',','.'),3) as Address,
PARSENAME(Replace(OwnerAddress,',','.'),2) as City,
PARSENAME(Replace(OwnerAddress,',','.'),1) As State
From Portfolio_1.dbo.Nashville_Housing


ALTER TABLE Nashville_Housing
add OwnerSplitAddress Nvarchar(255); 

update Nashville_Housing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3) 

ALTER TABLE Nashville_Housing
add OwnerSplitCity Nvarchar(255); 

update Nashville_Housing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2) 

ALTER TABLE Nashville_Housing
add OwnerSplitState Nvarchar(255); 

update Nashville_Housing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1) 



--Change Y and N to Yes and No in "Sold as Vacant" field 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio_1.dbo.Nashville_Housing
Group By SoldAsVacant
Order by 2


Select SoldAsVacant, 
	Case When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END
From Portfolio_1.dbo.Nashville_Housing

Update Portfolio_1.dbo.Nashville_Housing
Set SoldAsVacant = 	Case When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	Else SoldAsVacant
	END

	--Remove Duplicates

With RowNumCTE AS(

Select * ,
ROW_NUMBER() OVER (
PARTITION BY ParcelID, 
			PropertYAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by UniqueID) Row_num
	
	From Portfolio_1.dbo.Nashville_Housing
	--Order By ParcelID
	)
	Select *
	From RowNumCTE
	where row_num > 1 
	--Order By PropertyAddress

	--Delete Unused Columns


	Select * 
	From Portfolio_1.dbo.Nashville_Housing

Alter Table Portfolio_1.dbo.Nashville_Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress,OwnerySplitAddress

Alter Table Portfolio_1.dbo.Nashville_Housing
Drop Column SaleDate
