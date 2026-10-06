
-- Create dimension table for countries
create VIEW covid.dim_country as 
select 
        country_id,
        country,
        continent,
        iso2,
        iso3,
        lat,
        long,
        population
from covid.countries

-- Create fact table for COVID-19 statistics
CREATE VIEW covid.fact_covid_stats AS
SELECT
    country_id,
    updated,
    cases,
    today_cases,
    deaths,
    today_deaths,
    recovered,
    today_recovered,
    active,
    critical,
    tests,
    cases_per_million,
    deaths_per_million,
    tests_per_million,
    active_per_million,
    recovered_per_million,
    critical_per_million
FROM covid.countries;

select * from covid.dim_country;
select * from covid.fact_covid_stats;

select d.country,f.cases,f.deaths
from covid.dim_country d
join covid.fact_covid_stats f on d.country_id = f.country_id
limit 10;

--Q1 — Rank Countries by Total Cases within Each Continent
SELECT d.country,d.continent,f.cases,
        rank() OVER(partition by d.continent order by f.cases desc) as case_rank_in_continent
    from covid.dim_country d
    join covid.fact_covid_stats f on d.country_id = f.country_id
    order by d.continent,case_rank_in_continent;

--Q2— Case Fatality Rate (CFR) per Country
SELECT d.country, 
            round(f.deaths::numeric / nullif(f.cases, 0) * 100, 2) AS case_fatality_rate
    FROM covid.fact_covid_stats f
    join covid.dim_country d on d.country_id = f.country_id
order by case_fatality_rate desc
limit 10;

--Q3— Relationship Between Population and Total Cases
select d.country, d.continent, d.population, f.cases,
        round(f.cases::NUMERIC / NULLIF(d.population,0) * 100 ,2) as cases_pct_of_population,
        f.cases_per_million
FROM covid.dim_country d
join covid.fact_covid_stats f on d.country_id = f.country_id
WHERE d.population > 0
ORDER BY cases_pct_of_population DESC
LIMIT 10;

--Q4— Recovery Rate per Country
select d.country,d.continent,f.recovered,f.cases,
            round(f.recovered::NUMERIC / NULLIF(f.cases,0) *100 ,2) as recovery_rate
from covid.fact_covid_stats f
join covid.dim_country d on d.country_id = f.country_id
order by recovery_rate desc
limit 10;

--Q5—Continent-Level Summary (Aggregation)
select d.continent,
        sum(d.population) as total_population,
        count(d.country) as total_countries,
        sum(f.cases) as total_cases,
        sum(f.deaths) as total_deaths,
        sum(f.recovered) as total_recovered,
        round(avg(f.cases_per_million), 2) as avg_cases_per_million,
        round(avg(f.deaths_per_million), 2) as avg_deaths_per_million,
        round(sum(f.deaths)::NUMERIC / nullif(sum(f.cases),0) * 100 ,2) as case_fatality_rate,
        round(sum(f.recovered)::NUMERIC / nullif(sum(f.cases),0) * 100 ,2) as recovery_rate
from covid.fact_covid_stats f
join covid.dim_country d on d.country_id = f.country_id
group by d.continent 
order by total_cases desc; 

--Q6—Testing Coverage vs. Cases Detected
SELECT
    d.country,
    d.continent,
    d.population,
    f.tests,
    f.cases,
    round(f.tests::NUMERIC / NULLIF(d.population,0) * 100 ,2) as tests_pct_of_population,
    round(f.cases::NUMERIC / NULLIF(d.population,0) * 100 ,2) as cases_pct_of_population,
    round(f.cases::numeric / NULLIF(f.tests, 0) * 100, 2) AS positivity_rate_pct
FROM covid.dim_country d
join covid.fact_covid_stats f on d.country_id = f.country_id
WHERE f.tests > 0
order by positivity_rate_pct desc
limit 10;

--Summary View
CREATE VIEW covid.summary_view AS
SELECT country,
       continent,
       population,
       cases,
       deaths,
       recovered,
       tests,
       f.active,
       round(cases::NUMERIC / NULLIF(population,0) * 100 ,2) as cases_pct_of_population,
       round(deaths::NUMERIC / NULLIF(population,0) * 100 ,2) as deaths_pct_of_population,
       round(recovered::NUMERIC / NULLIF(population,0) * 100 ,2) as recovered_pct_of_population,
       round(tests::NUMERIC / NULLIF(population,0) * 100 ,2) as tests_pct_of_population,
       round(deaths::numeric / nullif(cases, 0) * 100, 2) AS case_fatality_rate,
       round(recovered::numeric / nullif(cases, 0) * 100, 2) AS recovery_rate
FROM covid.dim_country d
JOIN covid.fact_covid_stats f ON d.country_id = f.country_id;

select * from covid.summary_view ORDER BY cases desc limit 10;
