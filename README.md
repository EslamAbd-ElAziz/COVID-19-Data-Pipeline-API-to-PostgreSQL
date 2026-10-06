# COVID-19 Data Pipeline — API to PostgreSQL

An end-to-end ETL pipeline that extracts live COVID-19 statistics from a public REST API, transforms them with Pandas, loads them into PostgreSQL, normalizes the data into a star schema, and runs SQL-based analysis to extract insights.

## 🛠 Tech Stack
- **Python** — requests, Pandas
- **PostgreSQL** — data warehouse
- **SQLAlchemy** — database loading
- **SQLMagic** — in-notebook SQL analysis
- **Jupyter Notebook**

## 🔄 Pipeline Overview
1. **API & Data Collection** — Pull live country-level data from the [disease.sh COVID-19 API](https://disease.sh/v3/covid-19/countries)
2. **Data Exploration** — Inspect structure, data types, and missing values
3. **Data Cleaning & Wrangling** — Remove invalid entries, fix data types, rename columns to SQL-friendly snake_case
4. **PostgreSQL Loading** — Load the cleaned dataset into a dedicated `covid` schema via SQLAlchemy
5. **Data Normalization** — Split the flat table into a Star Schema (`dim_country`, `fact_covid_stats`) as reusable views
6. **Data Analysis** — 6 analytical SQL queries covering case rankings, fatality rate, population impact, recovery rate, continent-level aggregation, and testing coverage
7. **Findings / Insights** — Key takeaways, including data-quality caveats discovered during analysis

## 📊 Key Findings
- South Africa recorded the highest total cases in Africa.
- No direct relationship exists between population size and case percentage — small nations dominate the top of that metric.
- South Korea, Macao, and Algeria showed **positivity rates above 100%**, revealing a data-quality issue in how tests were reported rather than an epidemiological reality.
- Europe had the highest total cases and deaths of any continent.

## 📁 Repository Structure
```
├── covid_pipeline.ipynb   # Full notebook: ETL + analysis
├── covid.sql              # Standalone SQL script (views + queries)
├── outputs/               # CSV exports of query results
├── images/                # Screenshots used in documentation
└── README.md
```
## ▶️ How to Run
1. Clone the repo
2. Install dependencies: `pip install pandas requests sqlalchemy psycopg2-binary ipython-sql python-dotenv`
3. Set up a PostgreSQL database and add your connection string to a `.env` file
4. Run the notebook top to bottom
## 🖼️ Screenshots
![Covid_Pipeline](<Covid_Pipeline.ipynb/images/2-Data Cleaning & Wrangling.PNG>)
![Covid_Pipeline](<Covid_Pipeline.ipynb/images/5- Data Analysis by SQLMagic.PNG>)
![Covid_Pipeline](<Covid_Pipeline.ipynb/images/8- Summary View.PNG>)
## 👤 Author
Eslam Magdy — [LinkedIn](www.linkedin.com/in/eslam-saeed-70553b129)
