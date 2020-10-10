/*
PostgreSQL subquery
A subquery is a query nested inside another query such as SELECT, INSERT, DELETE and UPDATE.
*/

/* NOTE
Subqueries are usually fine unless they are dependent subqueries (also known as correlated subqueries). 
If you are only using independent subqueries and they are using appropriate indexes then they should run quickly. 
If you have a dependent subquery you might run into performance problems because a dependent subquery typically needs to be run once for each row in the outer query. 
So if your outer query has 1000 rows, the subquery will be run 1000 times. 
On the other hand an independent subquery typically only needs to be evaluated once.
*/


-- To construct a subquery, we put the second query in brackets and use it in the WHERE clause as an expression:
SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (
            SELECT AVG(rental_rate)
            FROM film);
			

-- subquery with IN operator
-- To get films that have the returned date between 2005-05-29 and 2005-05-30 (both date are inclusive)
SELECT film_id, title
FROM film
WHERE film_id IN (
              SELECT inventory.film_id
              FROM rental
              INNER JOIN inventory
              ON inventory.inventory_id = rental.inventory_id
              WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30'
      );


-- subquery with EXISTS operator
-- If the subquery returns any row, the EXISTS operator returns true, false if no row.
/*
The EXISTS operator only cares about the number of rows returned from the subquery,not the content of the rows, therefore, the common coding convention of EXISTS operator is as follows:

EXISTS (SELECT 1 FROM tbl WHERE condition);
*/

SELECT first_name, last_name
FROM customer
WHERE EXISTS (SELECT 1 
			  FROM payment 
			  WHERE payment.customer_id = customer.customer_id);