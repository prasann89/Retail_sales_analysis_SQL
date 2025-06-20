# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Project1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Project1`.
- **Table Creation**: A table named `sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Project1;

CREATE TABLE sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM sales;
SELECT COUNT(DISTINCT customer_id) FROM sales;
SELECT DISTINCT category FROM sales;

SELECT * FROM sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. ** Monthly Revenue Trend
-- Show total sales per month across all categories.**:
```sql
SELECT
	category,
	EXTRACT (MONTH FROM sale_date) as Month,
	SUM(total_sale)
FROM sales
	GROUP BY 1,2
	ORDER BY 2,3 DESC;
```

2. ** Best-Selling Product Categories
-- Which categories generated the highest total sales?**:
```sql
SELECT
	category,
	SUM(total_sale)
FROM sales
	GROUP BY 1
	ORDER  BY 2 DESC;
```

3. **Customer Demographics Analysis
-- What is the average spending by gender and age group?**:
```sql
SELECT
	age,
	gender,
	AVG(total_sale) AS average_spending
FROM sales
	GROUP BY 1,2
	ORDER  BY 3 DESC;
```

4. **Repeat Customers vs One-Time Buyers
-- How many customers made more than one purchase?**:
```sql
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
```

5. **Average Quantity Sold per Transaction by Category
-- What's the average quantity per sale in each category?**:
```sql
SELECT
	category,
	ROUND(AVG(quantity), 2) AS average_quantity
FROM sales
	GROUP BY 1
	ORDER  BY 2 DESC;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Peak Shopping Hours
-- Which hour of the day has the highest total sales?**:
```sql
SELECT
	EXTRACT (HOUR FROM sale_time) as hour,
	SUM(total_sale)
FROM sales
	GROUP BY 1
	ORDER BY 2 DESC;
```

8. **Age Group Performance
-- Group customers by age brackets (e.g., 18–25, 26–35...) and analyze their sales behavior.**:
```sql
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
```

9. **Customer Lifetime Value (CLTV)
-- Total revenue per customer — sorted from highest to lowest.**:
```sql
SELECT
	customer_ID,
	SUM(total_sale)
FROM sales
	GROUP BY 1
	ORDER  BY 2 DESC;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

