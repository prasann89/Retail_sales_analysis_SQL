DROP table if EXISTs sales;
CREATE TABLE sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,	
	sale_time	TIME,
	customer_id	 VARCHAR(20),
	gender	VARCHAR(10),
	age	INT,
	category VARCHAR(20),	
	quantity	INT,
	price_per_unit FLOAT,	
	cogs FLOAT,	
	total_sale FLOAT
);

SELECT
	* 
	FROM sales;

-- Finding missing values or Null VALUES

SELECT 
	*
	From sales
WHERE
	transactions_id is Null
	or
		sale_date is Null
	or	
		sale_time is Null
	or
		customer_id	  is Null
	or
		gender is Null
	or
		age is Null
	or
		category is Null
	or
		quantity is Null
	or
		price_per_unit is Null
	or
		cogs is Null
	or
		total_sale  is Null
	;
-- Removing Null values
delete from sales
WHERE
	transactions_id is Null
	or
		sale_date is Null
	or	
		sale_time is Null
	or
		customer_id	  is Null
	or
		gender is Null
	or
		age is Null
	or
		category is Null
	or
		quantity is Null
	or
		price_per_unit is Null
	or
		cogs is Null
	or
		total_sale  is Null
	;

-- how many sales we have?
select count(*) FROM sales;

-- Total number of Customers and Categories
SELECT count(distinct customer_id) from sales;
SELECT distinct category from sales;


-- DATA ANALYSIS

--  Monthly Revenue Trend
-- Show total sales per month across all categories.
SELECT
	category,
	EXTRACT (MONTH FROM sale_date) as Month,
	SUM(total_sale)
FROM sales
	GROUP BY 1,2
	ORDER BY 2,3 DESC;
	
--  Best-Selling Product Categories
-- Which categories generated the highest total sales?
SELECT
	category,
	SUM(total_sale)
FROM sales
	GROUP BY 1
	ORDER  BY 2 DESC;
	
--  Customer Demographics Analysis
-- What is the average spending by gender and age group?
SELECT
	age,
	gender,
	AVG(total_sale) AS average_spending
FROM sales
	GROUP BY 1,2
	ORDER  BY 3 DESC;

--  Repeat Customers vs One-Time Buyers
-- How many customers made more than one purchase?

-- Step 1: Count how many purchases each customer made
WITH customer_purchase_counts AS (
    SELECT
        customer_id,
        COUNT(*) AS purchase_count
    FROM sales
    GROUP BY customer_id
)

-- Step 2: Count repeat vs one-time customers
SELECT
    SUM(CASE WHEN purchase_count = 1 THEN 1 ELSE 0 END) AS one_time_customers,
    SUM(CASE WHEN purchase_count > 1 THEN 1 ELSE 0 END) AS repeat_customers
FROM customer_purchase_counts;

--  Average Quantity Sold per Transaction by Category
-- What's the average quantity per sale in each category?
SELECT
	category,
	ROUND(AVG(quantity), 2) AS average_quantity
FROM sales
	GROUP BY 1
	ORDER  BY 2 DESC;

--  Peak Shopping Hours
-- Which hour of the day has the highest total sales?
SELECT
	EXTRACT (HOUR FROM sale_time) as hour,
	SUM(total_sale)
FROM sales
	GROUP BY 1
	ORDER BY 2 DESC;

--  Age Group Performance
-- Group customers by age brackets (e.g., 18–25, 26–35...) and analyze their sales behavior.
SELECT
	CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25'
        WHEN age BETWEEN 26 AND 35 THEN '26–35'
        WHEN age BETWEEN 36 AND 45 THEN '36–45'
        WHEN age BETWEEN 46 AND 60 THEN '46–60'
        WHEN age > 60 THEN '60+'
		ELSE 'Unknown'
	END AS age_group,
	COUNT(*) AS total_transactions,
    AVG(total_sale) AS avg_sale
FROM sales
	GROUP BY 1
	ORDER BY 1;


--  Customer Lifetime Value (CLTV)
-- Total revenue per customer — sorted from highest to lowest.
SELECT
	customer_ID,
	SUM(total_sale)
FROM sales
	GROUP BY 1
	ORDER  BY 2 DESC;

-- Number of orders in each shift 
-- total orders in morning <=12 afternoon between 12 and 17 , eveninig >17
WITH hourly_sale
AS
(SELECT *,
	CASE
        WHEN EXTRACT (HOUR FROM sale_time) <12 THEN 'Morning'
        WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT (HOUR FROM sale_time) >=17 THEN 'Evening'
	END AS shift 
FROM sales
)SELECT
	shift,
	COUNT (*) AS total_orders
FROM hourly_sale
GROUP BY 1;

-- END OF PROJECT
