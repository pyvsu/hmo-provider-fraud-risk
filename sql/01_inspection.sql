-- =====================================================================
-- 01_inspection.sql
-- HMO Provider Fraud Risk Analytics — Phase 2 Data Inspection
-- Target: hmo-provider-fraud-risk.raw (raw_beneficiary, raw_inpatient, raw_outpatient)
-- =====================================================================

-- ============================================================
-- 1. SCHEMA & COLUMN REVIEW
-- ============================================================
SELECT
  table_name,
  column_name,
  data_type,
  ordinal_position
FROM `hmo-provider-fraud-risk.raw.INFORMATION_SCHEMA.COLUMNS`
ORDER BY table_name, ordinal_position;


-- ============================================================
-- 2. DIMENSIONS — ROW COUNTS AND NULLS
-- ============================================================

-- 2a. Row counts
SELECT 'raw_beneficiary' AS table_name, COUNT(*) AS row_count FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL
SELECT 'raw_inpatient', COUNT(*) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL
SELECT 'raw_outpatient', COUNT(*) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`;

-- 2b. Null audit — raw_beneficiary
SELECT 'BeneID' AS column_name, COUNTIF(BeneID IS NULL) AS true_null, COUNTIF(TRIM(CAST(BeneID AS STRING))='') AS empty_string, COUNTIF(UPPER(TRIM(CAST(BeneID AS STRING))) IN ('NA','N/A','NULL','NONE')) AS placeholder_text FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'DOB', COUNTIF(DOB IS NULL), COUNTIF(TRIM(CAST(DOB AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(DOB AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'DOD', COUNTIF(DOD IS NULL), COUNTIF(TRIM(CAST(DOD AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(DOD AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'Gender', COUNTIF(Gender IS NULL), COUNTIF(TRIM(CAST(Gender AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(Gender AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'Race', COUNTIF(Race IS NULL), COUNTIF(TRIM(CAST(Race AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(Race AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'RenalDiseaseIndicator', COUNTIF(RenalDiseaseIndicator IS NULL), COUNTIF(TRIM(CAST(RenalDiseaseIndicator AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(RenalDiseaseIndicator AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'State', COUNTIF(State IS NULL), COUNTIF(TRIM(CAST(State AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(State AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'County', COUNTIF(County IS NULL), COUNTIF(TRIM(CAST(County AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(County AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'NoOfMonths_PartACov', COUNTIF(NoOfMonths_PartACov IS NULL), COUNTIF(TRIM(CAST(NoOfMonths_PartACov AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(NoOfMonths_PartACov AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'NoOfMonths_PartBCov', COUNTIF(NoOfMonths_PartBCov IS NULL), COUNTIF(TRIM(CAST(NoOfMonths_PartBCov AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(NoOfMonths_PartBCov AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_Alzheimer', COUNTIF(ChronicCond_Alzheimer IS NULL), COUNTIF(TRIM(CAST(ChronicCond_Alzheimer AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_Alzheimer AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_Heartfailure', COUNTIF(ChronicCond_Heartfailure IS NULL), COUNTIF(TRIM(CAST(ChronicCond_Heartfailure AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_Heartfailure AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_KidneyDisease', COUNTIF(ChronicCond_KidneyDisease IS NULL), COUNTIF(TRIM(CAST(ChronicCond_KidneyDisease AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_KidneyDisease AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_Cancer', COUNTIF(ChronicCond_Cancer IS NULL), COUNTIF(TRIM(CAST(ChronicCond_Cancer AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_Cancer AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_ObstrPulmonary', COUNTIF(ChronicCond_ObstrPulmonary IS NULL), COUNTIF(TRIM(CAST(ChronicCond_ObstrPulmonary AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_ObstrPulmonary AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_Depression', COUNTIF(ChronicCond_Depression IS NULL), COUNTIF(TRIM(CAST(ChronicCond_Depression AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_Depression AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_Diabetes', COUNTIF(ChronicCond_Diabetes IS NULL), COUNTIF(TRIM(CAST(ChronicCond_Diabetes AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_Diabetes AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_IschemicHeart', COUNTIF(ChronicCond_IschemicHeart IS NULL), COUNTIF(TRIM(CAST(ChronicCond_IschemicHeart AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_IschemicHeart AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_Osteoporasis', COUNTIF(ChronicCond_Osteoporasis IS NULL), COUNTIF(TRIM(CAST(ChronicCond_Osteoporasis AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_Osteoporasis AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_rheumatoidarthritis', COUNTIF(ChronicCond_rheumatoidarthritis IS NULL), COUNTIF(TRIM(CAST(ChronicCond_rheumatoidarthritis AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_rheumatoidarthritis AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'ChronicCond_stroke', COUNTIF(ChronicCond_stroke IS NULL), COUNTIF(TRIM(CAST(ChronicCond_stroke AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ChronicCond_stroke AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'IPAnnualReimbursementAmt', COUNTIF(IPAnnualReimbursementAmt IS NULL), COUNTIF(TRIM(CAST(IPAnnualReimbursementAmt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(IPAnnualReimbursementAmt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'IPAnnualDeductibleAmt', COUNTIF(IPAnnualDeductibleAmt IS NULL), COUNTIF(TRIM(CAST(IPAnnualDeductibleAmt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(IPAnnualDeductibleAmt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'OPAnnualReimbursementAmt', COUNTIF(OPAnnualReimbursementAmt IS NULL), COUNTIF(TRIM(CAST(OPAnnualReimbursementAmt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(OPAnnualReimbursementAmt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
UNION ALL SELECT 'OPAnnualDeductibleAmt', COUNTIF(OPAnnualDeductibleAmt IS NULL), COUNTIF(TRIM(CAST(OPAnnualDeductibleAmt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(OPAnnualDeductibleAmt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
ORDER BY placeholder_text DESC;

-- 2b. Null audit — raw_inpatient
SELECT 'BeneID' AS column_name, COUNTIF(BeneID IS NULL) AS true_null, COUNTIF(TRIM(CAST(BeneID AS STRING))='') AS empty_string, COUNTIF(UPPER(TRIM(CAST(BeneID AS STRING))) IN ('NA','N/A','NULL','NONE')) AS placeholder_text FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClaimID', COUNTIF(ClaimID IS NULL), COUNTIF(TRIM(CAST(ClaimID AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClaimID AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClaimStartDt', COUNTIF(ClaimStartDt IS NULL), COUNTIF(TRIM(CAST(ClaimStartDt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClaimStartDt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClaimEndDt', COUNTIF(ClaimEndDt IS NULL), COUNTIF(TRIM(CAST(ClaimEndDt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClaimEndDt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'Provider', COUNTIF(Provider IS NULL), COUNTIF(TRIM(CAST(Provider AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(Provider AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'InscClaimAmtReimbursed', COUNTIF(InscClaimAmtReimbursed IS NULL), COUNTIF(TRIM(CAST(InscClaimAmtReimbursed AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(InscClaimAmtReimbursed AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'AttendingPhysician', COUNTIF(AttendingPhysician IS NULL), COUNTIF(TRIM(CAST(AttendingPhysician AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(AttendingPhysician AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'OperatingPhysician', COUNTIF(OperatingPhysician IS NULL), COUNTIF(TRIM(CAST(OperatingPhysician AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(OperatingPhysician AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'OtherPhysician', COUNTIF(OtherPhysician IS NULL), COUNTIF(TRIM(CAST(OtherPhysician AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(OtherPhysician AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'AdmissionDt', COUNTIF(AdmissionDt IS NULL), COUNTIF(TRIM(CAST(AdmissionDt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(AdmissionDt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmAdmitDiagnosisCode', COUNTIF(ClmAdmitDiagnosisCode IS NULL), COUNTIF(TRIM(CAST(ClmAdmitDiagnosisCode AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmAdmitDiagnosisCode AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'DeductibleAmtPaid', COUNTIF(DeductibleAmtPaid IS NULL), COUNTIF(TRIM(CAST(DeductibleAmtPaid AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(DeductibleAmtPaid AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'DischargeDt', COUNTIF(DischargeDt IS NULL), COUNTIF(TRIM(CAST(DischargeDt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(DischargeDt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'DiagnosisGroupCode', COUNTIF(DiagnosisGroupCode IS NULL), COUNTIF(TRIM(CAST(DiagnosisGroupCode AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(DiagnosisGroupCode AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_1', COUNTIF(ClmDiagnosisCode_1 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_1 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_1 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_2', COUNTIF(ClmDiagnosisCode_2 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_2 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_2 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_3', COUNTIF(ClmDiagnosisCode_3 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_3 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_3 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_4', COUNTIF(ClmDiagnosisCode_4 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_4 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_4 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_5', COUNTIF(ClmDiagnosisCode_5 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_5 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_5 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_6', COUNTIF(ClmDiagnosisCode_6 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_6 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_6 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_7', COUNTIF(ClmDiagnosisCode_7 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_7 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_7 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_8', COUNTIF(ClmDiagnosisCode_8 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_8 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_8 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_9', COUNTIF(ClmDiagnosisCode_9 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_9 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_9 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmDiagnosisCode_10', COUNTIF(ClmDiagnosisCode_10 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_10 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_10 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmProcedureCode_1', COUNTIF(ClmProcedureCode_1 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_1 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_1 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmProcedureCode_2', COUNTIF(ClmProcedureCode_2 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_2 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_2 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmProcedureCode_3', COUNTIF(ClmProcedureCode_3 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_3 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_3 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmProcedureCode_4', COUNTIF(ClmProcedureCode_4 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_4 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_4 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmProcedureCode_5', COUNTIF(ClmProcedureCode_5 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_5 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_5 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL SELECT 'ClmProcedureCode_6', COUNTIF(ClmProcedureCode_6 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_6 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_6 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
ORDER BY placeholder_text DESC;

-- 2b. Null audit — raw_outpatient
SELECT 'BeneID' AS column_name, COUNTIF(BeneID IS NULL) AS true_null, COUNTIF(TRIM(CAST(BeneID AS STRING))='') AS empty_string, COUNTIF(UPPER(TRIM(CAST(BeneID AS STRING))) IN ('NA','N/A','NULL','NONE')) AS placeholder_text FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClaimID', COUNTIF(ClaimID IS NULL), COUNTIF(TRIM(CAST(ClaimID AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClaimID AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClaimStartDt', COUNTIF(ClaimStartDt IS NULL), COUNTIF(TRIM(CAST(ClaimStartDt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClaimStartDt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClaimEndDt', COUNTIF(ClaimEndDt IS NULL), COUNTIF(TRIM(CAST(ClaimEndDt AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClaimEndDt AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'Provider', COUNTIF(Provider IS NULL), COUNTIF(TRIM(CAST(Provider AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(Provider AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'InscClaimAmtReimbursed', COUNTIF(InscClaimAmtReimbursed IS NULL), COUNTIF(TRIM(CAST(InscClaimAmtReimbursed AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(InscClaimAmtReimbursed AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'AttendingPhysician', COUNTIF(AttendingPhysician IS NULL), COUNTIF(TRIM(CAST(AttendingPhysician AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(AttendingPhysician AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'OperatingPhysician', COUNTIF(OperatingPhysician IS NULL), COUNTIF(TRIM(CAST(OperatingPhysician AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(OperatingPhysician AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'OtherPhysician', COUNTIF(OtherPhysician IS NULL), COUNTIF(TRIM(CAST(OtherPhysician AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(OtherPhysician AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_1', COUNTIF(ClmDiagnosisCode_1 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_1 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_1 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_2', COUNTIF(ClmDiagnosisCode_2 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_2 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_2 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_3', COUNTIF(ClmDiagnosisCode_3 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_3 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_3 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_4', COUNTIF(ClmDiagnosisCode_4 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_4 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_4 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_5', COUNTIF(ClmDiagnosisCode_5 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_5 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_5 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_6', COUNTIF(ClmDiagnosisCode_6 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_6 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_6 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_7', COUNTIF(ClmDiagnosisCode_7 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_7 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_7 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_8', COUNTIF(ClmDiagnosisCode_8 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_8 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_8 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_9', COUNTIF(ClmDiagnosisCode_9 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_9 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_9 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmDiagnosisCode_10', COUNTIF(ClmDiagnosisCode_10 IS NULL), COUNTIF(TRIM(CAST(ClmDiagnosisCode_10 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmDiagnosisCode_10 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmProcedureCode_1', COUNTIF(ClmProcedureCode_1 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_1 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_1 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmProcedureCode_2', COUNTIF(ClmProcedureCode_2 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_2 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_2 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmProcedureCode_3', COUNTIF(ClmProcedureCode_3 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_3 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_3 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmProcedureCode_4', COUNTIF(ClmProcedureCode_4 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_4 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_4 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmProcedureCode_5', COUNTIF(ClmProcedureCode_5 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_5 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_5 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmProcedureCode_6', COUNTIF(ClmProcedureCode_6 IS NULL), COUNTIF(TRIM(CAST(ClmProcedureCode_6 AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmProcedureCode_6 AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'DeductibleAmtPaid', COUNTIF(DeductibleAmtPaid IS NULL), COUNTIF(TRIM(CAST(DeductibleAmtPaid AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(DeductibleAmtPaid AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
UNION ALL SELECT 'ClmAdmitDiagnosisCode', COUNTIF(ClmAdmitDiagnosisCode IS NULL), COUNTIF(TRIM(CAST(ClmAdmitDiagnosisCode AS STRING))=''), COUNTIF(UPPER(TRIM(CAST(ClmAdmitDiagnosisCode AS STRING))) IN ('NA','N/A','NULL','NONE')) FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
ORDER BY placeholder_text DESC;


-- ============================================================
-- 3. ID FORMAT CONSISTENCY CHECKS
-- ============================================================

-- BeneID
SELECT 'raw_beneficiary' AS source_table, REGEXP_EXTRACT(BeneID, r'^[A-Za-z]+') AS prefix, LENGTH(BeneID) AS id_length, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY prefix, id_length
UNION ALL
SELECT 'raw_inpatient', REGEXP_EXTRACT(BeneID, r'^[A-Za-z]+'), LENGTH(BeneID), COUNT(*)
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` GROUP BY prefix, id_length
UNION ALL
SELECT 'raw_outpatient', REGEXP_EXTRACT(BeneID, r'^[A-Za-z]+'), LENGTH(BeneID), COUNT(*)
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` GROUP BY prefix, id_length
ORDER BY source_table, cnt DESC;

-- ClaimID
SELECT 'raw_inpatient' AS source_table, REGEXP_EXTRACT(ClaimID, r'^[A-Za-z]+') AS prefix, LENGTH(ClaimID) AS id_length, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` GROUP BY prefix, id_length
UNION ALL
SELECT 'raw_outpatient' AS source_table, REGEXP_EXTRACT(ClaimID, r'^[A-Za-z]+') AS prefix, LENGTH(ClaimID) AS id_length, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` GROUP BY prefix, id_length
ORDER BY source_table, cnt DESC;

-- Provider
SELECT 'raw_inpatient' AS source_table, REGEXP_EXTRACT(Provider, r'^[A-Za-z]+') AS prefix, LENGTH(Provider) AS id_length, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` GROUP BY prefix, id_length
UNION ALL
SELECT 'raw_outpatient' AS source_table, REGEXP_EXTRACT(Provider, r'^[A-Za-z]+') AS prefix, LENGTH(Provider) AS id_length, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` GROUP BY prefix, id_length
ORDER BY source_table, cnt DESC;

-- Sample check for length variance (swap length as needed)
SELECT DISTINCT BeneID, LENGTH(BeneID) AS id_length
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
WHERE LENGTH(BeneID) = 9
LIMIT 5;


-- ============================================================
-- 4. DUPLICATE CHECKS
-- ============================================================

-- Full-row duplicates
SELECT 'raw_beneficiary' AS table_name, COUNT(*) AS total_rows, COUNT(DISTINCT TO_JSON_STRING(t)) AS distinct_rows
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` AS t
UNION ALL
SELECT 'raw_inpatient', COUNT(*), COUNT(DISTINCT TO_JSON_STRING(t))
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` AS t
UNION ALL
SELECT 'raw_outpatient', COUNT(*), COUNT(DISTINCT TO_JSON_STRING(t))
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` AS t;

