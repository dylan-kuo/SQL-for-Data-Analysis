/*
COALESCE function that returns the first non-null argument
Reference: https://www.postgresqltutorial.com/postgresql-coalesce/

The syntax:
COALESCE (argument_1, argument_2, …);


The COALESCE function accepts an unlimited number of arguments. 
It returns the first argument that is not null. 
If all arguments are null, the COALESCE function will return null.

The COALESCE function provides the same functionality as NVL or IFNULL function provided by SQL-standard.

*/


-- Firstly, we create table items and populate some records
CREATE TABLE items (
    ID SERIAL PRIMARY KEY,
	product VARCHAR(100) NOT NULL,
	price NUMERIC NOT NULL,
	discount NUMERIC
);

INSERT INTO items(product, price, discount)
VALUES
    ('A', 1000, 10),
	('B', 1500, 20),
	('C', 800, 5),
	('D', 500, NULL);

-- Second we query the net prices of the products using the following formula:
-- net_price = price - discount

SELECT
      product,
	  (price - discount) AS net_price
FROM items;

-- The get the right price, we need to assume that if the discount is null, it is zero. 
-- Then we can use the COALESCE function as follows:

SELECT 
      product,
	  (price - COALESCE(discount,0)) AS net_price
FROM items;


/*
Besides using the COALESCE function, you can use the CASE expression to handle the null values in this case. 
See the following query that uses the CASE expression to achieve the same result above.
*/

SELECT 
      product,
	  (
	    price - CASE
		             WHEN discount IS NULL THEN 0
		             ELSE discount
		        END
	  ) AS net_price
FROM items;

/*
In the query above we say if the discount is null then use zero (0) otherwise use discount value to in the expression that calculate the net price.
*/