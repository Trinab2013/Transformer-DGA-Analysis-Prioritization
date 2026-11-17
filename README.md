# Transformer DGA Analysis & Prioritization

A single-page dashboard that reads transformer Dissolved Gas Analysis (DGA) lab results, diagnoses developing faults, scores equipment health and ranks every unit by maintenance priority.

## Use it

- **In Claude:** open the published artifact. Uploading PDFs, Word files or photos and the AI assessments only work there, because they use Claude.
- **Locally:** open `index.html` in a browser. Excel/CSV/JSON import, the full rule-based analysis and export all work offline. AI features are hidden.

Rebuild `index.html` after editing `src/dashboard.html`:

```bash
./build.sh
```

## Inputs

| Format | How it's read |
|---|---|
| `.xlsx` `.xls` `.ods` `.csv` `.tsv` `.json` | Parsed in the browser (SheetJS). Header row is found automatically, columns are mapped by name (H2/Hydrogen, CH4/Methane, …) and you can adjust the mapping. Long format (`gas`, `value` columns) is pivoted. |
| `.pdf` `.docx` `.txt`, pasted text | Text is pulled out and Claude extracts the samples into a table |
| `.png` `.jpg` `.webp` | Claude reads the photographed or scanned report |

Columns it recognizes: transformer ID, sample date, H2, CH4, C2H6, C2H4, C2H2, CO, CO2, O2, N2, plus optional location, MVA, kV, year built or age, and criticality (1–5). Use **Template** to get a blank CSV.

## Analysis

- **DGA status 1–3**: IEEE C57.104-2019 approach. Each gas is checked against 90th/95th percentile limits (sealed vs. open conservator picked from O2/N2), the change since the last sample, and the rate of increase over the last 2 years.
- **Fault type**: Duval Triangle 1, checked against IEC 60599 ratios and the key-gas method.
- **Paper insulation**: CO and the CO2/CO ratio. **TDCG**: IEEE C57.104-2008 conditions 1–4.
- **Scores**: condition (0–100), trend (0–100), risk (criticality, age, MVA).
  Priority score = 55% condition + 25% trend + 20% risk → P1 Immediate (≥60), P2 Urgent (≥42), P3 Planned (≥26), P4 Routine. A status-3 unit with a fast-rising arcing or hot-metal fault is always P1.
- **Health index** = 100 − (0.65 × condition + 0.25 × trend).
- **Action tier** for every unit:
  - **Tier 1 · Replacement**: health index ≤ 25 and age 35+ or severe paper degradation; or an active, accelerating arcing (D2) / hot-metal (T3) fault at status 3 in a unit 25+ years old; or severe paper degradation with CO above the 95th percentile at age 40+.
  - **Tier 2 · Mitigation**: a repairable fault or deterioration (everything not in Tier 1 or 3).
  - **Tier 3 · No action needed**: P4 Routine, gases typical and stable.
- **Repair recommendation**: a headline repair, step-by-step repair work chosen from the fault type, acetylene behaviour, paper condition and O2/N2, and the expected outage. Tier 1 units get a replacement plan with interim restrictions.
- **Monitoring and next steps** with a resample interval for each unit's priority.

Limits and weights are in the `ENGINE` block of `src/dashboard.html` (`LIMITS`, `FAULTS`, `analyzeUnit`). Change them to match your utility's standard.

## AI features (in Claude)

- AI engineering assessment for each unit: diagnosis, root causes, risk, action tier, repair recommendation, action plan, confidence.
- Fleet briefing grouped by tier, and free-form questions about the ranked fleet.
- Pulls DGA samples out of unstructured reports.

This is a screening tool. Confirm results with a resample and your utility's standards before acting.