-- Duplicate primary keys
SELECT BeneID, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`
GROUP BY BeneID
HAVING COUNT(*) > 1;

SELECT ClaimID, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
GROUP BY ClaimID
HAVING COUNT(*) > 1;

SELECT ClaimID, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
GROUP BY ClaimID
HAVING COUNT(*) > 1;


-- ============================================================
-- 5. REFERENTIAL INTEGRITY
-- ============================================================

-- Claims -> Beneficiary
SELECT 'raw_inpatient' AS source_table, COUNT(*) AS orphaned_claims
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` i
LEFT JOIN `hmo-provider-fraud-risk.raw.raw_beneficiary` b ON i.BeneID = b.BeneID
WHERE b.BeneID IS NULL
UNION ALL
SELECT 'raw_outpatient', COUNT(*)
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` o
LEFT JOIN `hmo-provider-fraud-risk.raw.raw_beneficiary` b ON o.BeneID = b.BeneID
WHERE b.BeneID IS NULL;

-- Claims -> Provider labels
SELECT 'raw_inpatient' AS source_table, COUNT(*) AS orphaned_claims
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` i
LEFT JOIN `hmo-provider-fraud-risk.raw.raw_provider_labels` p ON i.Provider = p.Provider
WHERE p.Provider IS NULL
UNION ALL
SELECT 'raw_outpatient', COUNT(*)
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` o
LEFT JOIN `hmo-provider-fraud-risk.raw.raw_provider_labels` p ON o.Provider = p.Provider
WHERE p.Provider IS NULL;


-- ============================================================
-- 6. COLUMN-SPECIFIC INVESTIGATIONS
-- ClmAdmitDiagnosisCode (raw_outpatient) — meaningful missingness or documentation habit?
-- ============================================================

SELECT ClmAdmitDiagnosisCode, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
WHERE ClmAdmitDiagnosisCode IS NOT NULL AND TRIM(ClmAdmitDiagnosisCode) != ''
GROUP BY ClmAdmitDiagnosisCode
ORDER BY cnt DESC
LIMIT 15;

SELECT
  CASE WHEN TRIM(ClmAdmitDiagnosisCode) = '' OR ClmAdmitDiagnosisCode IS NULL
       THEN 'Blank' ELSE 'Has value' END AS admit_code_status,
  COUNT(*) AS claim_count,
  ROUND(AVG(InscClaimAmtReimbursed), 2) AS avg_reimbursed
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
GROUP BY admit_code_status;


-- ============================================================
-- 7. LOGICAL DATE CONSISTENCY
-- ============================================================

-- 7a. Claim end before start
SELECT 'raw_inpatient' AS source_table, COUNT(*) AS end_before_start
FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
WHERE ClaimEndDt < ClaimStartDt
UNION ALL
SELECT 'raw_outpatient', COUNT(*)
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
WHERE ClaimEndDt < ClaimStartDt;

-- 7b. Discharge before admission (inpatient only)
SELECT COUNT(*) AS discharge_before_admission
FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
WHERE DischargeDt < AdmissionDt;

-- 7c. Claim starts before beneficiary's DOB
SELECT 'raw_inpatient' AS source_table, COUNT(*) AS claims_before_birth
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` i
JOIN `hmo-provider-fraud-risk.raw.raw_beneficiary` b ON i.BeneID = b.BeneID
WHERE i.ClaimStartDt < b.DOB
UNION ALL
SELECT 'raw_outpatient', COUNT(*)
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` o
JOIN `hmo-provider-fraud-risk.raw.raw_beneficiary` b ON o.BeneID = b.BeneID
WHERE o.ClaimStartDt < b.DOB;

-- 7d. Claims filed after date of death (caveat: only ~1% of beneficiaries have a real DOD)
SELECT 'raw_inpatient' AS source_table, COUNT(*) AS claims_after_death
FROM `hmo-provider-fraud-risk.raw.raw_inpatient` i
JOIN `hmo-provider-fraud-risk.raw.raw_beneficiary` b ON i.BeneID = b.BeneID
WHERE UPPER(TRIM(b.DOD)) NOT IN ('NA','N/A','NULL','NONE','')
  AND i.ClaimStartDt > SAFE_CAST(b.DOD AS DATE)
UNION ALL
SELECT 'raw_outpatient', COUNT(*)
FROM `hmo-provider-fraud-risk.raw.raw_outpatient` o
JOIN `hmo-provider-fraud-risk.raw.raw_beneficiary` b ON o.BeneID = b.BeneID
WHERE UPPER(TRIM(b.DOD)) NOT IN ('NA','N/A','NULL','NONE','')
  AND o.ClaimStartDt > SAFE_CAST(b.DOD AS DATE);


-- ============================================================
-- 8. CATEGORICAL VALUE VALIDATION
-- ============================================================

-- 8a. Gender, Race, RenalDiseaseIndicator
SELECT 'Gender' AS column_name, CAST(Gender AS STRING) AS value, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL
SELECT 'Race' AS column_name, CAST(Race AS STRING) AS value, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL
SELECT 'RenalDiseaseIndicator' AS column_name, RenalDiseaseIndicator AS value, COUNT(*) AS cnt
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
ORDER BY column_name, value;

-- 8b. All 11 ChronicCond_* columns
SELECT 'ChronicCond_Alzheimer' AS column_name, CAST(ChronicCond_Alzheimer AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_Heartfailure' AS column_name, CAST(ChronicCond_Heartfailure AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_KidneyDisease' AS column_name, CAST(ChronicCond_KidneyDisease AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_Cancer' AS column_name, CAST(ChronicCond_Cancer AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_ObstrPulmonary' AS column_name, CAST(ChronicCond_ObstrPulmonary AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_Depression' AS column_name, CAST(ChronicCond_Depression AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_Diabetes' AS column_name, CAST(ChronicCond_Diabetes AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_IschemicHeart' AS column_name, CAST(ChronicCond_IschemicHeart AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_Osteoporasis' AS column_name, CAST(ChronicCond_Osteoporasis AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_rheumatoidarthritis' AS column_name, CAST(ChronicCond_rheumatoidarthritis AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
UNION ALL SELECT 'ChronicCond_stroke' AS column_name, CAST(ChronicCond_stroke AS STRING) AS value, COUNT(*) AS cnt FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` GROUP BY value
ORDER BY column_name, value;


