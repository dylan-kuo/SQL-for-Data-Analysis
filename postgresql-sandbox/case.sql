/* 1. General CASE expression */

-- A) A general Case example
SELECT title, 
       length, 
	   CASE
	       WHEN length > 0
		       AND length <= 50 THEN 'Short'
		   WHEN length > 50 
		       AND length <= 120 THEN 'Medium'
		   WHEN length > 120 THEN 'Long'
	   END duration
FROM film
ORDER BY title;

-- B) Using CASE with an aggregate function example
SELECT
		SUM (
			CASE
			  WHEN rental_rate = 0.99 THEN 1 ELSE 0
			END
		) AS Economy,
		SUM (
			CASE
			  WHEN rental_rate = 2.99 THEN 1 ELSE 0
			END
		) AS Mass,
		SUM (
			CASE
			  WHEN rental_rate = 4.99 THEN 1 ELSE 0
			END
		) AS Premium
FROM film;


/* 2. Simple CASE expression */

-- A)
SELECT title,
       rating,
	   CASE rating
	     WHEN 'G' THEN 'General Audiences'
		 WHEN 'PG' THEN 'Parental Guidance Suggested'
		 WHEN 'PG-13' THEN 'Parents Strongly Cautioned'
		 WHEN 'R' THEN 'Restricted'
		 WHEN 'NC-17' THEN 'Adults only'
	   END rating_description
FROM film
ORDER BY title;

-- B) CASE expression with aggregate function
SELECT 
		SUM(CASE rating
		   		WHEN 'G' THEN 1 ELSE 0
		    END) "General Audiences",
		SUM(CASE rating
		   		WHEN 'PG' THEN 1 ELSE 0
		    END) "Parental Guidance Suggested",
		SUM(CASE rating
		   		WHEN 'PG-13' THEN 1 ELSE 0
		    END) "Parents Strongly Cautioned",
		SUM(CASE rating
		   		WHEN 'R' THEN 1 ELSE 0
		    END) "Restricted",
		sum(CASE rating
		   		WHEN 'NC-17' THEN 1 ELSE 0
		    END) "Adults Only"
FROM film;
