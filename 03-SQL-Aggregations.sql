/*
1. Find the total amount of poster_qty paper ordered in the orders table.
2. Find the total amount of standard_qty paper ordered in the orders table.
3. Find the total dollar amount of sales using the total_amt_usd in the 
orders table.
4. Find the total amount for each individual order that was spent on standard and 
gloss paper in the orders table. This should give a dollar amount for each order in the table.
5. Though the price/standard_qty paper varies from one order to the next. 
I would like this ratio across all of the sales made in the orders table.
*/

-- 1
SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;

-- 2
SELECT SUM(standard_qty) AS total_standard_sales
FROM orders;

-- 3
SELECT SUM(total_amt_usd) AS total_dollar_sales
FROM orders;

-- 4
SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

-- 5
SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;
