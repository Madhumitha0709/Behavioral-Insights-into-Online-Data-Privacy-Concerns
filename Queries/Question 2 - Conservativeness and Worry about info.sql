/* 2. How does conservativeness interact with concerns about personal information on the Internet, and does this relationship change across US regions?
•	Advanced SQL concept: Conditional aggregation, multi-level GROUP BY, correlated subqueries
•	Aggregate average "Worry.About.Info" by region and conservativeness score (possibly using CASE WHEN).
•	Compare results across different regions in one result set.
*/

-- Data Cleaning
CREATE TABLE AnonymityPoll_Clean_Conservativeness AS
SELECT *
FROM AnonymityPoll
WHERE Conservativeness IS NOT NULL;

CREATE TABLE AnonymityPoll_Clean_Conservativeness_WorryInfo AS
SELECT *
FROM AnonymityPoll_Clean_Conservativeness
WHERE Worry_About_Info IS NOT NULL;

-- Aggregate Worry Scores by Region and Conservativeness
SELECT 
    Region,
    Conservativeness,
    AVG(Worry_About_Info) AS avg_worry
FROM AnonymityPoll_Clean_Conservativeness_WorryInfo
WHERE Worry_About_Info IS NOT NULL
GROUP BY Region, Conservativeness
ORDER BY avg_worry;

-- Use CASE WHEN to Create Conservativeness Buckets
SELECT
    Region,
    CASE 
        WHEN Conservativeness BETWEEN 1 AND 2 THEN 'Low'
        WHEN Conservativeness = 3 THEN 'Medium'
        WHEN Conservativeness BETWEEN 4 AND 5 THEN 'High'
    END AS conservativeness_level,
    AVG(Worry_About_Info) AS avg_worry
FROM AnonymityPoll_Clean_Conservativeness_WorryInfo
WHERE Worry_About_Info IS NOT NULL
GROUP BY Region, conservativeness_level
ORDER BY Region, conservativeness_level;

-- Compare Region Averages with the Overall Average
SELECT 
    Region,
    Conservativeness,
    AVG(Worry_About_Info) AS avg_worry,
    AVG(Worry_About_Info) - (
        SELECT AVG(Worry_About_Info) 
        FROM AnonymityPoll_Clean_Conservativeness_WorryInfo
        WHERE Worry_About_Info IS NOT NULL
    ) AS difference_from_overall
FROM AnonymityPoll_Clean_Conservativeness_WorryInfo
WHERE Worry_About_Info IS NOT NULL
GROUP BY Region, Conservativeness
ORDER BY difference_from_overall DESC;

-- Highlight Regions with Largest Differences Using RANK
SELECT 
    Region,
    Conservativeness,
    AVG(Worry_About_Info) AS avg_worry,
    RANK() OVER (PARTITION BY Region ORDER BY AVG(Worry_About_Info) DESC) AS worry_rank
FROM AnonymityPoll_Clean_Conservativeness_WorryInfo
WHERE Worry_About_Info IS NOT NULL
GROUP BY Region, Conservativeness
ORDER BY Region, worry_rank;
