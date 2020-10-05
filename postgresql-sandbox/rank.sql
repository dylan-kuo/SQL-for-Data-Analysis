/*
RANK() function assigns a rank to every row within a partition of a result set.


RANK() OVER (
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...
)

*/

CREATE TABLE ranks (
    c VARCHAR(10)
);


INSERT INTO ranks(c)
VALUES('A'),('A'),('B'),('B'),('B'),('C'),('E');


SELECT c
FROM ranks;

-- use the RANK() function to assign ranks to the rows in the result set of ranks table:
SELECT 
      c,
      RANK() OVER (
	  ORDER BY c
      ) rank_number
FROM ranks;



/*
We’ll use the products table to demonstrate the RANK() function:
1) Using PostgreSQL RANK() function for the whole result set
*/

SELECT
      product_id, 
      product_name, 
      price,
      RANK() OVER (
	  ORDER BY price DESC
      )
FROM products;



/*
2) Using PostgreSQL RANK() function with PARTITION BY clause example
*/

SELECT
      product_id, 
      product_name, 
      group_name,
      price,
      RANK() OVER (
          PARTITION BY p.group_id
	  ORDER BY price DESC
      ) price_rank
FROM products p
INNER JOIN product_groups g
  ON g.group_id = p.group_id; 

  
