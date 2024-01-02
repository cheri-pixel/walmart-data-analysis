CREATE DATABASE IF NOT EXISTS salesdatawalmart;

USE salesdatawalmart;
 
CREATE TABLE sales (
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender CHAR(50) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quality INT NOT NULL,
VAT FLOAT(6, 4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10, 2) NOT NULL,
gross_margin_pct FLOAT(11, 9),
gross_income DECIMAL(12, 4) NOT NULL,
rating FLOAT(2,1)
);



-- ------------------------------------------------------------------
-- ------------------------ Feature Engineering ---------------------

-- time_of_day

SELECT
	time,
    (CASE
		WHEN 'time' BETWEEN "00.00.00" AND "12.00.00" THEN "morning"
        WHEN 'time' BETWEEN "12.01.00" AND "16.00.00" THEN "afetrnoon"
        ELSE "evening"
	END
    ) As time_of_date
FROM sales;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET time_of_day = (CASE
		WHEN 'time' BETWEEN "00.00.00" AND "12.00.00" THEN "morning"
        WHEN 'time' BETWEEN "12.01.00" AND "16.00.00" THEN "afetrnoon"
        ELSE "evening"
	END
);

-- day_name
SELECT
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10); 

UPDATE sales
SET day_name = DAYNAME(date);

-- moth_name
SELECT 
	date,
    MOTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);
-- -----------------------------------------------------------------

-- -----------------------------------------------------------------
-- --------------------------Generic--------------------------------

-- How many unique cities does the data have?
SELECT 
	DISTINCT city 
FROM sales;

SELECT 
	DISTINCT branch
FROM sales;

-- In which city is each year?

SELECT 
	DISTINCT city,
    branch
FROM sales;

-- ------------------------------------------------------
-- -------------------Product----------------------------

-- How many unique product line s does the data have?

SELECT 
	COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method/

SELECT
	payment_method,
	COUNT(payment_method) As cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- What is the most selling product line?

SELECT
	product_line,
	COUNT(product_line) As cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is total revenue by month?

SELECT
	month_name AS month, 
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue;

-- What month had largest cogs?

SELECT
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs;

 -- What product line has the largest revenue?

SELECT 
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;    

-- What is the city with the largest revenue?

SELECT 
	branch,
    city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;  

-- Which product line had the largest VAT?

SELECT
	product_line,
    AVG(VAT) as avg_tax
    FROM sales
    GROUP BY product_line
    ORDER BY avg_tax;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". If its greater than avg sales

SELECT
	branch,
    SUM(quality) AS qty
FROM sales 
GROUP BY branch 
HAVING SUM(quality) > (SELECT AVG (quality) FROM sales);

-- What is the most common product line by gender?

SELECT 
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales 
GROUP BY gender, product_line
ORDER BY total_cnt;

-- What is the average rating of each product line?

SELECT 
	AVG(rating) AS avg_rating,
    product_line
FROM sales 
GROUP BY product_line
ORDER  BY avg_rating;

-------------------------------------------------------------
-- ------------------Sales-----------------------------------

-- Number of slaes made in each time of day per weekday? 

SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "monday"
GROUP BY time_of_day
ORDER BY total_sales;
    
-- Which type of costumer brings the most revenue?

SELECT
	customer_type,
    SUM(total) AS total_revenue
FROM sales 
GROUP BY customer_type 
ORDER BY total_revenue;    

-- Which city has the largest tax percentage/ VAT (value added tax) ?

SELECT 
	 city,
     AVG(VAT) AS VAT
FROM sales 
GROUP BY city
ORDER BY VAT;    

-- Which customer type pays the most in VAT?

SELECT 
	customer_type,
     AVG(VAT) AS VAT
FROM sales 
GROUP BY customer_type
ORDER BY VAT;   

-- -----------------------------------------------------------------------
-- ----------------------------Customers----------------------------------

-- How many unique customer types does the data have?

SELECT
	DISTINCT customer_type
FROM sales;

-- How many payment method does the data have/

SELECT 
	DISTINCT payment_method
FROM sales;
    
-- Which customer type buys the most?

SELECT 
	customer_type,
    COUNT(*) AS cstm_cnt
FROM sales 
GROUP BY customer_type;
    
-- What is the gender of most of the customers?

SELECT 
	gender,
    COUNT(*) AS gender_cnt
from sales 
GROUP BY gender
ORDER BY gender_cnt;

-- What is the gender distribution per branch?

SELECT
	gender,
    COUNT(*) AS gender_cnt
from sales 
where branch = "C"
GROUP BY gender
ORDER BY gender_cnt;

-- Which time of the day customers give most ratings?

SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
Order by avg_rating;    

-- Which time of the day customers give most ratings per branch?

SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
where branch = "c"
GROUP BY time_of_day
Order by avg_rating;
    
-- Which day of the week has the best avg ratings?

SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating;

-- Which day of the week has the best avg ratings per branch?    
    
SELECT 
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "b"
GROUP BY day_name
ORDER BY avg_rating;
    
    
    
    
    
    
    -- 