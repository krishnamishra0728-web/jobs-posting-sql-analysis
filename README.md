# Job Postings Analysis using SQL

An SQL project analysing **5,000 job postings** across 8 fields and 60 companies in India. The goal is to answer real hiring questions: which fields hire the most, what freshers can expect to earn, which cities and work modes are most common, and which skills are most in demand.

> **Note:** This is a **practice dataset generated with a Python script** (`generate_data.py`, fixed random seed), not scraped real postings. The numbers below describe this sample dataset only.

## Tools
SQL (SQLite syntax) | works in DB Browser for SQLite, sqliteonline.com, or any SQL tool with small syntax changes for dates

## Dataset
| Table | Rows | Columns |
|---|---|---|
| `job_postings` | 5,000 | job_id, job_title, field, company_id, city, state, experience_level, employment_type, work_mode, min_salary_lpa, max_salary_lpa, openings, posted_date, skills_required |
| `companies` | 60 | company_id, company_name, industry, company_size |

## SQL Concepts Used
SELECT, WHERE, DISTINCT, ORDER BY, LIMIT, BETWEEN, LIKE, GROUP BY, HAVING, COUNT/SUM/AVG, INNER JOIN, LEFT JOIN, subqueries, CASE WHEN, UNION ALL, date functions, window functions (RANK, ROW_NUMBER, running total).

## What's inside
`queries.sql` has **32 queries** grouped into: Basics, Aggregates, Joins, Subqueries & CASE, Dates, Window Functions, Business Insights.

## Sample Findings (on this dataset)
- Software Development has the most postings (1,290), followed by Data & Analytics (845).
- Software Development has the highest average maximum salary (about 9.2 LPA), then Data & Analytics (about 7.9 LPA).
- Salary rises sharply with experience: fresher postings average about 2.8 to 3.7 LPA, senior postings about 11.4 to 15.3 LPA.
- About 50% of postings are on-site, 32% hybrid and 17.5% remote.
- E-commerce companies post the most fresher roles.

## How to run
1. Open **sqliteonline.com** or install **DB Browser for SQLite**.
2. Import `job_postings.csv` and `companies.csv` as tables with the same names. Make sure the salary columns import as numbers.
3. Open `queries.sql` and run the queries one by one.

## Author
Krishna Mishra | [LinkedIn](https://www.linkedin.com/in/krishna-mishra-652a39407)