-- ============================================================
-- 9. RANGE / OUTLIER SANITY CHECKS
-- ============================================================

-- 9a. Claim-level amounts
SELECT 'raw_inpatient' AS source_table,
  COUNTIF(InscClaimAmtReimbursed < 0) AS negative_reimbursed,
  COUNTIF(InscClaimAmtReimbursed = 0) AS zero_reimbursed,
  MIN(InscClaimAmtReimbursed) AS min_reimbursed,
  MAX(InscClaimAmtReimbursed) AS max_reimbursed
FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL
SELECT 'raw_outpatient' AS source_table,
  COUNTIF(InscClaimAmtReimbursed < 0) AS negative_reimbursed,
  COUNTIF(InscClaimAmtReimbursed = 0) AS zero_reimbursed,
  MIN(InscClaimAmtReimbursed) AS min_reimbursed,
  MAX(InscClaimAmtReimbursed) AS max_reimbursed
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`;

SELECT 'raw_inpatient' AS source_table,
  COUNTIF(SAFE_CAST(DeductibleAmtPaid AS NUMERIC) < 0) AS negative_deductible,
  MIN(SAFE_CAST(DeductibleAmtPaid AS NUMERIC)) AS min_deductible,
  MAX(SAFE_CAST(DeductibleAmtPaid AS NUMERIC)) AS max_deductible
FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
UNION ALL
SELECT 'raw_outpatient' AS source_table,
  COUNTIF(SAFE_CAST(DeductibleAmtPaid AS NUMERIC) < 0) AS negative_deductible,
  MIN(SAFE_CAST(DeductibleAmtPaid AS NUMERIC)) AS min_deductible,
  MAX(SAFE_CAST(DeductibleAmtPaid AS NUMERIC)) AS max_deductible
FROM `hmo-provider-fraud-risk.raw.raw_outpatient`;

-- 9b. Beneficiary annual amounts
SELECT
  COUNTIF(IPAnnualReimbursementAmt < 0) AS negative_IPReimbursement,
  COUNTIF(IPAnnualDeductibleAmt < 0) AS negative_IPDeductible,
  COUNTIF(OPAnnualReimbursementAmt < 0) AS negative_OPReimbursement,
  COUNTIF(OPAnnualDeductibleAmt < 0) AS negative_OPDeductible,
  MIN(IPAnnualReimbursementAmt) AS min_IPReimbursement,
  MAX(IPAnnualReimbursementAmt) AS max_IPReimbursement,
  MIN(OPAnnualReimbursementAmt) AS min_OPReimbursement,
  MAX(OPAnnualReimbursementAmt) AS max_OPReimbursement
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`;

