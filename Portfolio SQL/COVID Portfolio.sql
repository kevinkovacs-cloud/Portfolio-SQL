-- En este proyecto hare una exploracion de datos. 
-- Dataset descargado en "https://ourworldindata.org/covid-deaths"


-- Primero visualizaremos las personas que murieron por COVID:
-- (Notese la aclaracion "Not null", esto se debe a que este dataset
-- contiene datos tanto de paises como de continentes, para discriminar estos dos,
-- le avisamos a SQL que unicamente trabajaremos con los no nulos (o paises)).

select * 
from PortfolioProject..CovidDeaths
Where continent is not NULL 
order by 3,4

-- Para visualizar las personas ya vacunas: 

--select * 
--from PortfolioProject..CovidVaccinations
--Where continent is not NULL 
--order by 3,4


--Seleccionamos los datos que vamos a utilizar:

Select Location, Date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
Where continent is not NULL 
order by 1,2

-- Veamos el total de casos vs el total de muertos
-- Arrojará la probabilidad de morir si contraes el virus en tu país:

Select Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
Where continent is not NULL 
and location like '%Argentina%'
order by 1,2

-- Total de casos vs poblacion 
-- Arrojará el porcentaje de casos que se contagiaron de Covid:

Select Location, Date, total_cases, population, (total_cases/population)*100 as CasesPercentage
from PortfolioProject..CovidDeaths
Where continent is not NULL 
and location like '%Argentina%'
order by 1,2



-- Veamos ahora, los paises con mayor tasa de infeccion comparado con la poblacion:

Select Location, MAX(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--Where location like '%Argentina%'
Where continent is not NULL 
group by Location, population
order by PercentPopulationInfected desc

-- Los paises con mayor muertes por poblacion:

Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is not NULL 
group by Location
order by TotalDeathCount desc

-- Ahora no seleccionamos los paises, sino que trabajaremos con 
-- Continentes, por lo que elegiremos las variables NULAS.

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
Where continent is NULL 
group by location
order by TotalDeathCount desc


-- NUMEROS GLOBALES

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

-- Total de la poblacion que recibio al menos una vacuna contra el COVID.
-- Notese que estamos comparando dos tablas distintas y trabajamos nuevamente
-- con variables no nulas.

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Ahora utilizaremos CTE (Expresiones comunes de tabla)
-- Y PARTITION BY:

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creamos una visualizacion para guardar los datos, para posterior visualizacion:

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
