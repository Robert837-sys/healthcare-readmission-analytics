CREATE DATABASE healthcare_analytics;
\c healthcare_analytics
SELECT current_database();

CREATE TABLE stg_diabetes (
  encounter_id TEXT, patient_nbr TEXT, race TEXT, gender TEXT, age TEXT,
  weight TEXT, admission_type_id TEXT, discharge_disposition_id TEXT,
  admission_source_id TEXT, time_in_hospital TEXT, payer_code TEXT,
  medical_specialty TEXT, num_lab_procedures TEXT, num_procedures TEXT,
  num_medications TEXT, number_outpatient TEXT, number_emergency TEXT,
  number_inpatient TEXT, diag_1 TEXT, diag_2 TEXT, diag_3 TEXT,
  number_diagnoses TEXT, max_glu_serum TEXT, a1cresult TEXT,
  metformin TEXT, repaglinide TEXT, nateglinide TEXT, chlorpropamide TEXT,
  glimepiride TEXT, acetohexamide TEXT, glipizide TEXT, glyburide TEXT,
  tolbutamide TEXT, pioglitazone TEXT, rosiglitazone TEXT, acarbose TEXT,
  miglitol TEXT, troglitazone TEXT, tolazamide TEXT, examide TEXT,
  citoglipton TEXT, insulin TEXT, glyburide_metformin TEXT,
  glipizide_metformin TEXT, glimepiride_pioglitazone TEXT,
  metformin_rosiglitazone TEXT, metformin_pioglitazone TEXT,
  change TEXT, diabetesmed TEXT, readmitted TEXT
);

\copy stg_diabetes FROM 'C:/Users/rober/OneDrive/Documents/healthcare-readmission-analytics/data/raw/diabetes+130-us+hospitals+for+years+1999-2008/diabetic_data.csv' WITH (FORMAT csv, HEADER true)

SELECT COUNT(*) FROM stg_diabetes;

SELECT
  COUNT(*)                                          AS total_rows,
  COUNT(*) FILTER (WHERE race = '?')                AS race_missing,
  COUNT(*) FILTER (WHERE weight = '?')              AS weight_missing,
  COUNT(*) FILTER (WHERE payer_code = '?')          AS payer_code_missing,
  COUNT(*) FILTER (WHERE medical_specialty = '?')   AS specialty_missing,
  COUNT(*) FILTER (WHERE diag_1 = '?')              AS diag_1_missing,
  COUNT(*) FILTER (WHERE diag_2 = '?')              AS diag_2_missing,
  COUNT(*) FILTER (WHERE diag_3 = '?')              AS diag_3_missing,
  COUNT(*) FILTER (WHERE max_glu_serum = 'None')    AS glu_not_tested,
  COUNT(*) FILTER (WHERE a1cresult = 'None')        AS a1c_not_tested
FROM stg_diabetes;