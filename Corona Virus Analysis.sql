-- creating a database called corona
CREATE DATABASE corona;

-- using the database
USE corona;

-- importing the dataset

-- showing tables
show tables;

SELECT * 
FROM `corona virus dataset`
LIMIT 10;

-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
SELECT *
FROM `corona virus dataset`
WHERE (Province) IS NULL OR
(`Country/Region`) IS NULL OR
(Latitude) IS NULL OR
(Longitude) IS NULL OR
(Date) IS NULL OR
(Confirmed) IS NULL OR
(Deaths) IS NULL OR
(Recovered) IS NULL;
-- Q2. If NULL values are present, update them with zeros for all columns. 

UPDATE `corona virus dataset`
SET 
	Province = COALESCE(Province,0),`Country/Region` = COALESCE(`Country/Region`,0), Latitude = COALESCE(Latitude,0),
    Longitude = COALESCE(Longitude,0), `Date` = COALESCE(`Date`,0), Confirmed = COALESCE(Confirmed,0),
    Deaths = COALESCE(Deaths,0), Recovered = COALESCE(Recovered,0)
WHERE 
(Province) IS NULL OR
(`Country/Region`) IS NULL OR
(Latitude) IS NULL OR
(Longitude) IS NULL OR
(Date) IS NULL OR
(Confirmed) IS NULL OR
(Deaths) IS NULL OR
(Recovered) IS NULL;
-- Q3. check total number of rows
SELECT COUNT(*)
FROM`corona virus dataset`;

-- Q4. Check what is start_date and end_date
SELECT MIN(`Date`)
FROM `corona virus dataset`;

SELECT MAX(`Date`)
FROM `corona virus dataset`;

-- Q5. Number of month present in dataset
SELECT COUNT(DISTINCT(MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')))) AS No_of_Months
FROM `corona virus dataset`;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT FLOOR(AVG(Confirmed)) AS Average_Confirmed, FLOOR(AVG(Deaths)) AS Average_deaths, FLOOR(AVG(Recovered)) AS Average_Recovered, MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Months
FROM `corona virus dataset`
GROUP BY Months;

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
-- , COUNT(Deaths) AS Frequent_deaths, COUNT(Recovered) AS Frequent_Recovered,
SELECT Confirmed,COUNT(*) AS total_count, MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Months
FROM `corona virus dataset`
GROUP BY Months, Confirmed;

SELECT MAX(Confirmed) AS Frequent_Confirmed,MAX(total_count), Months
FROM
(SELECT Confirmed,COUNT(*) AS total_count, MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Months
FROM `corona virus dataset`
GROUP BY Months, Confirmed) AS SUBQUERY
GROUP BY Months;


-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT Confirmed, Deaths, Recovered, YEAR(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Years
FROM`corona virus dataset`;

SELECT MIN(Confirmed) as Minimum_Confirmed,MIN(Deaths) AS Minimum_Deaths,MIN(Recovered) AS Minimum_Recovered, Years
FROM(SELECT Confirmed, Deaths, Recovered, YEAR(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Years
FROM`corona virus dataset`) AS SUBQUERY
GROUP BY Years;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT Confirmed, Deaths, Recovered, YEAR(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Years
FROM `corona virus dataset`;

SELECT MAX(Confirmed) AS Maximum_Confirmed,MAX(Deaths) AS Maximum_deaths, MAX(Recovered) AS Maximum_Recovered, Years
FROM(SELECT Confirmed, Deaths, Recovered, YEAR(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Years
FROM `corona virus dataset`) AS SUBQUERY
GROUP BY Years;
-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT Confirmed, Deaths, Recovered, MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Months
FROM `corona virus dataset`;

SELECT SUM(Confirmed) AS Total_Confirmed, SUM(Deaths) AS Total_Deaths, SUM(Recovered) AS Total_Recovered, Months
FROM(SELECT Confirmed, Deaths, Recovered, MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Months
FROM `corona virus dataset`) AS SUBQUERY
GROUP BY Months;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT `Country/Region`, SUM(Confirmed) AS Total_Confirmed, FLOOR(AVG(Confirmed)) AS Average_Confirmed, FLOOR(VARIANCE(Confirmed)) AS Variance_For_Confirmed, FLOOR(STDDEV(Confirmed)) AS stddev_for_Confirmed
FROM `corona virus dataset`
GROUP BY `Country/Region`
ORDER BY `Country/Region` ASC;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT `Country/Region`, Deaths, MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Months
FROM `corona virus dataset`;

SELECT `Country/Region`, Months, SUM(Deaths) AS Total_Deaths, FLOOR(AVG(Deaths)) AS Average_No_Of_Deaths, FLOOR(VARIANCE(Deaths)) AS Variance_Of_Deaths, FLOOR(STDDEV(Deaths)) AS Stddev_For_Deaths
FROM (SELECT `Country/Region`, Deaths, MONTH(STR_TO_DATE(`Date`, '%d-%m-%Y')) AS Months
FROM `corona virus dataset`) AS SUBQUERY
GROUP BY `Country/Region`,Months
ORDER BY `Country/Region`,Months ASC;
-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT `Country/Region`, SUM(Recovered) AS Total_Recovered, FLOOR(AVG(Recovered)) AS Average_Recovered, FLOOR(VARIANCE(Recovered)) AS Variance_of_Recovered ,FLOOR(STDDEV(Recovered)) AS stddev_Recovered
FROM `corona virus dataset`
GROUP BY `Country/Region`
ORDER BY `Country/Region` ASC;
-- Q14. Find Country having highest number of the Confirmed case
SELECT `Country/Region`, SUM(Confirmed) AS Total_Confirmed
FROM `corona virus dataset`
GROUP BY `Country/Region`
ORDER BY Total_Confirmed DESC
LIMIT 1;
-- Q15. Find Country having lowest number of the death case

SELECT `Country/Region`, SUM(Deaths) AS Total_Deaths
FROM (SELECT `Country/Region`, Deaths
FROM `corona virus dataset`) AS SUBQUERY
GROUP BY `Country/Region`
ORDER BY Total_Deaths ASC
LIMIT 1;
-- Q16. Find top 5 countries having highest recovered case
SELECT `Country/Region`, Total_Recovered
FROM (SELECT `Country/Region`, SUM(Recovered) AS Total_Recovered, FLOOR(AVG(Recovered)) AS Average_Recovered, FLOOR(VARIANCE(Recovered)) AS Variance_of_Recovered ,FLOOR(STDDEV(Recovered)) AS stddev_Recovered
FROM `corona virus dataset`
GROUP BY `Country/Region`
ORDER BY `Country/Region` ASC) AS SUBQUERY
ORDER BY Total_Recovered DESC
LIMIT 5;
