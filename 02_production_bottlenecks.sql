-- ============================================================
-- Production Bottlenecks — milestone duration analysis
-- For every workflow status, how long do jobs sit there on
-- average, and what is the worst case? The statuses with the
-- highest average duration are where production stalls.
-- Source table: workflow_milestones (one row per job per
-- status stay, with status_duration in days).
-- ============================================================

SELECT
    status_name,
    COUNT(milestone_id) AS total_occurrences,
    ROUND(AVG(status_duration), 1) AS avg_days_in_status,
    MAX(status_duration) AS max_days_in_status
FROM workflow_milestones
WHERE status_duration > 0
GROUP BY status_name
ORDER BY avg_days_in_status DESC
LIMIT 10;
