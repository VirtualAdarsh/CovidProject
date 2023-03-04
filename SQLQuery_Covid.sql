--Preview of the data
USE Covid_Project;
SELECT * FROM CovidDeaths;
SELECT * FROM CovidVaccination;

--Total deaths v Total Population
with cte as
(
SELECT date,location,new_cases,new_deaths,
CASE
	WHEN new_cases IS  NULL THEN 0
	ELSE new_cases
	END AS cases,
CASE
	WHEN new_deaths IS NULL THEN 0
	ELSE new_deaths
	END AS deaths
FROM CovidDeaths
)
SELECT location,ROUND((SUM(deaths)/SUM(cases))*100,2) as death_percentage
FROM cte
WHERE cases>0
GROUP BY location
ORDER BY location;

--Top 10 Countries having highest infection rate
SELECT top 10 location,ROUND((MAX(total_cases)/MAX(Population))*100,2) AS infection_rate
FROM CovidDeaths
GROUP BY location
ORDER BY infection_rate DESC


--Countries with highest death rate
SELECT location,ROUND((MAX(CONVERT(int,total_deaths))/MAX(population))*100,2) as death_rate
FROM Coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY location;

--Total deathcount per continent
SELECT continent,MAX(cast(total_deaths as int)) as deaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP By continent
ORDER BY deaths DESC;

--Daily global data
SELECT  date,SUM(new_cases) as cases,SUM(CONVERT(int,new_deaths)) as deaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


--Calculating total population vs total vaccinated people
SELECT cd.location,MAX(cd.population) as population,MAX(CONVERT(float,people_vaccinated)) as vaccinations,
ROUND((MAX(CONVERT(float,people_vaccinated))/MAX(cd.population))*100,2) as vaccine_rate
FROM CovidDeaths cd
JOIN CovidVaccination cv
ON cd.location=cv.location AND cd.date=cv.date
WHERE cd.continent IS NOT NULL 
GROUP BY cd.location


