-- 1. Repeat patients and duplicate encounters
SELECT COUNT(*)                                  AS total_encounters,
       COUNT(DISTINCT patient_nbr)               AS unique_patients,
       COUNT(*) - COUNT(DISTINCT patient_nbr)    AS repeat_encounters,
       COUNT(*) - COUNT(DISTINCT encounter_id)   AS duplicate_encounter_ids
FROM stg_diabetes;

-- 2. Gender values
SELECT gender, COUNT(*) FROM stg_diabetes GROUP BY gender ORDER BY 2 DESC;

-- 3. Patients who died or went to hospice (can't be readmitted)
SELECT discharge_disposition_id, COUNT(*)
FROM stg_diabetes
WHERE discharge_disposition_id IN ('11','13','14','19','20','21')
GROUP BY 1 ORDER BY 1;