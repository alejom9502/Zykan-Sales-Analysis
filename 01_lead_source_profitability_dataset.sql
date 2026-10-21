-- ============================================================
-- Lead Source Profitability — analysis dataset
-- Builds a job-level dataset from a CRM export (MySQL):
-- jobs joined to leads so every job carries its lead source.
--
-- The hard part: the two tables share no clean key. Job names
-- in `jobs` carry a job-number prefix ("MO-1234: Smith - Roof")
-- that `leads` does not, so the join is done on cleaned names
-- (prefix stripped, trimmed, lowercased).
--
-- NOTE: salesperson names in this public version are anonymized
-- ("Rep A"). The logic is unchanged from the production query.
-- ============================================================

SELECT
    j.job_guid,
    LOWER(TRIM(REGEXP_REPLACE(j.job_name, '^MO-[0-9]+:\\s*', ''))) AS clean_job_name,
    CASE
        WHEN LOWER(TRIM(j.primary_salesperson)) IN ('rep a') THEN 'Rep A'
        ELSE TRIM(j.primary_salesperson)
    END AS primary_salesperson,
    j.current_milestone,
    j.contract_amount,
    j.orders_total,
    j.payments_received,
    j.total_expenses,
    j.balance_due,
    j.profit,
    j.profit_pct,
    COALESCE(l.lead_source, 'Direct Entry') AS lead_source
FROM jobs j
LEFT JOIN leads l
  ON LOWER(TRIM(l.job_name)) = LOWER(TRIM(REGEXP_REPLACE(j.job_name, '^MO-[0-9]+:\\s*', '')));
