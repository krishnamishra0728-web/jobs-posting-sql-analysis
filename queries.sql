-- ============================================================
-- Job Postings Analysis using SQL  (SQLite syntax)
-- Tables: job_postings (5,000 rows), companies (60 rows)
-- Author: Krishna Mishra
-- ============================================================

-- ---------- SECTION 1: BASICS (SELECT, WHERE, ORDER BY) ----------

-- Q1. How many job postings are in the dataset?
SELECT COUNT(*) AS total_postings FROM job_postings;

-- Q2. List all distinct fields.
SELECT DISTINCT field FROM job_postings ORDER BY field;

-- Q3. Show all fresher postings in Jaipur.
SELECT job_id, job_title, field, employment_type, min_salary_lpa, max_salary_lpa
FROM job_postings
WHERE city = 'Jaipur' AND experience_level = 'Fresher'
ORDER BY max_salary_lpa DESC;

-- Q4. Top 10 highest paying postings (by max salary).
SELECT job_title, field, city, experience_level, max_salary_lpa
FROM job_postings
ORDER BY max_salary_lpa DESC
LIMIT 10;

-- Q5. Remote data & analytics jobs open to freshers.
SELECT job_id, job_title, city, min_salary_lpa, max_salary_lpa
FROM job_postings
WHERE field = 'Data & Analytics' AND work_mode = 'Remote' AND experience_level = 'Fresher'
ORDER BY min_salary_lpa DESC;

-- Q6. Postings that require SQL.
SELECT COUNT(*) AS sql_jobs FROM job_postings WHERE skills_required LIKE '%SQL%';

-- Q7. Postings with a minimum salary between 4 and 8 LPA.
SELECT job_title, city, min_salary_lpa
FROM job_postings
WHERE min_salary_lpa BETWEEN 4 AND 8
ORDER BY min_salary_lpa
LIMIT 20;

-- ---------- SECTION 2: AGGREGATES (GROUP BY, HAVING) ----------

-- Q8. Number of postings per field.
SELECT field, COUNT(*) AS postings
FROM job_postings
GROUP BY field
ORDER BY postings DESC;

-- Q9. Average salary range per field.
SELECT field,
       ROUND(AVG(min_salary_lpa), 2) AS avg_min_lpa,
       ROUND(AVG(max_salary_lpa), 2) AS avg_max_lpa
FROM job_postings
GROUP BY field
ORDER BY avg_max_lpa DESC;

-- Q10. Cities with the most postings.
SELECT city, COUNT(*) AS postings
FROM job_postings
GROUP BY city
ORDER BY postings DESC;

-- Q11. Fields with more than 500 postings.
SELECT field, COUNT(*) AS postings
FROM job_postings
GROUP BY field
HAVING COUNT(*) > 500
ORDER BY postings DESC;

-- Q12. Total openings per field.
SELECT field, SUM(openings) AS total_openings
FROM job_postings
GROUP BY field
ORDER BY total_openings DESC;

-- Q13. Average fresher salary by city (cities with at least 20 fresher postings).
SELECT city, COUNT(*) AS fresher_postings, ROUND(AVG(min_salary_lpa), 2) AS avg_min_lpa
FROM job_postings
WHERE experience_level = 'Fresher'
GROUP BY city
HAVING COUNT(*) >= 20
ORDER BY avg_min_lpa DESC;

-- Q14. Work mode split (On-site / Hybrid / Remote) with percentage.
SELECT work_mode,
       COUNT(*) AS postings,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM job_postings), 1) AS pct
FROM job_postings
GROUP BY work_mode
ORDER BY postings DESC;

-- Q15. Salary growth by experience level.
SELECT experience_level, ROUND(AVG(min_salary_lpa), 2) AS avg_min_lpa, ROUND(AVG(max_salary_lpa), 2) AS avg_max_lpa
FROM job_postings
GROUP BY experience_level
ORDER BY avg_min_lpa;

-- ---------- SECTION 3: JOINS ----------

-- Q16. Top 10 companies by number of postings.
SELECT c.company_name, c.industry, COUNT(*) AS postings
FROM job_postings j
JOIN companies c ON j.company_id = c.company_id
GROUP BY c.company_id
ORDER BY postings DESC
LIMIT 10;

-- Q17. Average salary by company size.
SELECT c.company_size, ROUND(AVG(j.max_salary_lpa), 2) AS avg_max_lpa
FROM job_postings j
JOIN companies c ON j.company_id = c.company_id
GROUP BY c.company_size
ORDER BY avg_max_lpa DESC;

-- Q18. Which industries hire the most freshers?
SELECT c.industry, COUNT(*) AS fresher_postings
FROM job_postings j
JOIN companies c ON j.company_id = c.company_id
WHERE j.experience_level = 'Fresher'
GROUP BY c.industry
ORDER BY fresher_postings DESC;

-- Q19. Data analyst postings with company details.
SELECT j.job_title, c.company_name, c.industry, j.city, j.min_salary_lpa, j.max_salary_lpa
FROM job_postings j
JOIN companies c ON j.company_id = c.company_id
WHERE j.job_title LIKE '%Data Analyst%' AND j.experience_level = 'Fresher'
ORDER BY j.max_salary_lpa DESC
LIMIT 20;

