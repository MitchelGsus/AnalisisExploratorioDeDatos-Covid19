--CREATE DATABASE PROJECT
USE PROJECT
SELECT * FROM INFORMATION_SCHEMA.TABLES
EXEC sp_rename VacunasCovid$, VacunasCovid
EXEC sp_rename MuertesCovid$, MuertesCovid
SELECT * FROM INFORMATION_SCHEMA.TABLES

SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'VacunasCovid'
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'MuertesCovid' --AND column_name LIKE 'total%'

SELECT * FROM MuertesCovid WHERE total_cases IS NOT NULL

SELECT location, COUNT(location) AS AcumuladoxPais FROM MuertesCovid GROUP BY location

SELECT TOP 5 * FROM MuertesCovid ORDER BY 3,4 ASC
SELECT TOP 5 * FROM MuertesCovid ORDER BY 3,4 ASC


SELECT DISTINCT location FROM VacunasCovid ORDER BY 1 ASC
SELECT * FROM VacunasCovid WHERE location = 'Peru'


SELECT location, date, total_cases, new_cases, total_deaths, population
FROM MuertesCovid WHERE total_deaths IS NOT NULL ORDER BY 1, 2

/* Convertir INTS FLOATS A INT
SELECT CONVERT(int, REPLACE(total_cases, '.0', '')) FROM MuertesCovid
WHERE CONVERT(int, REPLACE(total_cases, '.0', '')) > 5
*/


SELECT location, total_cases FROM MuertesCovid WHERE total_cases is not null AND location = 'Argentina'
SELECT sum(cast(total_cases as int)) FROM MuertesCovid WHERE total_cases is not null
AND location = 'Argentina' GROUP BY total_cases

-- Necesito sumar cuantos casos totales en total hay en argentina
SELECT location, SUM(cast(total_cases as int)) FROM MuertesCovid
WHERE total_cases is not null GROUP BY location, total_cases ORDER BY location ASC

SELECT location, SUM(cast(total_cases as float)) OVER (PARTITION BY location) AS CasosTotalesPorPaís
FROM MuertesCovid WHERE total_cases is not null ORDER BY location ASC
---
SELECT DISTINCT(location), SUM(cast(total_cases as float)) OVER (PARTITION BY location) AS CasosTotalesPorPaís
FROM MuertesCovid ORDER BY location ASC





SELECT location, COUNT(location) FROM MuertesCovid
WHERE total_cases is not null GROUP BY location


SELECT SUM(cast(total_cases as int)) FROM MuertesCovid WHERE total_cases is not null GROUP BY total_cases




/* Cambiar DateType
ALTER TABLE dbo.MuertesCovid ALTER COLUMN total_cases varchar(255);
*/
/*
--Actulizar columnas vacias a 'NULL' 

UPDATE MuertesCovid SET total_cases = NULLIF(total_cases, ' ')

SELECT total_cases FROM MuertesCovid WHERE total_cases IS NULL

UPDATE MuertesCovid SET total_cases = NULLIF(total_cases, ' ')
SELECT * FROM MuertesCovid
UPDATE MuertesCovid SET total_cases = NULLIF(total_cases, ' ')
*/

--------
-- BIEN THIS | agregué coalesce para que no de null
SELECT location, COALESCE(SUM(new_deaths), 0) as MuertesTotales
FROM MuertesCovid
GROUP BY location
SELECT continent, COALESCE(SUM(new_deaths), 0) as MuertesTotales
FROM MuertesCovid
GROUP BY continent

SELECT COALESCE(new_deaths, 0) FROM MuertesCovid
SELECT new_deaths FROM MuertesCovid
/*
SELECT location, CASE WHEN SUM(cast(new_deaths as float))  IS NULL THEN 0
ELSE SUM(cast(new_deaths as float))
END AS new_deaths
FROM MuertesCovid
GROUP BY location

SELECT location, COALESCE(SUM(cast(new_deaths as float)), 0)
FROM MuertesCovid
GROUP BY location

SELECT new_deaths(icu_patients, 0) FROM MuertesCovid
SELECT new_deaths FROM MuertesCovid

*/

----
SELECT * FROM MuertesCovid



SELECT SUM(cast(total_cases as int)) FROM MuertesCovid WHERE total_cases is not null GROUP BY total_cases
SELECT SUM(cast(total_cases as float)) FROM MuertesCovid WHERE total_cases is not null GROUP BY total_cases


SELECT SUM(total_cases) FROM MuertesCovid WHERE total_cases is not null GROUP BY total_cases
SELECT location, population FROM MuertesCovid GROUP BY location, population
SELECT location, total_cases FROM MuertesCovid WHERE total_cases IS NULL GROUP BY location, total_cases 

SELECT location, population FROM MuertesCovid


-- VIDEO
USE Project

-- GENERAL
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM MuertesCovid
WHERE total_cases IS NOT NULL AND new_cases IS NOT NULL AND total_deaths IS NOT NULL
ORDER BY 1, 2

