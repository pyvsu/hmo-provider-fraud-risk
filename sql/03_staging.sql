-- =====================================================================
-- Phase 3: Data Modeling — Staging Layer
-- Project: HMO Provider Fraud Risk Analytics
-- GCP Project: hmo-provider-fraud-risk
--
-- Purpose: structural transformation on top of the `clean` dataset.
-- Combines inpatient + outpatient claims into a single grain (fact_claims
-- source), adds calculated columns, and unpivots wide diagnosis/procedure
-- columns into bridge tables for many-to-many relationships.
--
-- Does NOT modify anything in `clean` — all views here read from `clean`
-- and write into the `staging` dataset.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 0. Create the staging dataset (run once)
-- ---------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hmo-provider-fraud-risk.staging`
OPTIONS (location = "US");


-- ---------------------------------------------------------------------
-- 1. staging_claims
-- Combines clean_inpatient + clean_outpatient into one row-per-claim
-- table (UNION ALL — same grain, no dedup), tagged with claim_type.
-- Outpatient claims have no admission/discharge/DiagnosisGroupCode or
-- 5th procedure code, so these are padded with NULL to match schemas.
--
-- Adds 5 calculated columns (row-level, non-aggregating — DAX is
-- reserved for Phase 4 aggregating measures only):
--   1. claim_duration_days   — ClaimEndDt - ClaimStartDt
--   2. length_of_stay_days   — DischargeDt - AdmissionDt (inpatient only, NULL for outpatient)
--   3. diagnosis_code_count  — count of non-null diagnosis codes (1-10)
--   4. age_at_claim          — beneficiary age at ClaimStartDt
--   5. is_deceased_at_claim  — TRUE if beneficiary died on/before ClaimStartDt
--   6. days_since_provider_last_claim — days since this provider's previous claim (NULL for first claim)
--
-- Row count verified: 558,211 (40,474 inpatient + 517,737 outpatient)
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.staging.staging_claims` AS

WITH combined AS (
  SELECT
    ClaimID, BeneID, Provider, 'Inpatient' AS claim_type,
    ClaimStartDt, ClaimEndDt, InsuranceClaimAmtReimbursed, DeductibleAmtPaid,
    AttendingPhysician, OperatingPhysician, OtherPhysician,
    AdmissionDt, DischargeDt, ClaimAdmitDiagnosisCode, DiagnosisGroupCode,
    ClmDiagnosisCode_1, ClmDiagnosisCode_2, ClmDiagnosisCode_3, ClmDiagnosisCode_4, ClmDiagnosisCode_5,
    ClmDiagnosisCode_6, ClmDiagnosisCode_7, ClmDiagnosisCode_8, ClmDiagnosisCode_9, ClmDiagnosisCode_10,
    ClmProcedureCode_1, ClmProcedureCode_2, ClmProcedureCode_3, ClmProcedureCode_4, ClmProcedureCode_5
  FROM `hmo-provider-fraud-risk.clean.clean_inpatient`

  UNION ALL

  SELECT
    ClaimID, BeneID, Provider, 'Outpatient' AS claim_type,
    ClaimStartDt, ClaimEndDt, InsuranceClaimAmtReimbursed, DeductibleAmtPaid,
    AttendingPhysician, OperatingPhysician, OtherPhysician,
    CAST(NULL AS DATE) AS AdmissionDt,
    CAST(NULL AS DATE) AS DischargeDt,
    ClaimAdmitDiagnosisCode,
    CAST(NULL AS STRING) AS DiagnosisGroupCode,
    ClmDiagnosisCode_1, ClmDiagnosisCode_2, ClmDiagnosisCode_3, ClmDiagnosisCode_4, ClmDiagnosisCode_5,
    ClmDiagnosisCode_6, ClmDiagnosisCode_7, ClmDiagnosisCode_8, ClmDiagnosisCode_9, ClmDiagnosisCode_10,
    ClmProcedureCode_1, ClmProcedureCode_2, ClmProcedureCode_3, ClmProcedureCode_4,
    CAST(NULL AS STRING) AS ClmProcedureCode_5
  FROM `hmo-provider-fraud-risk.clean.clean_outpatient`
)

SELECT
  c.*,

  -- Col 1: claim_duration_days
  DATE_DIFF(c.ClaimEndDt, c.ClaimStartDt, DAY) AS claim_duration_days,

  -- Col 2: length_of_stay_days (NULL for outpatient — no admission/discharge)
  DATE_DIFF(c.DischargeDt, c.AdmissionDt, DAY) AS length_of_stay_days,

  -- Col 3: diagnosis_code_count — count of non-null diagnosis code slots
  (CASE WHEN c.ClmDiagnosisCode_1 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_2 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_3 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_4 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_5 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_6 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_7 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_8 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_9 IS NOT NULL THEN 1 ELSE 0 END)
  + (CASE WHEN c.ClmDiagnosisCode_10 IS NOT NULL THEN 1 ELSE 0 END)
    AS diagnosis_code_count,

  -- Col 4: age_at_claim — beneficiary's age as of the claim start date
  DATE_DIFF(c.ClaimStartDt, b.DateOfBirth, YEAR) AS age_at_claim,

  -- Col 5: is_deceased_at_claim — TRUE if death date is on/before claim start
  CASE
    WHEN b.DateOfDeath IS NOT NULL AND b.DateOfDeath <= c.ClaimStartDt THEN TRUE
    ELSE FALSE
  END AS is_deceased_at_claim,

  -- Col 6: days_since_provider_last_claim — days since this provider's
  -- previous claim (ordered by ClaimStartDt). NULL for each provider's
  -- first claim, since there is no prior claim to compare against.
  DATE_DIFF(
    c.ClaimStartDt,
    LAG(c.ClaimStartDt) OVER (PARTITION BY c.Provider ORDER BY c.ClaimStartDt),
    DAY
  ) AS days_since_provider_last_claim

