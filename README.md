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
