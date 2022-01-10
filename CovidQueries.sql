USE PortfolioProject;

# Select data to be used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths;

# Total cases vs total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeaths
#WHERE location LIKE '%states%'
;

# Total cases vs population
SELECT location, date, population, total_cases, (total_cases/population)*100 AS infection_percentage
FROM coviddeaths
#WHERE location LIKE '%states%'
;

# Countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS infection_percentage
FROM coviddeaths
#WHERE location LIKE '%states%'
GROUP BY population, location
ORDER BY infection_percentage DESC;

# Global numbers
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM coviddeaths
#WHERE location LIKE '%states%'
WHERE continent IS NOT NULL;


# Total population vs vaccination
# Using CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS rolling_people_vaccinated
FROM coviddeaths d
JOIN covidvaccinations v ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
)
SELECT *, (rolling_people_vaccinated/population)*100 AS rolling_people_vac_percentage
FROM PopvsVac;

# Creating views for later viz
CREATE VIEW casesVSdeaths AS
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM coviddeaths
#WHERE location LIKE '%states%'
;

CREATE VIEW casesVSpopulation AS
SELECT location, date, population, total_cases, (total_cases/population)*100 AS infection_percentage
FROM coviddeaths
#WHERE location LIKE '%states%'
;





