CREATE TABLE clean_encounters AS
SELECT
  encounter_id::INT,
  patient_nbr::INT,
  NULLIF(race, '?')                          AS race,
  NULLIF(gender, 'Unknown/Invalid')          AS gender,
  age                                        AS age_group,
  SUBSTRING(age FROM '\[(\d+)-')::INT + 5    AS age_midpoint,
  admission_type_id::INT,
  discharge_disposition_id::INT,
  admission_source_id::INT,
  time_in_hospital::INT,
  NULLIF(payer_code, '?')                    AS payer_code,
  NULLIF(medical_specialty, '?')             AS medical_specialty,
  num_lab_procedures::INT,
  num_procedures::INT,
  num_medications::INT,
  number_outpatient::INT,
  number_emergency::INT,
  number_inpatient::INT,
  NULLIF(diag_1, '?')                        AS diag_1,
  NULLIF(diag_2, '?')                        AS diag_2,
  NULLIF(diag_3, '?')                        AS diag_3,
  number_diagnoses::INT,
  max_glu_serum,
  a1cresult,
  metformin, repaglinide, nateglinide, chlorpropamide, glimepiride,
  acetohexamide, glipizide, glyburide, tolbutamide, pioglitazone,
  rosiglitazone, acarbose, miglitol, troglitazone, tolazamide, examide,
  citoglipton, insulin, glyburide_metformin, glipizide_metformin,
  glimepiride_pioglitazone, metformin_rosiglitazone, metformin_pioglitazone,
  change,
  diabetesmed,
  readmitted
FROM stg_diabetes;

SELECT COUNT(*)                                    AS total_rows,
       COUNT(*) FILTER (WHERE race IS NULL)        AS race_null,
       COUNT(*) FILTER (WHERE gender IS NULL)      AS gender_null,
       COUNT(*) FILTER (WHERE medical_specialty IS NULL) AS specialty_null,
       MIN(age_midpoint)                           AS min_age,
       MAX(age_midpoint)                           AS max_age
FROM clean_encounters;

SELECT * FROM clean_encounters;
ALTER TABLE clean_encounters 
	ADD COLUMN readmission_status TEXT,
	ADD COLUMN readmitted_30d_flag INT,
	ADD COLUMN is_first_encounter INT;

UPDATE clean_encounters 
SET readmission_status = CASE readmitted
	WHEN '<30' THEN 'Within 30 days'
	WHEN '>30' THEN 'After 30 days'
	ELSE 'Not readmitted' END,
	readmitted_30d_flag=CASE  WHEN readmitted='<30' THEN 1 ELSE 0 END;

UPDATE clean_encounters c
SET is_first_encounter = CASE WHEN r.rn=1 THEN 1 ELSE 0 END 
FROM(
	SELECT encounter_id,ROW_NUMBER() OVER (PARTITION BY patient_nbr ORDER BY encounter_id) AS rn 
	FROM clean_encounters 
) r 
WHERE c.encounter_id =r.encounter_id;

SELECT readmission_status,COUNT(*) AS encounters
FROM clean_encounters 
GROUP BY 1 ORDER BY 2 DESC;

SELECT SUM(is_first_encounter) AS first_encounters FROM clean_encounters;

ALTER TABLE clean_encounters
  ADD COLUMN exclude_from_readmission INT;

UPDATE clean_encounters
SET exclude_from_readmission =
  CASE WHEN discharge_disposition_id IN (11, 13, 14, 19, 20, 21) THEN 1 ELSE 0 END;

SELECT exclude_from_readmission,
       COUNT(*)                                   AS encounters,
       SUM(readmitted_30d_flag)                   AS readmitted_30d,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM clean_encounters
GROUP BY 1 ORDER BY 1;
	