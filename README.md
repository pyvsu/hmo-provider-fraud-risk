# HMO Provider Fraud Risk
## Executive Summary
This project analyzes Medicare provider claims (Kaggle's Healthcare Provider Fraud Detection Analysis dataset) to identify billing patterns associated with fraud risk. The central finding: flagged providers don't differ by who their patients are — they differ by how they bill, submitting far more claims and reimbursement per provider than non-flagged providers, concentrated heavily in inpatient care and specific physician-billing patterns. Patient demographics and health status showed no meaningful difference between groups.

<img width="2000" height="1141" alt="animated_20260904_220037" src="https://github.com/user-attachments/assets/d5df030b-b2cd-4518-b736-3ec7cf76cfe2" />

An overview of the PowerBI dashboard is shown below, with further examples provided in the report. You can explore the full interactive dashboard [here](https://app.powerbi.com/view?r=eyJrIjoiMjUyYjg3NDItNDEwNy00NWUwLWE4MDctMGJhMzc3NTY5MTQ4IiwidCI6IjRkYTk4NTcxLWRjZWEtNDgzOS04ZmIxLTBiZGQ1ZGM5NjlmOSIsImMiOjEwfQ%3D%3D)

## Project Background

Healthcare fraud costs Medicare billions of dollars every year. Providers exploit vague diagnosis codes to bill for pricier procedures, submit duplicate claims, or charge for services never rendered — and insurers absorb the loss, passing it on through higher premiums for everyone.

Catching this after the fact is expensive; catching the billing *pattern* early is what actually protects the bottom line. This project analyzes a Medicare provider claims dataset — inpatient claims, outpatient claims, and beneficiary details — to uncover what actually differentiates providers flagged for potential fraud from those who aren't, with the goal of giving a health insurer's fraud team a clearer, evidence-based starting point for who to investigate first.

**Primary Audience:** The Special Investigations Unit (SIU) and fraud & compliance teams — the people who decide which providers get audited and need to know who to prioritize, not just raw claim totals. **Leadership/finance** is a secondary audience, reviewing portfolio-level exposure from the Scale of the Gap page.

**Business Questions This Dashboard Answers:**
- How large is the billing gap between flagged and non-flagged providers, and is it driven by a few outliers or a consistent pattern?
- Where does that gap concentrate — inpatient vs. outpatient care, specific physicians, or specific regions?
- Does patient profile (age, chronic conditions, demographics) explain fraud risk, or is it purely a billing-behavior signal?
- Does claim timing — duration, or how quickly a provider submits consecutive claims — differ between flagged and non-flagged providers?
- What share of the provider base, and how much total reimbursement, falls into the flagged group?
- Which individual providers show the most extreme values worth investigating first?

Insights and recommendations are provided on the following key areas:

- **The Scale of the Gap** — portfolio-level snapshot of how far apart flagged and non-flagged providers sit on reimbursement, deductible, and claims volume
- **Where It Concentrates** — the specific dimensions (inpatient care, physician-level routing, geography) where the gap sharpens
- **Billing Behavior, Not Patient Profile** — supporting signals (claim duration, diagnosis codes, claim timing) and what patient-level factors turned out *not* to matter
- **Provider Drill-Down** — the drill-through page for looking up any individual provider's numbers

The SQL scripts used to clean and prepare the data for this analysis can be found [here](sql).

## Insights Deep Dive

### The Scale of the Gap
- **Flagged providers represent a small slice of the provider base but a large share of exposure.** Of 5,410 providers, 506 (9.35%) are flagged as potential fraud, and this group alone accounts for $295.68M in total reimbursement.
- **Flagged providers show a dramatically higher median reimbursement per provider.** $373.45K vs. $15.06K for non-flagged providers — a ~24.81x gap, holding at the median so it isn't driven by a handful of outliers.
- **The deductible gap is even more extreme.** $26,359 vs. $200 per provider (~132x), the strongest single signal in this dataset.
- **Flagged providers also submit far more claims.** ~421 claims per provider vs. ~70 for non-flagged (~6x) — this is a volume pattern, not just a few high-dollar claims.

### Where It Concentrates
- **The gap is sharper in inpatient care than outpatient.** Inpatient reimbursement shows a ~24% gap vs. ~7% for outpatient, pointing to inpatient billing as the main carrier of the financial signal.
- **Billing routes through a more concentrated group of physicians.** Across attending, operating, and other physician roles, flagged providers route 2.8x–4.1x more claims through each individual physician than non-flagged providers.
- **California is overrepresented beyond its population share.** 14.3% of fraud-flagged claims vs. 8.7% of the beneficiary population (~1.64x) — confirmed not a population-size artifact and the highest concentration of any state.
- **Procedure code alone doesn't differentiate fraud.** After a data-model correction, no single procedure code showed more than an ~11% gap — this is a null finding, not a hidden pattern.

### Billing Behavior, Not Patient Profile
- **Flagged claims run slightly longer and list more diagnosis codes.** ~18% longer duration and ~11% more diagnosis codes than non-flagged claims — real but modest signals on their own.
- **Flagged providers submit claims in far tighter succession.** A median of 0 days between a provider's consecutive claims vs. 1 day for non-flagged, confirmed under both median and mean (0.86 vs. 4.33 days) — not outlier-driven.
- **Deceased-at-claim is a weak, low-confidence signal.** ~1.46x more likely in fraud-flagged claims, but the event is rare enough that it shouldn't be read as reliable on its own.
- **Patient identity does not predict fraud.** Age, gender, race, chronic conditions, diagnosis mix, Medicare coverage duration, and length of stay all showed no meaningful difference — fraud in this dataset tracks billing behavior, not who the patient is.

### Provider Drill-Down
- **Individual provider lookup surfaces the same pattern at the case level.** The drill-through table lets an investigator pull up any single provider's claim volume, total reimbursement, and average cost per claim to sanity-check the portfolio-level findings against a specific case.

## Recommendations

### The Scale of the Gap
- **Prioritize audit resources by exposure, not headcount.** Since 9.35% of providers account for $295.68M in reimbursement, direct SIU review capacity toward the highest-dollar flagged providers first, not an even sweep across the provider base.
- **Use per-provider median reimbursement and deductible as standing audit triggers.** The ~25x and ~132x gaps are stable at the median, so providers crossing these thresholds are worth flagging for manual review before losses accumulate further.

### Where It Concentrates
- **Weight inpatient claims more heavily in audit scoring than outpatient.** The gap concentrates there (~24% vs. ~7%), so inpatient-heavy providers deserve closer scrutiny per audit dollar spent.
- **Monitor physician-level claim concentration, not just provider-level totals.** A provider routing an unusually high volume of claims through a small number of physicians is a pattern worth a standalone alert, independent of total billing size.
- **Treat California claims with added review weight**, given the confirmed overrepresentation — but pair this with ongoing monitoring rather than a fixed regional bias, since concentration patterns can shift.
- **Deprioritize procedure code as a standalone fraud indicator.** It didn't hold up as a differentiator here, so audit criteria shouldn't lean on it without other supporting signals.

### Billing Behavior, Not Patient Profile
- **Add "days between claims" as a monitoring metric.** A provider submitting claims same-day, repeatedly, is a stronger and more actionable early-warning signal than claim duration or diagnosis code count alone.
- **Treat deceased-at-claim as a secondary corroborating flag, not a primary trigger** — the signal is real but too rare to carry an audit decision on its own.
- **Remove patient demographics and health status from fraud-risk scoring entirely.** None of them differentiated flagged providers here, so including them would add noise (and potential bias) without predictive value.

### Provider Drill-Down
- **Equip investigators with the drill-through view as a first-pass triage tool**, so any provider flagged by the portfolio-level patterns above can be individually verified before an audit is opened — reducing wasted investigation time on false positives.

## Methodology

### Data Structure & Initial Checks
This dataset originated as three linked raw tables — `Train_Beneficiarydata` (138,556 rows), `Train_Inpatientdata` (40,474 rows), and `Train_Outpatientdata` (517,737 rows) — plus a provider-level fraud label covering 5,410 providers. These were loaded into BigQuery, cleaned into a `clean` layer preserving the exact same row counts (verified zero rows lost across all three tables), then modeled into a star schema consisting of `fact_claims`, `dim_provider`, `dim_beneficiary`, and `dim_diagnosis`, connected via two bridge tables (`bridge_claim_diagnosis`, `bridge_claim_procedure`) to handle the many-to-many relationship between claims and diagnosis/procedure codes.

<insert schema here>
Prior to modeling, a full data quality audit was conducted — referential integrity, logical date consistency, categorical value validation, range/outlier checks, and target label balance — all run directly against the live BigQuery tables rather than assumed from documentation. The SQL script used to inspect the data can be found <here>

### Assumptions and Caveats

#### Data Cleaning Decisions
- **Placeholder text masquerading as nulls:** most "missing" data wasn't a true NULL — it was the literal string `"NULL"` (plus `NA`/`N/A`/`NONE`) stored as text across 19 columns each in the inpatient and outpatient tables. Collapsed to real NULL via a reusable `clean_placeholder` function rather than fixed column-by-column.
- **`DeductibleAmtPaid` type mismatch:** stored as text in the inpatient table but a clean INT64 in outpatient. Cast to INT64 in the clean view to match.
- **`RenalDiseaseIndicator`** converted to a boolean (`HasRenalDisease`) for consistency with the other 11 `ChronicCond_*` columns.
- **Fully empty columns dropped:** `ClmProcedureCode_6` (inpatient) and `ClmProcedureCode_5`/`6` (outpatient) — 100% empty across every row, zero information.
- **27 beneficiaries (~0.02%) with negative annual reimbursement amounts:** investigated by joining against actual claim sums — all 27 have zero real claims on record, so the negative figure can't reflect an actual billing recoupment. Left as-is rather than silently zeroed, clipped, or flipped — the true correct value is unknowable, and fabricating one would violate this project's benchmark-discipline standard.
- **13 column renames** applied for clarity (e.g. `DOD` → `DateOfDeath`, `IPAnnualReimbursementAmt` → `InpatientAnnualReimbursementAmt`), including one misspelling fix (`ChronicCond_Osteoporasis` → `ChronicCond_Osteoporosis`).
- **`County`** left as a raw SSA numeric code — no reliable compact county-name lookup table available, and guessing wasn't an option.

#### Modeling Assumptions
- Single-direction cross-filtering (dimension → fact) for `dim_provider` and `dim_beneficiary` — standard star schema practice, avoids ambiguous filter propagation.
- `bridge_claim_diagnosis` and `bridge_claim_procedure` use Both cross-filter direction — required for the many-to-many relationship between claims and diagnosis/procedure codes. This doesn't violate the single-direction rule above, since that rule applies specifically to dimension-to-fact relationships.
- Surrogate keys used throughout, given a join-key naming inconsistency in the source data (`staging_claims.Provider` vs. `clean_provider_fraud_label.provider_id`).

#### Analytical Assumptions
- No documented fraud-rate target existed going in, so the portfolio's own fraud rate (9.35%) was used as the benchmark for every flagged-vs-non-flagged comparison, rather than an external or arbitrary threshold.
- Median was checked alongside every mean-based finding before being reported as confirmed — this is how the reimbursement and deductible gaps were validated as real, not outlier-driven.
- The "claims filed after death" check found 0 cases, but only ~1% of beneficiaries have a real date-of-death value in this dataset. Reported as a finding from a limited, verifiable sample — not as a blanket conclusion that no such fraud pattern exists.

#### Sample Size Caveats
- **Deceased-at-claim (~1.46x gap):** flagged as a low-confidence signal — death is a rare event within a single-year Medicare sample, making this ratio more volatile than the other findings.
- **27 beneficiaries with negative annual reimbursement (~0.02% of the beneficiary table):** immaterial to any aggregate figure, but documented rather than silently corrected.

#### Scope Limitations
- **This dataset is synthetic**, derived from CMS's DE-SynPUF (a statistical model, not real patient records) — findings describe patterns in this synthetic dataset, not a claim about real-world Medicare fraud behavior. This is also the direct explanation for the negative-reimbursement anomaly above.
- `PotentialFraud` is a dataset label, not a verified legal or investigative outcome — every finding in this report describes an association observed within this dataset, not proof of fraud.
- Date-of-birth and date-of-death are generalized to the 1st of the month across the entire dataset (a CMS privacy standard for this public data) — any age or time-since-death calculation is accurate only to month/year, not exact day.
- Geography is analyzed at the State level only; County was excluded as too granular given no reliable lookup table.
- This is a single snapshot of claims — it shows recorded billing patterns, not how a provider's behavior evolves over time.
- Procedure code showed no meaningful differentiation *in this dataset* after a data-model correction — reported as a genuine null finding, not a general claim that procedure codes never signal fraud.

#### Tools & Pipeline
- **Kaggle API (CLI)** — dataset download
- **BigQuery** — data warehouse, staging, and cleaning (`raw` → `clean` datasets)
- **Python** — data ingestion into BigQuery, run directly via terminal commands
- **SQL** — data cleaning and view creation
- **Power Query** — star schema modeling
- **Power BI (DAX)** — dashboard and measures, organized in a base → analytical → contextual → advanced hierarchy
- **GitHub** — version control throughout

Pipeline: Kaggle API (CLI download) → raw CSV → Python ingestion (terminal) → BigQuery `raw` dataset → SQL cleaning (`sql/`) → BigQuery `clean` dataset → Power Query (star schema modeling) → Power BI (dashboard/DAX)