-- 9b-i. Baseline — does the annual field normally match real claim totals?
WITH claim_sums AS (
  SELECT BeneID, SUM(InscClaimAmtReimbursed) AS actual_ip_sum
  FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
  GROUP BY BeneID
)
SELECT
  COUNT(*) AS beneficiaries_with_claims,
  COUNTIF(b.IPAnnualReimbursementAmt = c.actual_ip_sum) AS exact_match_count,
  ROUND(AVG(ABS(b.IPAnnualReimbursementAmt - c.actual_ip_sum)), 2) AS avg_abs_difference,
  MIN(b.IPAnnualReimbursementAmt - c.actual_ip_sum) AS min_difference,
  MAX(b.IPAnnualReimbursementAmt - c.actual_ip_sum) AS max_difference
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` b
JOIN claim_sums c ON b.BeneID = c.BeneID;

-- 9b-ii. Zoom in on the negative cases
WITH claim_sums AS (
  SELECT BeneID, SUM(InscClaimAmtReimbursed) AS actual_ip_sum, COUNT(*) AS claim_count
  FROM `hmo-provider-fraud-risk.raw.raw_inpatient`
  GROUP BY BeneID
)
SELECT
  b.BeneID,
  b.IPAnnualReimbursementAmt,
  c.actual_ip_sum,
  c.claim_count
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` b
LEFT JOIN claim_sums c ON b.BeneID = c.BeneID
WHERE b.IPAnnualReimbursementAmt < 0
ORDER BY b.IPAnnualReimbursementAmt ASC;

