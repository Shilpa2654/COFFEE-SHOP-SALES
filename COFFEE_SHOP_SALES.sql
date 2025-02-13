create database coffe_shop;
use coffe_shop;
alter table coffee_shop change column ï»¿transaction_id transaction_id int;

#1.What is the total sales revenue?
SELECT round( sum(transaction_qty * unit_price),2) AS total_sales_revenue
FROM coffee_shop;

#2.How many transactions occurred in total?
select count(transaction_id) as total_transactions from coffee_shop;

#3.What are the most frequently purchased products?
select product_detail , count(transaction_id) as frequently_purchased from coffee_shop
group by product_detail
order by frequently_purchased desc;


#4.What are the different product categories available?
select product_category from coffee_shop;

#5.What is the average unit price of all products?
select round(avg(unit_price),2) as avg_unit_price from coffee_shop;

#6.Which store location has the highest number of transactions?
select store_location, round(count(transaction_id),2) as total_transactions from coffee_shop
group by store_location
order by total_transactions desc;

#7.What is the total revenue generated per store location?
select store_location, round(sum(transaction_id * unit_price),2) as total_revenue from coffee_shop
group by store_location
order by total_revenue desc;

#8.What are the top 5 best-selling products?
select product_detail, count(transaction_id) as sales from coffee_shop
group by product_detail
order by sales desc
limit 5;

#9.What is the sales distribution across different product categories?
select product_category,
		sum(transaction_qty) as total_unit_sold, 
		round(sum(transaction_qty)*100 / (select sum(transaction_qty)  from coffee_shop),2) as percentage_share from coffee_shop
group by product_category
order by total_sales desc;

#10.What is the average number of products purchased per transaction?
select avg(transaction_qty) as avg_product_sold from coffee_shop;

#11.Which time of the day has the highest number of transactions?
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS total_transactions
FROM coffee_shop
GROUP BY time_of_day
ORDER BY total_transactions DESC;

#12.What are the peak sales hours for each store location?
SELECT store_location, 
		EXTRACT(HOUR FROM transaction_time) AS Peak_hour,
        COUNT(*) AS Total_Transactions 
FROM coffee_shop
GROUP BY store_location, Peak_hour
ORDER BY Total_Transactions DESC ;

#13.How does the sales trend vary across different months?
SELECT
    EXTRACT(MONTH FROM transaction_date) AS MONTH,
	SUM(transaction_qty) AS TOTAL_SALES,
	ROUND(SUM(transaction_qty * unit_price),2) AS TOTAL_SALES_REVENUE 
FROM coffee_shop
GROUP BY  month
ORDER BY TOTAL_SALES DESC;

#IF THEY ASK BOTH YEAR AND MONTH
SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year,
    EXTRACT(MONTH FROM transaction_date) AS month,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty*unit_price),2) AS total_sales_revenue
FROM coffee_shop
GROUP BY year, month
ORDER BY year, month;		

# to chech the data type
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'coffee_shop';

#to covert text to date
UPDATE coffee_shop 
SET transaction_date = STR_TO_DATE(transaction_date, '%Y-%m-%d');

ALTER TABLE coffee_shop 
MODIFY COLUMN transaction_date DATE;

#14.What is the correlation between product price and quantity sold?
SELECT 
   ROUND( (SUM(unit_price * transaction_qty) - (SUM(unit_price) * SUM(transaction_qty) / COUNT(*))) /
    (SQRT(SUM(unit_price * unit_price) - (SUM(unit_price) * SUM(unit_price) / COUNT(*))) * 
     SQRT(SUM(transaction_qty * transaction_qty) - (SUM(transaction_qty) * SUM(transaction_qty) / COUNT(*)))
    ),4) AS price_quantity_correlation
FROM coffee_shop;

#15.Are there any seasonal patterns in sales?
SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year,
    EXTRACT(MONTH FROM transaction_date) AS month,
    ROUND(SUM(transaction_qty *unit_price),2) AS total_sales
FROM coffee_shop
GROUP BY year, month
ORDER BY year, month;


#16.Which products have the highest revenue contribution across all stores?
SELECT product_detail, ROUND(SUM(transaction_qty*unit_price),2) AS TOTAL_REVENUE_SALES
FROM coffee_shop
GROUP BY product_detail
ORDER BY TOTAL_REVENUE_SALES DESC
LIMIT 10;

#17.Can we identify customer purchasing patterns based on time and location?
SELECT 
    store_location,
    EXTRACT(HOUR FROM transaction_time) AS hour,
    COUNT(*) AS total_transactions
FROM coffee_shop
GROUP BY store_location, hour
ORDER BY store_location, total_transactions DESC;

#Finding Peak Shopping Days Per Store
SELECT 
    store_location,
    EXTRACT(DAY FROM transaction_date) AS DAY,
    COUNT(*) AS total_transactions
FROM coffee_shop
GROUP BY store_location, DAY
ORDER BY store_location, total_transactions DESC;

