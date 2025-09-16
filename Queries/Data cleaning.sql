CREATE DATABASE privacy_analytics;
USE privacy_analytics;

CREATE TABLE AnonymityPoll (
    Internet_Use TINYINT,
    Smartphone TINYINT,
    Sex VARCHAR(10),
    Age INT,
    State VARCHAR(50),
    Region VARCHAR(20),
    Conservativeness INT,
    Info_On_Internet INT,
    Worry_About_Info INT,
    Privacy_Importance FLOAT,
    Anonymity_Possible TINYINT,
    Tried_Masking_Identity TINYINT,
    Privacy_Laws_Effective TINYINT
);

-- DATA CLEANING

DESCRIBE AnonymityPoll;
SELECT * FROM AnonymityPoll LIMIT 10;

SET SQL_SAFE_UPDATES = 0;

UPDATE AnonymityPoll
SET
    Sex = NULLIF(Sex, 'NULL'),
    State = NULLIF(State, 'NULL'),
    Region = NULLIF(Region, 'NULL');

SELECT DISTINCT Age FROM AnonymityPoll ORDER BY Age;

SELECT DISTINCT State FROM AnonymityPoll WHERE State LIKE '%NULL%';

UPDATE AnonymityPoll SET State = 'South Carolina' WHERE TRIM(State) LIKE 'South CaroliNULL%';
UPDATE AnonymityPoll SET State = 'North Carolina' WHERE TRIM(State) LIKE 'North CaroliNULL%';
UPDATE AnonymityPoll SET State = 'Montana' WHERE TRIM(State) LIKE 'MontaNULL%';
UPDATE AnonymityPoll SET State = 'Louisiana' WHERE TRIM(State) LIKE 'LouisiaNULL%';
UPDATE AnonymityPoll SET State = 'Indiana' WHERE TRIM(State) LIKE 'IndiaNULL%';
UPDATE AnonymityPoll SET State = 'Arizona' WHERE TRIM(State) LIKE 'ArizoNULL%';

SELECT DISTINCT Region FROM AnonymityPoll WHERE Region LIKE '%NULL%';

UPDATE AnonymityPoll SET Sex = 'Female' WHERE LOWER(Sex) = 'female';
UPDATE AnonymityPoll SET Sex = 'Male' WHERE LOWER(Sex) = 'male';

SELECT
    SUM(Age IS NULL) AS NullAge,
    SUM(Sex IS NULL) AS NullSex,
    SUM(State IS NULL) AS NullState,
    SUM(Conservativeness IS NULL) AS NullConservativeness,
    SUM(Info_On_Internet IS NULL) AS NullInfoOnInternet,
    SUM(Worry_About_Info IS NULL) AS NullWorryAboutInfo,
    SUM(Privacy_Importance IS NULL) AS NullPrivacyImportance,
    SUM(Anonymity_Possible IS NULL) AS NullAnonymityPossible,
    SUM(Tried_Masking_Identity IS NULL) AS NullTriedMaskingIdentity,
    SUM(Privacy_Laws_Effective IS NULL) AS NullPrivacyLawsEffective
    FROM AnonymityPoll;