WITH claim_sums AS (
  SELECT BeneID, SUM(InscClaimAmtReimbursed) AS actual_op_sum, COUNT(*) AS claim_count
  FROM `hmo-provider-fraud-risk.raw.raw_outpatient`
  GROUP BY BeneID
)
SELECT
  b.BeneID,
  b.OPAnnualReimbursementAmt,
  c.actual_op_sum,
  c.claim_count
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary` b
LEFT JOIN claim_sums c ON b.BeneID = c.BeneID
WHERE b.OPAnnualReimbursementAmt < 0
ORDER BY b.OPAnnualReimbursementAmt ASC;

-- 9c. Coverage months (should be 0-12)
SELECT
  COUNTIF(NoOfMonths_PartACov < 0 OR NoOfMonths_PartACov > 12) AS out_of_range_PartA,
  COUNTIF(NoOfMonths_PartBCov < 0 OR NoOfMonths_PartBCov > 12) AS out_of_range_PartB,
  MIN(NoOfMonths_PartACov) AS min_PartA,
  MAX(NoOfMonths_PartACov) AS max_PartA,
  MIN(NoOfMonths_PartBCov) AS min_PartB,
  MAX(NoOfMonths_PartBCov) AS max_PartB
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`;

-- 9d. Age sanity check (reference date: 2009-12-31, the end of this dataset's claims period)
SELECT
  COUNTIF(DATE_DIFF(DATE '2009-12-31', DOB, YEAR) < 0) AS negative_age,
  COUNTIF(DATE_DIFF(DATE '2009-12-31', DOB, YEAR) > 110) AS age_over_110,
  MIN(DATE_DIFF(DATE '2009-12-31', DOB, YEAR)) AS min_age,
  MAX(DATE_DIFF(DATE '2009-12-31', DOB, YEAR)) AS max_age
FROM `hmo-provider-fraud-risk.raw.raw_beneficiary`;


-- ============================================================
-- 10. TARGET LABEL BALANCE
-- ============================================================

SELECT
  PotentialFraud,
  COUNT(*) AS provider_count,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_of_total
FROM `hmo-provider-fraud-risk.raw.raw_provider_labels`
GROUP BY PotentialFraud
ORDER BY PotentialFraud;
