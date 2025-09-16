/*1. Which demographic groups (by age group and sex) score highest and lowest for the importance of privacy, and what are the statistical differences between them?
•	Compute average privacy importance by age bracket and sex.
•	Rank cohorts within each region or state.
*/

-- Create a cleaned subset for this analysis excluding rows missing Privacy_Importance
CREATE TABLE AnonymityPoll_Clean_PrivacyImportance AS
SELECT *
FROM AnonymityPoll
WHERE Privacy_Importance IS NOT NULL;

DELETE FROM AnonymityPoll_Clean_PrivacyImportance
WHERE Age IS NULL;

-- Define age groups using case
SELECT
    CASE 
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS age_cohort
FROM AnonymityPoll_Clean_PrivacyImportance;

-- Calculate Average Privacy_Importance by Age Cohort and Sex with Ranking
SELECT
  Age_Cohort,
  Sex,
  AVG(Privacy_Importance) AS Avg_Privacy_Importance,
  RANK() OVER (
    PARTITION BY Sex
    ORDER BY AVG(Privacy_Importance) DESC
  ) AS Rank_By_PrivacyImportance
FROM (
  SELECT *,
    CASE
		WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS Age_Cohort
  FROM AnonymityPoll_Clean_PrivacyImportance
) AS sub
GROUP BY Age_Cohort, Sex
ORDER BY Sex, Rank_By_PrivacyImportance;

-- Rank cohorts within each region
SELECT
  Region,
  Age_Cohort,
  Sex,
  AVG(Privacy_Importance) AS Avg_Privacy_Importance,
  RANK() OVER (
    PARTITION BY Region, Sex
    ORDER BY AVG(Privacy_Importance) DESC
  ) AS Rank_By_PrivacyImportance_Region
FROM (
  SELECT *,
    CASE
      WHEN Age BETWEEN 18 AND 29 THEN '18-29'
      WHEN Age BETWEEN 30 AND 44 THEN '30-44'
      WHEN Age BETWEEN 45 AND 60 THEN '45-60'
      ELSE '60+'
    END AS Age_Cohort
  FROM AnonymityPoll_Clean_PrivacyImportance
) AS sub
GROUP BY Region, Age_Cohort, Sex
ORDER BY Region, Sex, Rank_By_PrivacyImportance_Region;

