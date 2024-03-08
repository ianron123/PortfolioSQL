select *
From Portfolio..CovidDeaths$
select *
From Portfolio..CovidVaccinations$
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 DeathPercentage
From Portfolio..CovidDeaths$
where location like '%states%'
order by 1,2

select Location, date, total_cases, population, (total_cases/population)*100 Affected
From Portfolio..CovidDeaths$
where location like '%states%'
order by 1,2

select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as Affected
From Portfolio..CovidDeaths$
--ere location like '%states%'
Group by location, population
order by Affected

select Location, MAx(cast(Total_deaths as int)) as totalDeathCount
From Portfolio..CovidDeaths$ 
--ere location like '%states%'
Group by location
order by TotalDeathCount desc

select location, MAx(cast(Total_deaths as int)) as totalDeathCount
From Portfolio..CovidDeaths$ 
Where continent is not null
Group by location
order by TotalDeathCount desc

select continent, MAx(cast(Total_deaths as int)) as totalDeathCount
From Portfolio..CovidDeaths$ 
Where continent is not null
Group by continent
order by TotalDeathCount desc

select date, SUM(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths$
Where continent is not null
Group by date
order by 1,2

select SUM(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From Portfolio..CovidDeaths$
Where continent is not null
order by 1,2

Select *
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	 on dea.location = vac.location
		and dea.date = vac.date


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	 on dea.location = vac.location
		and dea.date = vac.date
Where dea.continent is not null
order by 2,3

with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio..CovidDeaths$ dea
Join Portfolio..CovidVaccinations$ vac
	 on dea.location = vac.location
		and dea.date = vac.date
Where dea.continent is not null
)

Select *, (RollingPeopleVaccinated/Population)*100 
From PopvsVac

Create Table #PercentPopulatioVacinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population int,
New_Vaccinations int,
RollingPeopleVaccinated int
)

insert into #PercentPopulatioVacinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	 on dea.location = vac.location
		and dea.date = vac.date
Where dea.continent is not null
order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 
From #PercentPopulatioVacinated

create View PercentPopulatioVacinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From CovidDeaths$ dea
Join CovidVaccinations$ vac
	 on dea.location = vac.location
		and dea.date = vac.date
Where dea.continent is not null

Select *
From PercentPopulatioVacinated