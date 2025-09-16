/* 3. Are people who actively try to mask their identity significantly more worried about privacy, and does this tendency differ by device type (Internet vs. smartphone users)?
•	Advanced SQL concept: CTEs or subqueries for group comparisons, CASE logic
•	WITH clause to separate groups (maskers vs. non-maskers), and compare their privacy worry scores.
•	Split by "Smartphone" and "Internet.Use" status using conditional logic.
*/

-- Data Cleaning
CREATE TABLE AnonymityPoll_Clean_MaskVsWorry AS
SELECT *
FROM AnonymityPoll
WHERE
    Tried_Masking_Identity IS NOT NULL
    AND Worry_About_Info IS NOT NULL
    AND Internet_Use IS NOT NULL
    AND Smartphone IS NOT NULL;

-- Compare Worry_About_Info Between Maskers and Non-Maskers
SELECT
  Tried_Masking_Identity,
  AVG(Worry_About_Info) AS Avg_Worry_About_Info,
  COUNT(*) AS Sample_Size
FROM AnonymityPoll_Clean_MaskVsWorry
GROUP BY Tried_Masking_Identity;

-- Group Comparison Split by Internet_Use
SELECT
  Tried_Masking_Identity,
  Internet_Use,
  AVG(Worry_About_Info) AS Avg_Worry_About_Info,
  COUNT(*) AS Sample_Size
FROM AnonymityPoll_Clean_MaskVsWorry
GROUP BY Tried_Masking_Identity, Internet_Use
ORDER BY Internet_Use, Tried_Masking_Identity;

-- Group Comparison Split by Smartphone
SELECT
  Tried_Masking_Identity,
  Smartphone,
  AVG(Worry_About_Info) AS Avg_Worry_About_Info,
  COUNT(*) AS Sample_Size
FROM AnonymityPoll_Clean_MaskVsWorry
GROUP BY Tried_Masking_Identity, Smartphone
ORDER BY Smartphone, Tried_Masking_Identity;

-- Compare Averages and Compute Difference
WITH Masker_Worry AS (
  SELECT
    Internet_Use,
    Smartphone,
    AVG(CASE WHEN Tried_Masking_Identity = 1 THEN Worry_About_Info END) AS Avg_Worry_Masker,
    AVG(CASE WHEN Tried_Masking_Identity = 0 THEN Worry_About_Info END) AS Avg_Worry_NonMasker
  FROM AnonymityPoll_Clean_MaskVsWorry
  GROUP BY Internet_Use, Smartphone
)
SELECT *,
       (Avg_Worry_Masker - Avg_Worry_NonMasker) AS Worry_Diff_Masker_vs_NonMasker
FROM Masker_Worry;



    


