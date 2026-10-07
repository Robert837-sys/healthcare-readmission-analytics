-- Q2: readmission rate by age group
SELECT age_group,
       COUNT(*)                                              AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY age_group
ORDER BY age_group;

-- Q3: readmission rate by length of stay (days)
SELECT time_in_hospital AS days_in_hospital,
       COUNT(*)                                              AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY time_in_hospital
ORDER BY time_in_hospital;

-- Q2: readmission rate by age group
SELECT age_group,
       COUNT(*)                                              AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY age_group
ORDER BY age_group;

-- Q3: readmission rate by length of stay (days)
SELECT time_in_hospital AS days_in_hospital,
       COUNT(*)                                              AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY time_in_hospital
ORDER BY time_in_hospital;

-- Q4: readmission rate by number of prior inpatient visits (capped at 5+)
SELECT LEAST(number_inpatient, 5)                              AS prior_inpatient_visits,
       COUNT(*)                                                AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2)   AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY 1 ORDER BY 1;

-- Q5: readmission rate by medical specialty (known specialties, 500+ encounters)
SELECT medical_specialty,
       COUNT(*)                                                AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2)   AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
  AND medical_specialty IS NOT NULL
GROUP BY 1
HAVING COUNT(*) >= 500
ORDER BY rate_pct DESC;

-- Q6: readmission rate by diabetes medication change
SELECT change AS med_changed,
       COUNT(*) AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY change ORDER BY change;

-- Q7: readmission rate by HbA1c test result
SELECT a1cresult,
       COUNT(*) AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY a1cresult ORDER BY rate_pct DESC;