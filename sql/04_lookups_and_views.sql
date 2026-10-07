CREATE VIEW vw_encounters_analysis AS
WITH base AS (
  SELECT c.*,
         CASE WHEN diag_1 ~ '^[0-9]' THEN diag_1::NUMERIC END AS diag_num
  FROM clean_encounters c
)
SELECT
  b.encounter_id, b.patient_nbr, b.race, b.gender, b.age_group, b.age_midpoint,
  at.description  AS admission_type,
  dd.description  AS discharge_disposition,
  asr.description AS admission_source,
  b.time_in_hospital, b.payer_code, b.medical_specialty,
  b.num_lab_procedures, b.num_procedures, b.num_medications,
  b.number_outpatient, b.number_emergency, b.number_inpatient,
  CASE
    WHEN b.diag_1 IS NULL                              THEN NULL
    WHEN b.diag_num >= 250 AND b.diag_num < 251        THEN 'Diabetes'
    WHEN b.diag_num BETWEEN 390 AND 459 OR b.diag_num = 785 THEN 'Circulatory'
    WHEN b.diag_num BETWEEN 460 AND 519 OR b.diag_num = 786 THEN 'Respiratory'
    WHEN b.diag_num BETWEEN 520 AND 579 OR b.diag_num = 787 THEN 'Digestive'
    WHEN b.diag_num BETWEEN 580 AND 629 OR b.diag_num = 788 THEN 'Genitourinary'
    WHEN b.diag_num >= 800 AND b.diag_num < 1000       THEN 'Injury'
    WHEN b.diag_num >= 710 AND b.diag_num < 740        THEN 'Musculoskeletal'
    WHEN b.diag_num >= 140 AND b.diag_num < 240        THEN 'Neoplasms'
    ELSE 'Other'
  END AS diagnosis_category,
  b.number_diagnoses, b.max_glu_serum, b.a1cresult, b.insulin,
  b.change, b.diabetesmed,
  b.readmission_status, b.readmitted_30d_flag,
  b.is_first_encounter, b.exclude_from_readmission,
  CASE WHEN at.description  IS NULL OR at.description  IN ('NULL','Not Available','Not Mapped','Unknown/Invalid') THEN 1 ELSE 0 END AS admission_type_unknown,
  CASE WHEN dd.description  IS NULL OR dd.description  IN ('NULL','Not Available','Not Mapped','Unknown/Invalid') THEN 1 ELSE 0 END AS discharge_unknown,
  CASE WHEN asr.description IS NULL OR asr.description IN ('NULL','Not Available','Not Mapped','Unknown/Invalid') THEN 1 ELSE 0 END AS admission_source_unknown
FROM base b
LEFT JOIN lkp_admission_type        at  ON b.admission_type_id        = at.admission_type_id
LEFT JOIN lkp_discharge_disposition dd  ON b.discharge_disposition_id = dd.discharge_disposition_id
LEFT JOIN lkp_admission_source      asr ON b.admission_source_id      = asr.admission_source_id;



-- 1. No rows lost or duplicated by the joins
SELECT COUNT(*) FROM vw_encounters_analysis;

-- 2. Diagnosis categories and their readmission rates
SELECT diagnosis_category,
       COUNT(*) AS encounters,
       ROUND(100.0 * SUM(readmitted_30d_flag) / COUNT(*), 2) AS rate_pct
FROM vw_encounters_analysis
WHERE exclude_from_readmission = 0
GROUP BY 1 ORDER BY 2 DESC;

-- 3. Quoted descriptions survived the load
SELECT discharge_disposition, COUNT(*)
FROM vw_encounters_analysis
WHERE discharge_disposition LIKE 'Expired%'
GROUP BY 1;