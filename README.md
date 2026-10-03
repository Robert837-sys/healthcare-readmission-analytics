# Hospital Readmission Analytics

> 🚧 **Work in progress.** Data is loaded and being profiled. Cleaning and the dashboard are next.

An end-to-end data analysis project on real hospital data: load a raw, dirty CSV into PostgreSQL, clean it with reproducible SQL, and present the findings in a Power BI dashboard.

## The Problem

When a patient returns to hospital shortly after discharge, it often means something went wrong: discharge came too early, follow-up care was missing, or the condition wasn't well managed. Readmissions are costly and often preventable, so hospitals and insurers track them closely.

This project uses diabetic patient records to answer:

- What is the overall 30-day readmission rate?
- Which age groups, genders and races are readmitted more often?
- Does length of stay or the number of prior inpatient visits relate to readmission?
- Which diagnosis categories, medical specialties and admission sources drive readmissions?
- Do medication changes or HbA1c testing relate to outcomes?

## Dataset

**Diabetes 130-US Hospitals for Years 1999-2008**, from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/296/diabetes-130-us-hospitals-for-years-1999-2008) (CC BY 4.0).

- 101,766 hospital encounters, 50 columns
- Naturally dirty: missing values stored as `?`, a column that is about 97% empty, ranges stored as text, numeric ID codes, repeat patients

## Pipeline

```
Raw CSV  →  PostgreSQL staging (all TEXT)  →  SQL cleaning  →  Clean table + views  →  Power BI
```

**Why this approach:** the raw data is loaded untouched as text so the import never fails on a bad value. All cleaning is written as SQL, so every decision is visible, reviewable and repeatable.

## Tools

PostgreSQL · SQL (DBeaver) · Power BI

## Progress

- [x] Project documentation and plan
- [x] Database created and raw CSV loaded into a staging table (101,766 rows)
- [ ] Data profiling (missing values, duplicates, invalid categories) *← in progress*
- [ ] SQL cleaning into a typed `clean_encounters` table
- [ ] Lookup tables and analysis views
- [ ] Analytical SQL queries
- [ ] Power BI dashboard
- [ ] Final findings write-up

## Early Profiling Findings

| Column | Missing | Share |
|---|---|---|
| `weight` | 98,569 | 96.9% |
| `medical_specialty` | 49,949 | 49.1% |
| `payer_code` | 40,256 | 39.6% |
| `race` | 2,273 | 2.2% |
| `diag_3` | 1,423 | 1.4% |
| `diag_2` | 358 | 0.4% |
| `diag_1` | 21 | 0.02% |

`weight` will be dropped. Other `?` values become NULL. In the glucose and HbA1c columns, "None" means the test wasn't performed, so it is kept as its own category.

## Repository Structure

```
healthcare-readmission-analytics/
├── data/raw/       original CSV files
├── sql/            SQL scripts, run in numbered order
├── powerbi/        dashboard file and screenshots (coming)
├── docs/           full project documentation
└── README.md
```

## Limitations

- US hospitals, 1999-2008, diabetic patients only. Findings should not be generalised to other populations or conditions.
- Readmission patterns here are associations, not proof of cause.
- The data is de-identified, and no attempt is made to identify individuals.

## Author

**Robert Owuor Agie**, Computer Science (Data Analytics), University of Eldoret, Kenya
GitHub: [Robert837-sys](https://github.com/Robert837-sys)

*Dataset credit: Strack et al., "Impact of HbA1c Measurement on Hospital Readmission Rates", via the UCI Machine Learning Repository.*