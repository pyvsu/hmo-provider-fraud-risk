-- =============================================================================
-- 02_cleaning.sql
-- HMO Provider Fraud Risk Analytics -- Phase 2: Data Cleaning
-- =============================================================================
-- Builds the `clean` BigQuery dataset: one reusable function + 3 clean views
-- on top of `raw`. Fixes value-level issues found during inspection
-- (see 01_inspection.sql) -- placeholder text, type mismatches, unclear
-- column names, uncoded categorical values. Run top to bottom, in order.
--
-- Verified: all 3 clean views match their raw source row count exactly
-- (138,556 / 40,474 / 517,737) -- zero rows lost or duplicated.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1. Create the `clean` dataset
-- -----------------------------------------------------------------------------
-- Location must match `raw` (US) so cross-dataset queries work.

CREATE SCHEMA IF NOT EXISTS `hmo-provider-fraud-risk.clean`
OPTIONS (location = "US");


-- -----------------------------------------------------------------------------
-- 2. Function: clean_placeholder
-- -----------------------------------------------------------------------------
-- Source data contains literal placeholder text ("NA", "N/A", "NULL", "NONE")
-- stored as actual STRING values instead of true SQL NULLs -- confirmed via a
-- full true_null / empty_string / placeholder_text audit across all 3 raw
-- tables (see 01_inspection.sql). Collapses all placeholder variants (plus
-- genuinely empty strings) into a real NULL. Reused across clean_inpatient
-- and clean_outpatient, which have 19 affected columns each.

CREATE OR REPLACE FUNCTION `hmo-provider-fraud-risk.clean.clean_placeholder`(val STRING)
RETURNS STRING
AS (
  CASE
    WHEN val IS NULL THEN NULL
    WHEN UPPER(TRIM(val)) IN ('NA', 'N/A', 'NULL', 'NONE', '') THEN NULL
    ELSE val
  END
);


-- -----------------------------------------------------------------------------
-- 3. View: clean_beneficiary
-- -----------------------------------------------------------------------------
-- Fixes applied:
--   - DateOfDeath: placeholder text -> NULL, then cast STRING -> DATE
--   - Gender / Race / State: decoded from CMS/SSA numeric codes to labels
--     (source: CMS Blue Button official documentation)
--   - RenalDiseaseIndicator: standardized to boolean (was '0'/'Y' text,
--     inconsistent with the numeric ChronicCond_* columns)
--   - ChronicCond_* (11 columns): converted from 1/2 coding to readable boolean
--   - 13 columns renamed for clarity (DOD -> DateOfDeath, IP/OP abbreviations
--     spelled out, ChronicCond_Osteoporasis typo fixed, casing standardized)
--
-- Not decoded: County -- no reliable compact SSA state+county lookup table
-- available; left as the raw numeric code rather than guessing.
--
-- Note: 27 beneficiaries have negative annual reimbursement amounts with zero
-- underlying claims on record (investigated -- confirmed synthetic data
-- generation artifact from this dataset's CMS DE-SynPUF origin, not a real
-- billing event). Left as-is intentionally; do not silently zero/clip.

CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.clean.clean_beneficiary` AS
SELECT
  BeneID,
  DOB AS DateOfBirth,
  SAFE_CAST(`hmo-provider-fraud-risk.clean.clean_placeholder`(DOD) AS DATE) AS DateOfDeath,

  CASE Gender WHEN 1 THEN 'Male' WHEN 2 THEN 'Female' ELSE 'Unknown' END AS Gender,

  CASE Race
    WHEN 0 THEN 'Unknown' WHEN 1 THEN 'White' WHEN 2 THEN 'Black'
    WHEN 3 THEN 'Other' WHEN 4 THEN 'Asian' WHEN 5 THEN 'Hispanic'
    WHEN 6 THEN 'North American Native' ELSE 'Unknown'
  END AS Race,

  RenalDiseaseIndicator = 'Y' AS HasRenalDisease,

  CASE State
    WHEN 1 THEN 'Alabama' WHEN 2 THEN 'Alaska' WHEN 3 THEN 'Arizona' WHEN 4 THEN 'Arkansas'
    WHEN 5 THEN 'California' WHEN 6 THEN 'Colorado' WHEN 7 THEN 'Connecticut' WHEN 8 THEN 'Delaware'
    WHEN 9 THEN 'District of Columbia' WHEN 10 THEN 'Florida' WHEN 11 THEN 'Georgia' WHEN 12 THEN 'Hawaii'
    WHEN 13 THEN 'Idaho' WHEN 14 THEN 'Illinois' WHEN 15 THEN 'Indiana' WHEN 16 THEN 'Iowa'
    WHEN 17 THEN 'Kansas' WHEN 18 THEN 'Kentucky' WHEN 19 THEN 'Louisiana' WHEN 20 THEN 'Maine'
    WHEN 21 THEN 'Maryland' WHEN 22 THEN 'Massachusetts' WHEN 23 THEN 'Michigan' WHEN 24 THEN 'Minnesota'
    WHEN 25 THEN 'Mississippi' WHEN 26 THEN 'Missouri' WHEN 27 THEN 'Montana' WHEN 28 THEN 'Nebraska'
    WHEN 29 THEN 'Nevada' WHEN 30 THEN 'New Hampshire' WHEN 31 THEN 'New Jersey' WHEN 32 THEN 'New Mexico'
    WHEN 33 THEN 'New York' WHEN 34 THEN 'North Carolina' WHEN 35 THEN 'North Dakota' WHEN 36 THEN 'Ohio'
    WHEN 37 THEN 'Oklahoma' WHEN 38 THEN 'Oregon' WHEN 39 THEN 'Pennsylvania' WHEN 40 THEN 'Puerto Rico'
    WHEN 41 THEN 'Rhode Island' WHEN 42 THEN 'South Carolina' WHEN 43 THEN 'South Dakota' WHEN 44 THEN 'Tennessee'
    WHEN 45 THEN 'Texas' WHEN 46 THEN 'Utah' WHEN 47 THEN 'Vermont' WHEN 48 THEN 'Virgin Islands'
    WHEN 49 THEN 'Virginia' WHEN 50 THEN 'Washington' WHEN 51 THEN 'West Virginia' WHEN 52 THEN 'Wisconsin'
    WHEN 53 THEN 'Wyoming' WHEN 54 THEN 'Africa (SSA code)' ELSE 'Unknown/Other'
  END AS State,

  County,  -- left as raw SSA code; no reliable compact lookup available

  NoOfMonths_PartACov AS MonthsCovered_MedicarePartA,
  NoOfMonths_PartBCov AS MonthsCovered_MedicarePartB,

  ChronicCond_Alzheimer = 1 AS HasAlzheimer,
  ChronicCond_Heartfailure = 1 AS HasHeartFailure,
  ChronicCond_KidneyDisease = 1 AS HasKidneyDisease,
  ChronicCond_Cancer = 1 AS HasCancer,
  ChronicCond_ObstrPulmonary = 1 AS HasObstrPulmonary,
  ChronicCond_Depression = 1 AS HasDepression,
  ChronicCond_Diabetes = 1 AS HasDiabetes,
  ChronicCond_IschemicHeart = 1 AS HasIschemicHeart,
  ChronicCond_Osteoporasis = 1 AS HasOsteoporosis,
  ChronicCond_rheumatoidarthritis = 1 AS HasRheumatoidArthritis,
  ChronicCond_stroke = 1 AS HasStroke,

  -- 15 rows negative with zero underlying claims -- synthetic data artifact,
  -- documented above. Left as-is.
  IPAnnualReimbursementAmt AS InpatientAnnualReimbursementAmt,
  IPAnnualDeductibleAmt AS InpatientAnnualDeductibleAmt,
  OPAnnualReimbursementAmt AS OutpatientAnnualReimbursementAmt,
  OPAnnualDeductibleAmt AS OutpatientAnnualDeductibleAmt

FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`;


-- -----------------------------------------------------------------------------
-- 4. View: clean_inpatient
-- -----------------------------------------------------------------------------
-- Fixes applied:
--   - Placeholder text -> real NULL across 19 columns: AttendingPhysician,
--     OperatingPhysician, OtherPhysician, DeductibleAmtPaid,
--     ClmDiagnosisCode_2-10, ClmProcedureCode_1-6
--   - DeductibleAmtPaid: placeholder fix + cast STRING -> INT64. Root cause of
--     the original STRING typing: 899 rows contained literal "NULL" text
--     mixed with real numbers (confirmed value when present: $1,068, the
--     fixed 2009 Medicare Part A inpatient deductible).
--   - Columns renamed for clarity (InscClaimAmtReimbursed ->
--     InsuranceClaimAmtReimbursed, ClmAdmitDiagnosisCode ->
--     ClaimAdmitDiagnosisCode)
--   - ClmProcedureCode_6 dropped: confirmed 100% empty (0 non-null values
--     across all 40,474 rows), zero information.

CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.clean.clean_inpatient` AS
SELECT
  BeneID,
  ClaimID,
  ClaimStartDt,
  ClaimEndDt,
  Provider,
  InscClaimAmtReimbursed AS InsuranceClaimAmtReimbursed,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(AttendingPhysician) AS AttendingPhysician,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(OperatingPhysician) AS OperatingPhysician,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(OtherPhysician) AS OtherPhysician,
  AdmissionDt,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmAdmitDiagnosisCode) AS ClaimAdmitDiagnosisCode,
  SAFE_CAST(`hmo-provider-fraud-risk.clean.clean_placeholder`(DeductibleAmtPaid) AS INT64) AS DeductibleAmtPaid,
  DischargeDt,
  DiagnosisGroupCode,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_1) AS ClmDiagnosisCode_1,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_2) AS ClmDiagnosisCode_2,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_3) AS ClmDiagnosisCode_3,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_4) AS ClmDiagnosisCode_4,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_5) AS ClmDiagnosisCode_5,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_6) AS ClmDiagnosisCode_6,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_7) AS ClmDiagnosisCode_7,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_8) AS ClmDiagnosisCode_8,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_9) AS ClmDiagnosisCode_9,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_10) AS ClmDiagnosisCode_10,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_1) AS ClmProcedureCode_1,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_2) AS ClmProcedureCode_2,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_3) AS ClmProcedureCode_3,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_4) AS ClmProcedureCode_4,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_5) AS ClmProcedureCode_5
  -- ClmProcedureCode_6 dropped: 100% empty across all 40,474 rows
FROM `hmo-provider-fraud-risk.raw.raw_inpatient`;


-- -----------------------------------------------------------------------------
-- 5. View: clean_outpatient
-- -----------------------------------------------------------------------------
-- Fixes applied:
--   - Placeholder text -> real NULL across 19 columns: AttendingPhysician,
--     OperatingPhysician, OtherPhysician, ClmDiagnosisCode_1-10,
--     ClmProcedureCode_1-4
--   - Columns renamed for clarity (InscClaimAmtReimbursed ->
--     InsuranceClaimAmtReimbursed, ClmAdmitDiagnosisCode ->
--     ClaimAdmitDiagnosisCode)
--   - ClmProcedureCode_5 and ClmProcedureCode_6 dropped: both confirmed 100%
--     empty (0 non-null values across all 517,737 rows), zero information.
--
-- Not touched: DeductibleAmtPaid -- confirmed already clean INT64, no
-- placeholder text found (unlike the same field in raw_inpatient, which is
-- why that table needed the extra CAST). ClmAdmitDiagnosisCode's missingness
-- (79.6%) is genuine empty string, not placeholder text -- investigated
-- separately; no fix needed, treated as a normal nullable field.

CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.clean.clean_outpatient` AS
SELECT
  BeneID,
  ClaimID,
  ClaimStartDt,
  ClaimEndDt,
  Provider,
  InscClaimAmtReimbursed AS InsuranceClaimAmtReimbursed,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(AttendingPhysician) AS AttendingPhysician,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(OperatingPhysician) AS OperatingPhysician,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(OtherPhysician) AS OtherPhysician,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_1) AS ClmDiagnosisCode_1,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_2) AS ClmDiagnosisCode_2,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_3) AS ClmDiagnosisCode_3,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_4) AS ClmDiagnosisCode_4,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_5) AS ClmDiagnosisCode_5,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_6) AS ClmDiagnosisCode_6,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_7) AS ClmDiagnosisCode_7,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_8) AS ClmDiagnosisCode_8,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_9) AS ClmDiagnosisCode_9,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmDiagnosisCode_10) AS ClmDiagnosisCode_10,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_1) AS ClmProcedureCode_1,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_2) AS ClmProcedureCode_2,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_3) AS ClmProcedureCode_3,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmProcedureCode_4) AS ClmProcedureCode_4,
  -- ClmProcedureCode_5, ClmProcedureCode_6 dropped: 100% empty across all 517,737 rows
  DeductibleAmtPaid,
  `hmo-provider-fraud-risk.clean.clean_placeholder`(ClmAdmitDiagnosisCode) AS ClaimAdmitDiagnosisCode
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`;


-- -----------------------------------------------------------------------------
-- 6. Verification: clean view row counts vs. raw source
-- -----------------------------------------------------------------------------
-- Views reshape data -- they never filter rows, so counts must match the raw
-- source exactly.
--
-- Confirmed result (last run): all 3 tables match exactly.
--   raw_beneficiary: 138,556 = 138,556
--   raw_inpatient:    40,474 =  40,474
--   raw_outpatient:  517,737 = 517,737

SELECT 'raw_beneficiary' AS raw_table, COUNT(*) AS raw_rows,
       (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.clean.clean_beneficiary`) AS clean_rows
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL
SELECT 'raw_inpatient', COUNT(*),
       (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.clean.clean_inpatient`)
FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL
SELECT 'raw_outpatient', COUNT(*),
       (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.clean.clean_outpatient`)
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`;