FROM combined c
LEFT JOIN `hmo-provider-fraud-risk.clean.clean_beneficiary` b
  ON c.BeneID = b.BeneID;


-- ---------------------------------------------------------------------
-- 2. staging_claim_diagnosis (bridge table)
-- Unpivots the 10 wide ClmDiagnosisCode_1..10 columns into one row per
-- (ClaimID, diagnosis_code) pair. Needed because a claim can have
-- multiple diagnosis codes, and a code can appear across many claims —
-- a many-to-many relationship that a direct fact-to-dimension link
-- cannot represent. NULL codes are dropped (empty diagnosis slots).
--
-- Row count verified: 1,680,716
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.staging.staging_claim_diagnosis` AS

SELECT ClaimID, diagnosis_code
FROM `hmo-provider-fraud-risk.staging.staging_claims`,
UNNEST([
  ClmDiagnosisCode_1, ClmDiagnosisCode_2, ClmDiagnosisCode_3, ClmDiagnosisCode_4, ClmDiagnosisCode_5,
  ClmDiagnosisCode_6, ClmDiagnosisCode_7, ClmDiagnosisCode_8, ClmDiagnosisCode_9, ClmDiagnosisCode_10
]) AS diagnosis_code
WHERE diagnosis_code IS NOT NULL;


-- ---------------------------------------------------------------------
-- 3. staging_dim_diagnosis (dimension table)
-- One row per unique diagnosis code, with a surrogate key
-- (diagnosis_key) generated via ROW_NUMBER(). Code-only — no
-- description column, since the Kaggle dataset provides no ICD-9
-- lookup reference (decision: skip descriptions, codes are sufficient
-- for pattern-detection business questions).
--
-- Row count verified: 11,014 unique codes
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.staging.staging_dim_diagnosis` AS

SELECT
  ROW_NUMBER() OVER (ORDER BY diagnosis_code) AS diagnosis_key,
  diagnosis_code
FROM (
  SELECT DISTINCT diagnosis_code
  FROM `hmo-provider-fraud-risk.staging.staging_claim_diagnosis`
);


-- ---------------------------------------------------------------------
-- 4. staging_claim_procedure (bridge table)
-- Same unpivot pattern as diagnosis, applied to the 5 wide
-- ClmProcedureCode_1..5 columns. Needed for the business question:
-- "Do certain diagnosis or procedure codes show up more often in
-- flagged claims?" — which explicitly covers procedure codes too.
--
-- Row count verified: 29,896
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.staging.staging_claim_procedure` AS

SELECT ClaimID, procedure_code
FROM `hmo-provider-fraud-risk.staging.staging_claims`,
UNNEST([
  ClmProcedureCode_1, ClmProcedureCode_2, ClmProcedureCode_3, ClmProcedureCode_4, ClmProcedureCode_5
]) AS procedure_code
WHERE procedure_code IS NOT NULL;


-- ---------------------------------------------------------------------
-- 5. staging_dim_procedure (dimension table)
-- One row per unique procedure code, with a surrogate key
-- (procedure_key). Same code-only approach as dim_diagnosis.
--
-- Row count verified: 1,324 unique codes
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW `hmo-provider-fraud-risk.staging.staging_dim_procedure` AS

SELECT
  ROW_NUMBER() OVER (ORDER BY procedure_code) AS procedure_key,
  procedure_code
FROM (
  SELECT DISTINCT procedure_code
  FROM `hmo-provider-fraud-risk.staging.staging_claim_procedure`
);


-- =====================================================================
-- Verification queries (not part of the model — run manually to confirm)
-- =====================================================================

-- staging_claims row count should equal clean_inpatient + clean_outpatient
-- Verified: 40,474 + 517,737 = 558,211
SELECT
  (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.clean.clean_inpatient`) AS inpatient_count,
  (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.clean.clean_outpatient`) AS outpatient_count,
  (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.staging.staging_claims`) AS staging_claims_count;

-- Bridge tables should have far more rows than their dimension tables
-- Verified: diagnosis 1,680,716 rows -> 11,014 unique codes
--           procedure    29,896 rows ->  1,324 unique codes
SELECT
  (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.staging.staging_claim_diagnosis`) AS diagnosis_bridge_rows,
  (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.staging.staging_dim_diagnosis`) AS diagnosis_unique_codes,
  (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.staging.staging_claim_procedure`) AS procedure_bridge_rows,
  (SELECT COUNT(*) FROM `hmo-provider-fraud-risk.staging.staging_dim_procedure`) AS procedure_unique_codes;
