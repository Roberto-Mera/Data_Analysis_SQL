USE air;
------------------------------------------------------------------

--Mostrar datos de las columnas
Select  COLUMN_NAME, DATA_TYPE from information_schema.columns WHERE TABLE_NAME='AirbnbOpenData'

------------------------------------------------------------------

SELECT *
FROM air.dbo.AirbnbOpenData

--1. Rellenar el campo host_identity_verified
--2. Cambiar manhatan y brookln por Manhatan y Brooklyn
--3. Rellenar los campos country, country_code 
--4. Rellenar el campo neighbourhood_group
--5. Retirar los símbolos $ y , de los campos price y service_fee
--6. Retirar el símbolo - del campo minimun_nights
--7. Rellenar el campo reviews_per_month
--8. Remover datos duplicados
--9. Remover columnas que no se van a utilizar



--1. Rellenar el campo host_identity_verified

SELECT host_identity_verified
FROM air.dbo.AirbnbOpenData
WHERE host_identity_verified IS NULL

SELECT host_identity_verified, ISNULL(host_identity_verified,'unconfirmed')
FROM air.dbo.AirbnbOpenData

UPDATE AirbnbOpenData
SET host_identity_verified=ISNULL(host_identity_verified,'unconfirmed')


--2. Cambiar manhatan y brookln por Manhatan y Brooklyn

SELECT DISTINCT(neighbourhood_group)
FROM air.dbo.AirbnbOpenData
ORDER BY neighbourhood_group ASC;

SELECT DISTINCT(neighbourhood_group),
CASE 
	WHEN  neighbourhood_group='manhatan' THEN 'Manhattan'
	WHEN  neighbourhood_group='brookln' THEN 'Brooklyn'
	ELSE neighbourhood_group
	END
FROM air.dbo.AirbnbOpenData

UPDATE AirbnbOpenData
SET neighbourhood_group=CASE 
	WHEN  neighbourhood_group='manhatan' THEN 'Manhattan'
	WHEN  neighbourhood_group='brookln' THEN 'Brooklyn'
	ELSE neighbourhood_group
	END


--3. Rellenar los campos country, country_code 

SELECT country, country_code
FROM air.dbo.AirbnbOpenData
WHERE country IS NULL
OR country_code IS NULL;


UPDATE AirbnbOpenData
SET country=ISNULL(country,'United States')

UPDATE AirbnbOpenData
SET country_code=ISNULL(country_code,'US')


--4. Rellenar el campo neighbourhood_group

SELECT neighbourhood_group,neighbourhood
FROM air.dbo.AirbnbOpenData
WHERE neighbourhood_group IS NULL


SELECT a.neighbourhood_group, a.neighbourhood, b.neighbourhood_group, b.neighbourhood, ISNULL(a.neighbourhood_group,b.neighbourhood_group)
FROM air.dbo.AirbnbOpenData a
INNER JOIN air.dbo.AirbnbOpenData b
ON a.neighbourhood=b.neighbourhood
WHERE a.neighbourhood_group IS NULL
ORDER BY a.neighbourhood_group;


UPDATE a
SET a.neighbourhood_group=ISNULL(a.neighbourhood_group,b.neighbourhood_group)
FROM air.dbo.AirbnbOpenData a
INNER JOIN air.dbo.AirbnbOpenData b
ON a.neighbourhood=b.neighbourhood
WHERE a.neighbourhood_group IS NULL


--5. Retirar los símbolos $ y , de los campos price y service_fee

SELECT price, service_fee
FROM air.dbo.AirbnbOpenData

SELECT price, service_fee, REPLACE(price,'$',''),REPLACE(service_fee,'$','')
FROM air.dbo.AirbnbOpenData

UPDATE AirbnbOpenData
SET price=REPLACE(price,'$','')

UPDATE AirbnbOpenData
SET price=REPLACE(price,',','')

UPDATE AirbnbOpenData
SET service_fee=REPLACE(service_fee,'$','')

UPDATE AirbnbOpenData
SET service_fee=REPLACE(service_fee,',','')


--6. Retirar el símbolo - del campo minimun_nights

SELECT minimum_nights , REPLACE(minimum_nights,'-','')
FROM air.dbo.AirbnbOpenData
WHERE minimum_nights LIKE '-%'

UPDATE AirbnbOpenData
SET minimum_nights=REPLACE(minimum_nights,'-','')

--7. Rellenar el campo reviews_per_month

SELECT number_of_reviews, reviews_per_month
FROM air.dbo.AirbnbOpenData
WHERE reviews_per_month IS NULL AND number_of_reviews=0

UPDATE AirbnbOpenData
SET reviews_per_month=0
WHERE number_of_reviews=0


--8. Remover datos duplicados

with RowNumCTE as(
Select *,
	ROW_NUMBER () over (
	Partition by NAME,
				 lat,
				 long
				 Order BY
				 id
				 ) as row_num
From air.dbo.AirbnbOpenData
)
Select*
FROM RowNumCTE
WHERE row_num>1

--Eliminando duplicados

with RowNumCTE as(
Select *,
	ROW_NUMBER () over (
	Partition by NAME,
				 lat,
				 long
				 Order BY
				 id
				 ) as row_num
From air.dbo.AirbnbOpenData
)
DELETE
FROM RowNumCTE
WHERE row_num>1

--9. Remover columnas que no se van a utilizar

ALTER TABLE air.dbo.AirbnbOpenData
DROP COLUMN country, country_code, house_rules, license