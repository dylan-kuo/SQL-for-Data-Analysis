/* CTE Common table exprssions */
/*
A common table expression is a temporary result set which you can reference within another 
SQL statement including `select`, `insert`, `update`, or `delete`.

Advantages:
- (1) improve the readability of complex queries
- (2) ability to create recursive queries
- (3) use in conjunction with window function.
*/


-- Ex 1. A simple CTE example
WITH cte_film AS (
	SELECT film_id, 
	       title, 
	       (CASE
		   		WHEN length < 30 THEN 'Short'
		        WHEN length < 90 THEN 'Medium'
	            ELSE 'Long'
	        END) length
	FROM film	
)
SELECT film_id, title, length
FROM cte_film
WHERE length ='Long'
ORDER BY title;


-- Ex 2. Joining a CTE with a table example
WITH cte_rental AS (
	SELECT staff_id, COUNT(rental_id) rental_count
	FROM rental
	GROUP BY staff_id
)
SELECT s.staff_id, s.first_name, s.last_name, c.rental_count
FROM staff s
INNER JOIN cte_rental c
ON s.staff_id = c.staff_id;

-- or 
WITH cte_rental AS (
	SELECT staff_id, COUNT(rental_id) rental_count
	FROM rental
	GROUP BY staff_id
)
SELECT s.staff_id, s.first_name, s.last_name, c.rental_count
FROM staff s
INNER JOIN cte_rental c
USING (staff_id);


-- Ex 3. Using CTE with a window function example
WITH cte_film AS (
	SELECT film_id, title, rating, length, 
		   RANK() OVER (
		   		PARTITION BY rating
		        ORDER BY length DESC) length_rank
	FROM film	
)
SELECT *
FROM cte_film
WHERE length_rank = 1;
