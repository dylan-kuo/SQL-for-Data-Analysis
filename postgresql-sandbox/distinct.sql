/*
The DISTINCT clause is used in the SELECT statement to remove duplicate rows from a result set. 
The DISTINCT clause keeps one row for each group of duplicates. 
The DISTINCTclause can be applied to one or more columns in the select list of the SELECT statement.
*/


-- Case 1: single column used to evaluate the duplicate
/*
SELECT
   DISTINCT column1
FROM
   table_name;
*/


-- Case 2: combination of multiple columns used to evaluate the duplicate
/*
SELECT
   DISTINCT column1, column2
FROM
   table_name;
*/


-- Case 3: Keep the 'first' row of each group of duplicates
-- Note: It is a good practice to always use the ORDER BY clause with the DISTINCT ON(expression) 
--       to make the result set predictable.
/*
SELECT
   DISTINCT ON (column1) column_alias,
   column2
FROM
   table_name
ORDER BY
   column1,
   column2;
*/


CREATE TABLE distinct_demo (
    id serial NOT NULL PRIMARY KEY,
	bcolor VARCHAR,
	fcolor VARCHAR
);


INSERT INTO distinct_demo (bcolor, fcolor)
VALUES
	('red', 'red'),
	('red', 'red'),
	('red', NULL),
	(NULL, 'red'),
	('red', 'green'),
	('red', 'blue'),
	('green', 'red'),
	('green', 'blue'),
	('green', 'green'),
	('blue', 'red'),
	('blue', 'green'),
	('blue', 'blue');
	
	
SELECT
	id,
	bcolor,
	fcolor
FROM
	distinct_demo ;
	
	
-- case 1: DISTINCT single column
SELECT
	DISTINCT bcolor
FROM
	distinct_demo
ORDER BY
	bcolor;


-- case 2: DISTINCT multiple columns
SELECT
	DISTINCT bcolor,
	fcolor
FROM
	distinct_demo
ORDER BY
	bcolor,
	fcolor;
	
	
-- case 3: DISTINCT ON 
/* 
The following statement sorts the result set by the  bcolor and  fcolor, and then for each group of duplicates, 
it keeps the first row in the returned result set.
*/

SELECT
	DISTINCT ON (bcolor) bcolor,
	fcolor
FROM
	distinct_demo 
ORDER BY
	bcolor,
	fcolor;