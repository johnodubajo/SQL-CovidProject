SELECT *
FROM [Portfolio Project ].dbo.CovidDeaths

SELECT*
FROM [Portfolio Project ].dbo.CovidVaccinations

--Create Views for Covid Data Visualisation Analysis
-- 1: World Covid Data


CREATE VIEW WorldCovidData AS
SELECT continent, location, date, new_cases, total_cases, new_deaths, total_deaths, population 
FROM [Portfolio Project ].dbo.CovidDeaths
WHERE Continent is not NULL
--ORDER BY date DESC


-- 2: CovidData

--CREATE VIEW CovidData AS
--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM [Portfolio Project ].dbo.CovidDeaths

-- 3: Total Cases vs Total Deaths (Covid Death Percentage)
--Shows likelihood of dying if you contract covid in your country


CREATE VIEW TotalCasesvsTotalDeaths AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project ].dbo.CovidDeaths
--ORDER BY 1,2 

-- 4: Total Cases vs Population (Covid Cases Percentage)


CREATE VIEW TotalCasesvsPopulation AS
SELECT location, date, total_cases, population, (total_cases/population)*100 AS CovidCasePercentage
FROM [Portfolio Project ].dbo.CovidDeaths
--ORDER BY 1 DESC

-- 5: Total Deaths vs Population (Covid Death Percentage)


CREATE VIEW TotalDeathsvsPopulation AS
SELECT location, date, total_deaths, population, (total_deaths/population)*100 AS CovidDeathPercentage
FROM [Portfolio Project ].dbo.CovidDeaths

SELECT*
FROM TotalDeathsvsPopulation


--SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM [Portfolio Project ].dbo.CovidDeaths 
--WHERE continent is not NULL 
--GROUP BY location
--ORDER BY TotalDeathCount DESC




--CREATE VIEW BreakdownByContinent AS
--SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
--FROM [Portfolio Project ].dbo.CovidDeaths
----WHERE continent is NULL
--GROUP BY continent 
----ORDER BY TotalDeathCount DESC

--Total World Death Breakdown

--SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM [Portfolio Project ].dbo.CovidDeaths
--WHERE continent is not NULL
--GROUP BY continent 
--ORDER BY TotalDeathCount DESC

-- 6: Global Breakdown

CREATE VIEW GlobalBreakdown AS
SELECT date, SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM [Portfolio Project ].dbo.CovidDeaths
WHERE Continent is not NULL
GROUP BY date 
--ORDER BY 1,2


--7: Global Death Figure (Summarised)

CREATE VIEW GlobalDeathFigure AS
Select SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM [Portfolio Project ].dbo.CovidDeaths
WHERE Continent is not NULL
--GROUP BY date 
--ORDER BY 1,2


-- 8. Total Vaccinations by Population (Rolling Count Percentage)

--Use CTE (Common Table Expression)

CREATE VIEW RollingCountVaccinated AS
WITH PopvsVacc (continent, location, date, population, new_vaccinations, RollingCountVaccinated)
as
(
SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
SUM(CAST(vacc.new_vaccinations as bigint)) OVER (PARTITION BY death.location ORDER BY death.location,
death.date) as RollingCountVaccinated
FROM [Portfolio Project ].dbo.CovidDeaths as death
JOIN [Portfolio Project ].dbo.CovidVaccinations as vacc
	ON
	death.location = vacc.location
 and death.date = vacc.date 
 WHERE death.continent is not NULL
 --ORDER BY 2,3
 )
 SELECT*,(RollingCountVaccinated/Population)*100 AS RollingCountVaccinatedPercentage
 From PopvsVacc


-- --Temp Table
-- DROP TABLE if exists PercentPopulationVaccinated
-- CREATE TABLE PercentPopulationVaccinated
-- (
-- Continent nvarchar(255),
-- Location nvarchar(255),
-- Date datetime,
-- Population numeric,
-- New_Vaccinations numeric,
-- RollingCountVaccinated numeric
-- )
-- INSERT INTO PercentPopulationVaccinated

--SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
--SUM(CAST(vacc.new_vaccinations as bigint)) OVER (PARTITION BY death.location ORDER BY death.location,
--death.date) as RollingCountVaccinated
--FROM [Portfolio Project ].dbo.CovidDeaths as death
--JOIN [Portfolio Project ].dbo.CovidVaccinations as vacc
--	ON
--	death.location = vacc.location
-- and death.date = vacc.date 
-- --WHERE death.continent is not NULL
-- --ORDER BY 2,3

-- SELECT*,(RollingCountVaccinated/Population)*100 AS RollingCountVaccinatedPercentage
-- From PercentPopulationVaccinated


 --CREATE VIEW FOR VISUALISATION

-- CREATE VIEW PercentagePopulationVaccinated as
-- SELECT death.continent, death.location, death.date, death.population, vacc.new_vaccinations,
--SUM(CAST(vacc.new_vaccinations as bigint)) OVER (PARTITION BY death.location ORDER BY death.location,
--death.date) as RollingCountVaccinated
--FROM [Portfolio Project ].dbo.CovidDeaths as death
--JOIN [Portfolio Project ].dbo.CovidVaccinations as vacc
--	ON
--	death.location = vacc.location
-- and death.date = vacc.date 
-- WHERE death.continent is not NULL
-- --ORDER BY 2,3

 --SELECT *
 --FROM PercentagePopulationVaccinated



 





