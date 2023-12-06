create database if not exists salesdatawalmart;
create table if not exists sales (invoice_id VARCHAR(30) not null primary key, 
branch varchar(5) not null, city varchar(30) not null, customer_type varchar(30) not null,
gender varchar(10) not null, product_line varchar(100) not null, unit_price decimal(10,2) not null, quantity int not null, VAT float(6,4) not null,total decimal(10,2) not null, 
date datetime not null, time TIME not null,payment_method VARCHAR(15) NOT NULL, cogs DECIMAL(10, 2) not null, gross_margin_percentage FLOAT(11, 9) not null,
gross_income DECIMAL(10, 2) not null, rating FLOAT(2, 1) sales);


-- -----------------------------------Feature Engineering-----------------------------------

select time,
( case when `time` between "00:00:00" and "12:00:00" then "Morning"
when `time` between "12:01:00" and "16:00:00" then " Afternoon"
else "Evening" end) as time_date_day from sales;

-- ------------------------- adding time column time_day------------------

alter table sales  add column time_of_day varchar(20) not null;

update sales
set time_of_day =(
case
     when `time` between "00:00:00" and "12:00:00" then "Morning"
	 when `time` between "12:01:00" and "16:00:00" then " Afternoon"
     else "Evening" 
     end);
-- -------------------------------- adding day_name column---------------------------------------------     

alter table sales add column day_name varchar (10);

-- -------- dayname function-----
select date, dayname(date)
from sales;

-- -------------------------- updating column day_name---------------
update sales
set day_name = ( dayname(date));


-- ------------------------------ month_name-----------------------------
select date, monthname(date)
from sales;

alter table sales add column month_name varchar (10);

update sales
set month_name = ( monthname(date));     

/*Business Questions To Answer
How many unique cities does the data have?*/

select distinct city 
from sales; 

-- -----------------In which city is each branch?---------------------

select 
   distinct city,
   branch
from sales; 
-- ---------- products---------------------
-- ----------How many unique product lines does the data have?

select count(distinct product_line)
from sales;

-- -------------What is the most common payment method?

select payment_method from sales;


select payment_method,
       count(payment_method) as most_common
from sales
group by payment_method;      

-- ---------------------------- What is the most selling product line?------

SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;

-- ----------------------------------What is the total revenue by month?
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue;

-- --------------------------What month had the largest COGS?
select cogs as cog, month_name,
 sum(total) as largest_cog
 from sales
 group by month_name
 order by cogs desc;
 
 -- ----------------------What product line had the largest revenue?
 
 select product_line, 
 sum(total) as largest_prodct_r
 from sales
 group by product_line
 order by product_line desc;
 
 -- ---------- What is the city with the largest revenue?
select city,branch, 
 sum(total) as City_largest_r
 from sales
 group by city
 order by branch desc;
 
 -- ------------------What product line had the largest VAT?
 
 select product_line,VAT, 
 sum(total) as Largest_VAT
 from sales
 group by product_line
 order by VAT desc;
 -- -----------------------Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
 
 SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

select product_line,CASE when avg(quantity) >= 6 then "Good"
     else "Bad"
     end as remark
from sales
group by  product_line; 

-- -------------------------- Which branch sold more products than average product sold?

select branch, 
sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- --------------What is the most common product line by gender?

select gender, product_line,
count(gender) as most_cm_pct
from sales
group by gender,product_line
order by most_cm_pct desc;

-- --------------------- What is the average rating of each product line?

select round(avg(rating),2) as rating_avg,
product_line
from sales
group by product_line
order by rating_avg desc;
-- -------------------- 
-- ------------------------------------  Sales------------

-- -----------------------Number of sales made in each time of the day per weekday

select time_of_day,
count(*) as total_sales
from sales
where day_name ="Friday"
group by time_of_day
order by total_sales desc;

-- --------------Which of the customer types brings the most revenue?

select customer_type,
sum(total) as total_Rev
from sales 
group by customer_type
order by total_Rev desc;
-- ----------------------------- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,
round (avg(VAT),2) as VAT
from sales
group by city
order by VAT desc;
-- -----------------Which customer type pays the most in VAT?

select customer_type,
round (avg(VAT),2) as VAT
from sales
group by customer_type
order by VAT desc;
 -- --------------------------------------
 -- ---------------Customer
 
 -- -----------------How many unique customer types does the data have?
 
 select 
 distinct customer_type
 from sales;
 
 -- -------------- How many unique payment methods does the data have?
 select distinct payment_method as unique_payment_method
 from sales;
 
 
 -- -------------What is the most common customer type?
 select customer_type,
 count(*) as common_customer
 from sales
 group by customer_type
 order by common_customer desc;
 -- -- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day of the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;
-- Mon, Tue and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?

-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;
