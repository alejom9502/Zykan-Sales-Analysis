# CRM Sales & Production Analytics — Exterior Remodeling

**Business question:** For a residential exterior-remodeling company, which lead sources actually make money, where do jobs stall in production, and how do sales reps compare — answered from the company's own CRM data.

Built with **SQL (MySQL) + Tableau** on an AccuLynx CRM export. All figures are aggregated; client names, job names, and individual rep names are anonymized.

## The three analyses

### 1. Lead Source Profitability

Every job joined back to the lead that produced it, comparing lead sources by volume, win rate, contract value, and gross profit margin — so marketing spend can follow profit, not just lead count.

*The data problem:* `jobs` and `leads` share no clean key. Job names in `jobs` carry a job-number prefix (`MO-1234: …`) that `leads` doesn't have. The dataset query (`01_lead_source_profitability_dataset.sql`) strips the prefix, normalizes case/whitespace and rep names, and joins on the cleaned name.

### 2. Production Bottlenecks

Using the workflow-milestone history (one row per job per status stay), average and maximum days-in-status per production stage (`02_production_bottlenecks.sql`) — the stages where jobs sit longest are where revenue waits.

### 3. Salesperson Performance

Rep-level comparison of converted jobs, win rate, and contract totals, with rep names anonymized (Rep A, Rep B, …) in this public version.

## Key findings

- **The bottleneck is insurance supplements, not production.** In the Approved milestone, the three longest waits are all supplement-process statuses — the longest averages **100.9 days**. Actual "In production" time averages 47.7 days. Jobs spend more time waiting on supplement paperwork than on the work itself.
- **Collections is the second leak:** jobs in "60 day past due" sit there **85.8 days** on average.
- **Lead-source margin spread is \~46 points.** Across 18 lead sources, gross profit margin runs from **73.6%** (BBB) down to **27.7%** (yard signs). Referrals (59.0%) and self-generated leads (53.8%) combine high margin with volume potential, while paid channels lag — Google 43.9%, TV commercials 29.9%.
- **Win rates vary 17× across reps.** The top rep converts **39.0%** of leads; the bottom of the top-10 converts **2.3%** — a coaching/targeting gap, not just a lead-quality gap (22 reps in the data).
- **Data-quality flag:** one status shows a *negative* average duration (−4.7 days), i.e., some milestone timestamps are recorded out of order in the CRM — worth fixing at the source before trusting fine-grained durations.

## Data

CRM export loaded into MySQL (`acculynx_db`):

- `jobs` — job GUID, job name, current milestone, contract amount, orders, payments, expenses, balance due, profit
- `leads` — job name, lead source
- `workflow_milestones` — job GUID, status name, status start/end dates, duration in days

## Tools

SQL (MySQL) · Tableau · Excel/Google Sheets (source exports)

## Screenshots

- `images/production-bottlenecks.png` — average days per workflow status
- `images/lead-source-profitability.png` — gross margin % by lead source
- Salesperson-performance and dashboard views exist in the original workbook; their public versions are pending an anonymized re-export (rep names → Rep A, Rep B, …).

## What I'd do next

- Add a time dimension: are bottlenecks seasonal (storm season surges)?
- Cost-per-lead by source, to turn margin-by-source into true ROI by source.
- An aging alert: jobs sitting in a status beyond its 90th-percentile duration get flagged weekly.

---

*Part of my data-analytics portfolio — I'm a Data Science senior (Lindenwood University, May 2027) working toward a Data Analyst role. More projects on my profile.*
