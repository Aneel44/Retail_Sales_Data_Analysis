-- create database
CREATE DATABASE sql_project;

-- drop table if already exist
DROP TABLE IF EXISTS retail_sales;

-- create table
CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY NOT NULL,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(15),
	AGE INT,
	CATEGORY VARCHAR(15),
	QUANTITY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

SELECT
	*
FROM
	RETAIL_SALES
LIMIT
	10;

-- Count the total number of rows
SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

-- data cleaning
-- checking for null value of every column
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

--delete the null values
DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

-- Data Exploration
-- how many sales we have in the dataset.
SELECT
	COUNT(*) AS TOTAL_SALES
FROM
	RETAIL_SALES;

-- How many unique customer in the data
SELECT
	COUNT(DISTINCT (CUSTOMER_ID))
FROM
	RETAIL_SALES;

-- How many category in the data
SELECT DISTINCT
	(CATEGORY)
FROM
	RETAIL_SALES;

-- Data analysis and Business probelms
-- 01 Write SQL Query to retrieve all columns for sales made on 2022-11-05
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';

/* 02 Write a SQL Query to retrieve all transcation where the category is 'clothing' and 
quantity sold is more than 3 in the month of nov-2022 */
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTITY >= 3;

-- 03 Write SQL Query to calcualte the total_sales (total_sale) for each category
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS TOTAL_SALES,
	COUNT(*) AS TOTAL_ORDER
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

-- 04 Write SQL Query to find the average age of customer who purchased items for 'Beauty' category.
SELECT
	ROUND(AVG(AGE), 2) AS AVG_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty'
	-- 05 Write SQL Query to find all the transcations where the total_sale is geater than 1000.
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000;

/* 06 Write a SQL Query to find the total number of tanscations (transcation_id) made by  
each gender in each category. */
SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANSCATION
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY,
	GENDER
ORDER BY
	CATEGORY;

/* 07 Write a SQL Query to calculate the average sale for each month. 
find out the best selling month in each year.*/
SELECT
	YEAR,
	MONTH,
	AVG_SALE
FROM
	(
		SELECT
			EXTRACT(
				YEAR
				FROM
					SALE_DATE
			) AS YEAR,
			EXTRACT(
				MONTH
				FROM
					SALE_DATE
			) AS MONTH,
			ROUND(CAST(AVG(TOTAL_SALE) AS NUMERIC), 2) AS AVG_SALE,
			RANK() OVER (
				PARTITION BY
					EXTRACT(
						YEAR
						FROM
							SALE_DATE
					)
				ORDER BY
					ROUND(CAST(AVG(TOTAL_SALE) AS NUMERIC), 2) DESC
			) AS RANK
		FROM
			RETAIL_SALES
		GROUP BY
			YEAR,
			MONTH
	) AS T1
WHERE
	RANK = 1;

-- 08 Write SQL Query to find the top 5 customers based on the highest total sales
SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS TOTAL_SALE
FROM
	RETAIL_SALES
GROUP BY
	CUSTOMER_ID
ORDER BY
	TOTAL_SALE DESC
LIMIT
	5;

-- 09 Write a SQL Query to find the number of unique customer who purchased items from each category.
SELECT
	CATEGORY,
	COUNT(DISTINCT (CUSTOMER_ID)) AS DISTINCT_CUSTOMERS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

-- 10 Write a SQL Query to create each shift and number of orders(example morning shift <= 12, afternoon beween 12 & 17 and evening > 17)
WITH
	HOUR_BASED_SALE AS (
		SELECT
			*,
			CASE
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) < 12 THEN 'Morning'
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) BETWEEN 12 AND 17  THEN 'Afternoon'
				ELSE 'Evening'
			END AS SHIFT
		FROM
			RETAIL_SALES
	)
SELECT
	SHIFT,
	COUNT(*) AS TOTAL_ORDER
FROM
	HOUR_BASED_SALE
GROUP BY
	SHIFT;