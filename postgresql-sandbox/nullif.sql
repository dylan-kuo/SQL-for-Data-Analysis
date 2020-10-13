/*
PostgreSQL NULLIF - Handle null values
Source: https://www.postgresqltutorial.com/postgresql-nullif/

--
Syntax:
NULLIF(argument_1,argument_2);

The NULLIF function returns a null value if argument_1 equals to argument_2, otherwise it returns argument_1.

--
For examples:

SELECT
	NULLIF (1, 1); -- return NULL

SELECT
	NULLIF (1, 0); -- return 1

SELECT
	NULLIF ('A', 'B'); -- return A

*/

-- First, we create a table 
CREATE TABLE posts (
        id SERIAL PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	excerpt VARCHAR(150),
	body TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP
);

-- Insert some sameple data
INSERT INTO posts (title, excerpt, body)
VALUES
      ('test post 1','test post excerpt 1','test post body 1'),
      ('test post 2','','test post body 2'),
      ('test post 3', null ,'test post body 3');
	  

-- Third, display the posts overview page that shows title and excerpt of each posts.
SELECT id, title, excerpt
FROM posts;


-- To substitute this null value, we can use the COALESCE function as follows:
SELECT id, title, COALESCE(excerpt, LEFT(body, 40))
FROM posts;


-- Unfortunately, there is mix between null value and ” (empty) in the excerpt column. 
-- This is why we need to use the NULLIF function:
SELECT id, 
       title, 
       COALESCE(
		   NULLIF(excerpt, ''), 
		   LEFT(body, 40)
       )
FROM posts;

/* First, the NULLIF function returns a null value if the excerpt is empty, otherwise it returns the excerpt. 
   Second, the COALESCE function checks if the first argument, which is provided by the NULLIF function,
   if it is null, then it returns the first 40 characters of body; otherwise it returns the excerpt in case the excerpt is not null.
*/




/* Use NULLIF to prevent division-by-zero error */
-- First, we create a new table
CREATE TABLE members (
        id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender SMALLINT NOT NULL -- 1: male, 2: female
);

-- Second, we insert some rows
INSERT INTO members (
	first_name,
	last_name,
	gender
)
VALUES
	('John', 'Doe', 1),
	('David', 'Dave', 1),
	('Bush', 'Lily', 2);

-- Third, calculate the ratio between male and female members:
SELECT
      (SUM (
	      CASE 
		  WHEN gender = 1 THEN 1 ELSE 0
	      END
	  ) / SUM (
	      CASE
		  WHEN gender = 2 THEN 1 ELSE 0
	      END
	  )) * 100 AS "Male/Female ratio"
FROM members;

/*
To calcualte the total number of male members, we use the SUM funciton and CASE expression.
If the gender is 1, the CASE returns 1, otherwise it returns 0; the SUM funciton is used to calculate total of male members.
The same logic is also applied for calculating the total number of female numbers.

Then the total of male members is divided by the total of female members to return the ratio. In this case, it return 200%.
*/


-- Fourth, let's remve the female member:
DELETE 
FROM members
WHERE gender = 2;


-- If we execute the query to calcualte the male/female ratio again, we got an error message
-- The reason is the the number of female is zero. To prevent this division by zero error, we use the NULLIF function as follows:
SELECT
      (SUM(
	      CASE 
		  WHEN gender = 1 THEN 1 ELSE 0
	      END
	  ) / NULLIF (
	      SUM (
		       CASE 
			   WHEN gender = 2 THEN 1 ELSE 0
		       END
		  ), 0
	  )) * 100 AS "Male/Female ratio"

FROM members;

/*
The NULLIF function checks if the number of female members is zero, it returns null. 
The total of male members is divided by a null value returns a null value.
*/

