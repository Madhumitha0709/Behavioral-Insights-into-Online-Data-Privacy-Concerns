/* 4. For people expressing extreme privacy concern (top 10% of "Privacy.Importance"), what is their profile—age, device habits, and actual behavior (masking identity)?
•	Advanced SQL concept: Window functions (NTILE, ROW_NUMBER), subquery filters, profile clustering
•	Use NTILE(10) to identify top decile of privacy scores.
•	Analyze their demographic and behavior features in detail.
*/

-- data cleaning (not req. to execute cause already this table exist)
CREATE TABLE AnonymityPoll_Clean_PrivacyImportance AS
SELECT *
FROM AnonymityPoll
WHERE Privacy_Importance IS NOT NULL;

-- Identify Top Decile Using NTILE
WITH Ranked_Privacy AS (
  SELECT *,
    NTILE(10) OVER (ORDER BY Privacy_Importance DESC) AS Privacy_Decile
  FROM AnonymityPoll_Clean_PrivacyImportance
)
SELECT *
FROM Ranked_Privacy
WHERE Privacy_Decile = 1;

-- Profile the Top Decile: Age Distribution
SELECT 
  CASE 
    WHEN Age IS NULL THEN 'Missing'
    WHEN Age BETWEEN 18 AND 25 THEN '18-25'
    WHEN Age BETWEEN 26 AND 35 THEN '26-35'
    WHEN Age BETWEEN 36 AND 50 THEN '36-50'
    ELSE '50+'
  END AS Age_Cohort,
  COUNT(*) AS Count
FROM (
  SELECT *, NTILE(10) OVER (ORDER BY Privacy_Importance DESC) AS Privacy_Decile
  FROM AnonymityPoll_Clean_PrivacyImportance
) sub
WHERE Privacy_Decile = 1
GROUP BY Age_Cohort
ORDER BY 
  CASE Age_Cohort 
    WHEN 'Missing' THEN 99
    WHEN '18-25' THEN 1
    WHEN '26-35' THEN 2
    WHEN '36-50' THEN 3
    WHEN '50+' THEN 4
  END;

-- Device Habits: Internet_Use / Smartphone (with missing)
SELECT 
  COALESCE(CAST(Internet_Use AS CHAR), 'Missing') AS Internet_Use_Status,
  COUNT(*) AS Count
FROM (
  SELECT *, NTILE(10) OVER (ORDER BY Privacy_Importance DESC) AS Privacy_Decile
  FROM AnonymityPoll_Clean_PrivacyImportance
) sub
WHERE Privacy_Decile = 1
GROUP BY Internet_Use_Status;

SELECT 
  COALESCE(CAST(Smartphone AS CHAR), 'Missing') AS Smartphone_Status,
  COUNT(*) AS Count
FROM (
  SELECT *, NTILE(10) OVER (ORDER BY Privacy_Importance DESC) AS Privacy_Decile
  FROM AnonymityPoll_Clean_PrivacyImportance
) sub
WHERE Privacy_Decile = 1
GROUP BY Smartphone_Status;

-- Actual Behavior: Tried_Masking_Identity (with missing)
WITH RankedData AS (
    SELECT *,
           NTILE(10) OVER (ORDER BY Privacy_Importance DESC) AS privacy_group
    FROM AnonymityPoll
    WHERE Privacy_Importance IS NOT NULL
)
SELECT 
    'Top 10%' AS group_label,
    CASE WHEN Tried_Masking_Identity = 1 THEN 'Yes' ELSE 'No' END AS masks_identity,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_within_group
FROM RankedData
WHERE privacy_group = 1
GROUP BY masks_identity

UNION ALL

SELECT 
    'Other 90%' AS group_label,
    CASE WHEN Tried_Masking_Identity = 1 THEN 'Yes' ELSE 'No' END AS masks_identity,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_within_group
FROM RankedData
WHERE privacy_group != 1
GROUP BY masks_identity;


