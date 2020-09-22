/* Window Functions 

A window function is an SQL function where the input values are taken from a "window" 
of one or more rows in the results set of a SELECT statement.

Window functions are distinguished from other SQL functions by the presence of an OVER clause. 
If a function has an OVER clause, then it is a window function. 
If it lacks an OVER clause, then it is an ordinary aggregate or scalar function. 
Window functions might also have a FILTER clause in between the function and the OVER clause.

Reference: https://www.postgresqltutorial.com/postgresql-window-function/
*/

-- First, create tow tables for the demonstrations:
CREATE TABLE product_groups (
    group_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	group_name VARCHAR(255) NOT NULL
);

CREATE TABLE products (
    product_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_name VARCHAR(255) NOT NULL,
	price DECIMAL (11, 2),
	group_id INT NOT NULL,
	FOREIGN KEY (group_id) REFERENCES product_groups (group_id)
);

-- Second, insert some rows into theses tables:

INSERT INTO product_groups (group_name)
VALUES
	('Smartphone'),
	('Laptop'),
	('Tablet');
	
INSERT INTO products (product_name, group_id, price)
VALUES
	('Microsoft Lumia', 1, 200),
	('HTC One', 1, 400),
	('Nexus', 1, 500),
	('iPhone', 1, 900),
	('HP Elite', 2, 1200),
	('Lenovo Thinkpad', 2, 700),
	('Sony VAIO', 2, 700),
	('Dell Vostro', 2, 800),
	('iPad', 3, 700),
	('Kindle Fire', 3, 150),
	('Samsung Galaxy Tab', 3, 200);


-- Introduction to PostgreSQL window functions

-- Regular aggregation function
SELECT 
      group_name,
	  AVG(price)
FROM  products
JOIN  product_groups USING (group_id)
GROUP BY group_name;

-- Window function
SELECT 
      product_name,
	  price,
	  group_name,
	  AVG(price) OVER (PARTITION BY group_name) ::NUMERIC(10, 2)
FROM  products
JOIN  product_groups USING (group_id)



/* 
The ROW_NUMBER(), RANK(), and DENSE_RANK() functions assign an integer 
to each row based on its order in its result set.
*/