-- TOTAL DE CASOS VS TOTAL DE MUERTOS
-- en Argentina el día 2020-03-08 hubo un total de 12 casos y 1 muerto, eso quiere decir
--que el porcentaje de muerte es de un 8.33 %
SELECT location, date, total_cases, total_deaths,
ROUND((cast(total_deaths AS FLOAT))/(cast(total_cases AS FLOAT)), 4)*100 AS Porcentaje_Muerte
FROM MuertesCovid
WHERE total_deaths IS NOT NULL AND total_cases IS NOT NULL AND location = 'Peru'
ORDER BY 1, 2 --1, 2 DESC

SELECT SUM(cast(total_deaths AS FLOAT)) AS Total_Muertos, SUM(cast(total_cases AS FLOAT)) AS Total_Casos,
ROUND(SUM(cast(total_deaths AS FLOAT))/SUM(cast(total_cases AS FLOAT)), 5)*100
FROM MuertesCovid
WHERE total_deaths IS NOT NULL AND total_cases IS NOT NULL AND total_deaths IS NOT NULL

-- TOTAL DE CASOS VS POBLACIÓN
SELECT location, date, population, total_cases,  new_cases, total_deaths,
(total_cases/population)*100 AS PorcentajePoblaciónInfectada
FROM MuertesCovid
WHERE total_cases IS NOT NULL AND new_cases IS NOT NULL AND total_deaths IS NOT NULL AND location = 'Peru'
ORDER BY 1, 2 

/*
-- De las 37742636639 personas que hay en sudamerica, 480254749871 tuvieron covid
-- por lo tanto el 0.0785887836593765 % de la población de Sudamerica tuvo covid
SELECT SUM(cast(total_cases AS FLOAT)) AS Casos_TotalesSUDA, SUM(population) AS Población_TotalSUDA,
(SUM(cast(total_cases AS FLOAT))/SUM(population))*100 AS Porcentaje_Sudamerica
FROM MuertesCovid
*/
/*
WITH PAISES AS(
SELECT DISTINCT location, population, total_cases
FROM MuertesCovid WHERE total_cases IS NOT NULL
)

SELECT * FROM PAISES

SELECT LOCATION, MAX(cast(TOTAL_CASES AS INT)) FROM MuertesCovid
WHERE total_cases IS NOT NULL group by location 

SELECT location, MAX(cast(total_cases AS FLOAT)) FROM MuertesCovid
WHERE total_cases IS NOT NULL AND location = 'Falkland Islands'
GROUP BY location

SELECT location, cast(total_cases AS FLOAT) FROM MuertesCovid
WHERE total_cases IS NOT NULL AND location = 'Falkland Islands'
ORDER BY cast(total_cases AS INT) DESC
*/



/* MAL
SELECT DISTINCT location, population, 
SUM(cast(total_cases AS FLOAT)) OVER(PARTITION BY location) AS Total_CasosCovid
FROM MuertesCovid WHERE total_cases IS NOT NULL
*/

-- Sumar toda la población de SUDAMERICA | bien
SELECT SUM(DISTINCT cast(population AS FLOAT)) FROM MuertesCovid
SELECT DISTINCT location, population FROM MuertesCovid

SELECT SUM(population) AS paises
FROM(SELECT DISTINCT population FROM MuertesCovid) AS t


WITH CTE AS(
SELECT DISTINCT location, population FROM MuertesCovid
)

SELECT SUM(population) AS PoblacionTotalSudamerica FROM CTE
--

-- Casos totales de población infectada por país | bien| this
SELECT location, population, MAX(cast(total_cases AS FLOAT)) AS MáximoContagio,
MAX((cast(total_cases AS FLOAT)/population))*100 AS PorcentajePoblaciónInfectada
FROM MuertesCovid
--WHERE total_cases IS NOT NULL AND new_cases IS NOT NULL AND total_deaths IS NOT NULL AND location = 'Peru'
GROUP BY location, population
ORDER BY PorcentajePoblaciónInfectada
-- bien this
SELECT location, population, date, COALESCE(MAX(cast(total_cases AS FLOAT)), 0) AS MáximoContagio,
COALESCE(MAX((cast(total_cases AS FLOAT)/population)), 0)*100 AS PorcentajePoblaciónInfectada
FROM MuertesCovid
--WHERE total_cases IS NOT NULL AND new_cases IS NOT NULL AND total_deaths IS NOT NULL AND location = 'Peru'
GROUP BY location, population, date
ORDER BY PorcentajePoblaciónInfectada
-----


--ALTER TABLE dbo.MuertesCovid ALTER COLUMN total_cases varchar(255);
--ALTER TABLE dbo.MuertesCovid ALTER COLUMN total_cases int;
ALTER TABLE MuertesCovid ALTER COLUMN date date
SELECT date FROM MuertesCovid