-- Q20. Companies with the fewest postings (LEFT JOIN keeps companies even with zero postings).
SELECT c.company_name, c.industry, COUNT(j.job_id) AS postings
FROM companies c
LEFT JOIN job_postings j ON c.company_id = j.company_id
GROUP BY c.company_id
ORDER BY postings ASC
LIMIT 5;

-- ---------- SECTION 4: SUBQUERIES & CASE ----------

-- Q21. Postings paying above the overall average max salary.
SELECT job_title, field, city, max_salary_lpa
FROM job_postings
WHERE max_salary_lpa > (SELECT AVG(max_salary_lpa) FROM job_postings)
ORDER BY max_salary_lpa DESC
LIMIT 15;

-- Q22. Label postings into salary bands.
SELECT CASE
         WHEN max_salary_lpa < 4  THEN 'Low (<4 LPA)'
         WHEN max_salary_lpa < 8  THEN 'Medium (4-8 LPA)'
         WHEN max_salary_lpa < 15 THEN 'High (8-15 LPA)'
         ELSE 'Very High (15+ LPA)'
       END AS salary_band,
       COUNT(*) AS postings
FROM job_postings
GROUP BY salary_band
ORDER BY postings DESC;

-- Q23. Fields whose average salary is above the overall average.
SELECT field, ROUND(AVG(max_salary_lpa), 2) AS avg_max_lpa
FROM job_postings
GROUP BY field
HAVING AVG(max_salary_lpa) > (SELECT AVG(max_salary_lpa) FROM job_postings)
ORDER BY avg_max_lpa DESC;

-- Q24. Share of fresher-friendly postings in each field.
SELECT field,
       COUNT(*) AS total,
       SUM(CASE WHEN experience_level = 'Fresher' THEN 1 ELSE 0 END) AS freshers,
       ROUND(100.0 * SUM(CASE WHEN experience_level = 'Fresher' THEN 1 ELSE 0 END) / COUNT(*), 1) AS fresher_pct
FROM job_postings
GROUP BY field
ORDER BY fresher_pct DESC;

-- ---------- SECTION 5: DATES ----------

-- Q25. Postings per month.
SELECT strftime('%Y-%m', posted_date) AS month, COUNT(*) AS postings
FROM job_postings
GROUP BY month
ORDER BY month;

-- Q26. Postings per year.
SELECT strftime('%Y', posted_date) AS year, COUNT(*) AS postings
FROM job_postings
GROUP BY year;

-- ---------- SECTION 6: WINDOW FUNCTIONS ----------

-- Q27. Rank fields by average max salary.
SELECT field,
       ROUND(AVG(max_salary_lpa), 2) AS avg_max_lpa,
       RANK() OVER (ORDER BY AVG(max_salary_lpa) DESC) AS salary_rank
FROM job_postings
GROUP BY field;

-- Q28. Highest paying posting in each field.
SELECT field, job_title, city, max_salary_lpa
FROM (
  SELECT field, job_title, city, max_salary_lpa,
         ROW_NUMBER() OVER (PARTITION BY field ORDER BY max_salary_lpa DESC) AS rn
  FROM job_postings
)
WHERE rn = 1;

-- Q29. Top 3 cities per field by number of postings.
SELECT field, city, postings, rnk
FROM (
  SELECT field, city, COUNT(*) AS postings,
         RANK() OVER (PARTITION BY field ORDER BY COUNT(*) DESC) AS rnk
  FROM job_postings
  GROUP BY field, city
)
WHERE rnk <= 3
ORDER BY field, rnk;

-- Q30. Running total of postings by month.
SELECT month, postings, SUM(postings) OVER (ORDER BY month) AS running_total
FROM (
  SELECT strftime('%Y-%m', posted_date) AS month, COUNT(*) AS postings
  FROM job_postings
  GROUP BY month
);

-- ---------- SECTION 7: BUSINESS INSIGHTS ----------

-- Q31. Best fresher opportunities: data/analytics, high salary, remote or hybrid.
SELECT j.job_title, c.company_name, j.city, j.work_mode, j.min_salary_lpa, j.max_salary_lpa
FROM job_postings j
JOIN companies c ON j.company_id = c.company_id
WHERE j.field = 'Data & Analytics'
  AND j.experience_level = 'Fresher'
  AND j.work_mode IN ('Remote', 'Hybrid')
ORDER BY j.max_salary_lpa DESC
LIMIT 10;

-- Q32. Most in-demand skills for data & analytics roles.
SELECT 'SQL' AS skill, COUNT(*) AS postings FROM job_postings WHERE field='Data & Analytics' AND skills_required LIKE '%SQL%'
UNION ALL
SELECT 'Excel', COUNT(*) FROM job_postings WHERE field='Data & Analytics' AND skills_required LIKE '%Excel%'
UNION ALL
SELECT 'Power BI', COUNT(*) FROM job_postings WHERE field='Data & Analytics' AND skills_required LIKE '%Power BI%'
UNION ALL
SELECT 'Tableau', COUNT(*) FROM job_postings WHERE field='Data & Analytics' AND skills_required LIKE '%Tableau%'
UNION ALL
SELECT 'Python', COUNT(*) FROM job_postings WHERE field='Data & Analytics' AND skills_required LIKE '%Python%'
ORDER BY postings DESC;
