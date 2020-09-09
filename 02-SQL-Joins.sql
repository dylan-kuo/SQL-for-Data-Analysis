/*
1. Try pulling all the data from the accounts table, and all the data from the 
orders table.
2. Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, 
and the website and the primary_poc from the accounts table.
*/
SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

SELECT orders.standard_qty, 
       orders.gloss_qty, 
       accounts.website, 
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id