SELECT location, population, MAX(total_cases) AS MáximoContagio,
MAX((total_cases/population))*100 AS PorcentajePoblaciónInfectada
FROM MuertesCovid
--WHERE total_cases IS NOT NULL AND new_cases IS NOT NULL AND total_deaths IS NOT NULL AND location = 'Peru'
GROUP BY location, population
ORDER BY PorcentajePoblaciónInfectada

--países con más muertes por población | Bien
--ALTER TABLE MuertesCovid ALTER COLUMN total_deaths int;
SELECT location, MAX(population) AS TotalPoblación, MAX(total_deaths) AS TotalMuertes 
FROM MuertesCovid
GROUP BY location
ORDER BY TotalPoblación DESC
--
--Quiero que me sume toda la columna Total_Población y TotalMuertes Y en ves de location
-- Sea continent y solo salga South america con los totales
SELECT continent, MAX(population) AS TotalPoblación, MAX(total_deaths) AS TotalMuertes 
FROM MuertesCovid
GROUP BY continent
ORDER BY TotalPoblación DESC
-- falta la division
WITH CTETOTALM AS(
SELECT continent, location, MAX(population) AS TotalPoblación, MAX(total_deaths) AS TotalMuertes 
FROM MuertesCovid
GROUP BY continent, location
)
SELECT continent, SUM(TotalPoblación) AS TotalPoblación , SUM(TotalMuertes) AS TotalMuertes
FROM CTETOTALM GROUP BY continent
--

--Porcentaje Muerte | bien
SELECT location, MAX(population) AS TotalPoblación, MAX(total_deaths) AS TotalMuertes,
(MAX(total_deaths)/MAX(population))*100 AS Mortalidad
FROM MuertesCovid
GROUP BY location
ORDER BY TotalPoblación DESC
---

-- Continentes | bien | This
--ALTER TABLE MuertesCovid ALTER COLUMN new_deaths float;
--ALTER TABLE MuertesCovid ALTER COLUMN new_cases float;

SELECT SUM(new_cases) as CasosTotales, SUM(new_deaths) AS MuertesTotales,
SUM(new_deaths)/SUM(new_cases)*100 AS PorcentajeMuerte
FROM MuertesCovid
ORDER BY 1, 2

SELECT new_deaths FROM MuertesCovid
SELECT new_cases FROM MuertesCovid
SELECT SUM(new_deaths), SUM(new_cases) FROM MuertesCovid

--
SELECT * FROM MuertesCovid mc JOIN VacunasCovid vc
ON mc.location = vc.location

--ALTER TABLE VacunasCovid ALTER COLUMN new_vaccinations float
WITH TCE_Vac (continent, location, date, population, new_vaccinations, PoblaciónVacunada)AS(
SELECT mc.continent, mc.location, mc.date, mc.population, vc.new_vaccinations,
SUM(vc.new_vaccinations) OVER(PARTITION BY mc.location ORDER BY mc.location, mc.date ROWS UNBOUNDED PRECEDING) AS PoblaciónVacunada
FROM MuertesCovid mc JOIN VacunasCovid vc
ON mc.location = vc.location AND mc.date = vc.date
WHERE mc.continent is not null
)
SELECT *, (PoblaciónVacunada/population)*100 FROM TCE_Vac

--Temp table
DROP TABLE IF EXISTS TotalPoblaciónVacunada
CREATE TABLE TotalPoblaciónVacunada(
continent nvarchar(255),
location nvarchar(255),
date date,
population numeric,
new_vaccionations numeric,
PoblaciónVacunada numeric
);

INSERT INTO TotalPoblaciónVacunada
SELECT mc.continent, mc.location, mc.date, mc.population, vc.new_vaccinations,
SUM(vc.new_vaccinations) OVER(PARTITION BY mc.location ORDER BY mc.location, mc.date ROWS UNBOUNDED PRECEDING) AS PoblaciónVacunada
FROM MuertesCovid mc JOIN VacunasCovid vc
ON mc.location = vc.location AND mc.date = vc.date
--WHERE mc.continent is not null
SELECT *, (PoblaciónVacunada/population)*100 FROM TotalPoblaciónVacunada

CREATE VIEW PorcentajePoblacionVacunada AS 
SELECT mc.continent, mc.location, mc.date, mc.population, vc.new_vaccinations,
SUM(vc.new_vaccinations) OVER(PARTITION BY mc.location ORDER BY mc.location, mc.date ROWS UNBOUNDED PRECEDING) AS PoblaciónVacunada
FROM MuertesCovid mc JOIN VacunasCovid vc
ON mc.location = vc.location AND mc.date = vc.date


SELECT * FROM PorcentajePoblacionVacunada

USE Project




/*
CREATE VIEW TotalMuertesSudamerica

SELECT location, MAX(population) AS TotalPoblación, MAX(total_deaths) AS TotalMuertes 
FROM MuertesCovid
GROUP BY location
ORDER BY TotalPoblación DESC
*/