/* 
The Best Medium-Hard Data Analyst SQL Interview Questions 
By Zachary Thomas 
https://quip.com/2gwZArKuWk7W

Note: solutions are written in PostgreSQL
*/

-- *** Self-JOin Problems ***

/* --------------------------------------------------------------------------
#1: Month-over-Month Percent Change

Context: Oftentimes it's useful to know how much a key metric, 
         such as monthly active users, changes between months. 
         Say we have a table logins in the form:   

| user_id | date       |
|---------|------------|
| 1       | 2018-07-01 |
| 234     | 2018-07-02 |
| 3       | 2018-07-02 |
| 1       | 2018-07-02 |
| ...     | ...        |
| 234     | 2018-10-04 |

Task: Find the month-over-month percentage change for monthly active users (MAU). 

Refernece: CTE  https://www.postgresql.org/docs/9.1/queries-with.htm
           DATE_TRUNC() https://mode.com/blog/date-trunc-sql-timestamp-function-count-on/  
           DATE/TIME - interval  https://www.postgresql.org/docs/9.1/functions-datetime.html
		   ROUND() https://www.w3resource.com/PostgreSQL/round-function.php
*/

-- #1 Solution:


WITH mau AS (
  SELECT DATE_TRUNC('month', date) month_timestamp,
         COUNT(DISTINCT user_id) mau
  FROM logins
  GROUP BY DATE_TRUNC('month', date)
)


SELECT 
  a.month_stamp previous_month, 
  a.mau previous_mau,
  b.month_timestamp current_month,
  b.mau current_mau,
  ROUND(100.0*(b.mau-a.mau)/a.mau, 2) AS percent_change
FROM mau a
JOIN mau b 
ON a.month_timestamp = b.month_timestamp - interval '1 month'


 
/* --------------------------------------------------------------------------
#2: Tree Structure Labeling

*Context:* Say you have a table tree with a column of nodes 
           and a column corresponding parent nodes 

node   parent
1       2
2       5
3       5
4       3
5       NULL 

*Task:* Write SQL such that we label each node as a “leaf”, “inner” or “Root” node, 
        such that for the nodes above we get: 

node    label  
1       Leaf
2       Inner
3       Inner
4       Leaf
5       Root

Refernece: Tree data structure terminology http://ceadserv1.nku.edu/longa//classes/mat385_resources/docs/trees.html
           CASE  https://www.postgresqltutorial.com/postgresql-case/
*/


-- #2 Solution:
-- *Note: *This solution works for the example above with tree depth = 2, 
--          but is not generalizable beyond that. 


WITH join_table AS(
  SELECT a.node a_node,
         a.parent a_parent,
	 b.node b_node,
	 b.parent b_parent
  FROM tree a
  LEFT JOIN tree b
  ON a.parent = b.node
)

SELECT 
  a_node node,
  CASE
      WHEN b.node IS NULL AND b_parent IS NULL THEN 'Root'
      WHEN b.node IS NOT NULL AND b_parent IS NOT NULL THEN 'Leaf'
      ELSE 'Inner'
FROM join_table


-- #2 Alternative solution (more generalizable solution ) without explicit joins:

SELECT 
    node, 
    CASE
        WHEN parent IS NULL THEN 'Root'
	WHEN node NOT IN 
            (SELECT parent FROM TREE WHERE parent IS NOT NULL) THEN 'Leaf'
	WHEN node IN (SELECT parent FROM tree) AND parent IS NOT NULL THEN 'Inner'
    END AS label	
FROM tree


/* --------------------------------------------------------------------------
#3: Retained Users Per Month (multi-part)


Context: Say we have login data in the table logins: 

| user_id | date       |
|---------|------------|
| 1       | 2018-07-01 |
| 234     | 2018-07-02 |
| 3       | 2018-07-02 |
| 1       | 2018-07-02 |
| ...     | ...        |
| 234     | 2018-10-04 |



PART 1 - RETENTION

Task: Write a query that gets the number of retained users per month. 
      In this case, retention for a given month is defined as the number of users 
	  who logged in that month who also logged in the immediately previous month. 

Reference: https://www.sisense.com/blog/use-self-joins-to-calculate-your-retention-churn-and-reactivation-metrics/
           De-duping https://www.dataqualityapps.com/know-how/121-postgresql-deduping-data.html
*/


-- Solution:
SELECT
  DATE_TRUNC('month', a.date) month_timestamp,
  COUNT(DISTINCT a.user_id) retained_users
FROM logins a
JOIN logins b
ON a.user_id = b.user_id 
  AND DATE_TRUNC('month', a.date) = DATE_TRUNC('month', b.date) + interval '1 month'
GROUP BY DATE_TRUNC('month', a.date)


-- Alternative solution
-- NOTE: De-duping user-login pairs before the self-join would make the solution more efficient (see below)
--       De-duping logins would also make the given solution to Part 2 and 3 of this problem more efficient as well.


WITH DistinctMonthlyUser AS (
    SELECT DISTINCT 
      DATE_TRUNC('month', date) month_timestamp,
      user_id
    FROM logins
)

SELECT 
  CurrentMonth.month_timestamp month_timestamp,
  COUNT(PriorMonth.user_id) AS retained_user_count
FROM DistinctMonthlyUser AS CurrentMonth
LEFT JOIN DistinctMonthlyUser AS PriorMonth
ON CurrentMonth.month_timestamp = PriorMonth + interval '1 month'
  AND CurrentMonth.user_id = PriorMonth.user_id


/* PART 2 - CHURN
*Task:* Now we’ll take retention and turn it on its head: 
        Write a query to find many users last month did not come back this month. 
		i.e. the number of churned users.  
*/

-- Solution

SELECT 
    DATE_TRUNC('month', a.date) month_timestamp,
	COUNT(DISTINCT b.user_id) churned_users
FROM logins a
FULL OUTER JOIN logins b
ON a.user_id = b.user_id
  AND DATE_TRUNC('month', a.date) = DATE_TRUNC('month', b.date) + interval '1 month'
WHERE a.user_id IS NULL
GROUP BY DATE_TRUNC('month', a.date)


/* PART 3 - REACTIVATION
*Context*: You now want to see the number of active users this month who have been reactivated 
            — in other words, users who have churned but this month they became active again. 
			Keep in mind a user can reactivate after churning before the previous month. 
			An example of this could be a user active in February (appears in logins), 
			no activity in March and April, but then active again in May (appears in logins), 
			so they count as a reactivated user for May . 
			
*Task:* Create a table that contains the number of reactivated users per month. 
*/ 

-- Solution

SELECT 
  DATE_TRUNC('month', a.date) month_timestamp,
  COUNT(DISTINCT a.user_id) reactivated_users,
  MAX(DATE_TRUNC('month', b.date)) most_recent_active_previously
FROM logins a
JOIN logins b
ON a.user_id = b.user_id
  AND DATE_TRUNC('month', a.date) > DATE_TRUNC('month', b.date)
GROUP BY DATE_TRUNC('month', a.date)
HAVING month_timestamp > most_recent_active_previously + interval '1 month'



/*
#4: Cumulative Sums 

*Acknowledgement:* This problem was inspired by Sisense’s“Cash Flow modeling in SQL” 
                   (https://www.sisense.com/blog/cash-flow-modeling-in-sql/) blog post 

*Context:* Say we have a table transactions in the form:

| date       | cash_flow |
|------------|-----------|
| 2018-01-01 | -1000     |
| 2018-01-02 | -100      |
| 2018-01-03 | 50        |
| ...        | ...       |


Where cash_flow is the revenues minus costs for each day. 

*Task: *Write a query to get cumulative cash flow for each day such that we end up with a table in the form below: 

| date       | cumulative_cf |
|------------|---------------|
| 2018-01-01 | -1000         |
| 2018-01-02 | -1100         |
| 2018-01-03 | -1050         |
| ...        | ...           |
 
 
 REFERENCE: window funciton https://www.postgresql.org/docs/9.1/tutorial-window.html
*/


-- Solution 

SELECT a.date,
       SUM(b.cash_flow) as cumulative_cf
FROM transactions a
JOIN transactions b 
ON a.date >= b.date 
GROUP BY a.date
ORDER BY date ASC  


-- Alternative solusion using window function (more efficient!)
SELECT 
    date,
	SUM(cash_flow) OVER (ORDER BY date ASC) as cumulative_cf
FROM transactions
ORDER BY date ASC



/*
#5: Rolling Averages

*Acknowledgement:* This problem is adapted from Sisense’s 
“Rolling Averages in MySQL and SQL Server”(https://www.sisense.com/blog/rolling-average/) blog post 

*Note:* there are different ways to compute rolling/moving averages. 
Here we'll use a preceding average which means that the metric for the 7th day of the month would be the average of the preceding 6 days and that day itself. 

*Context*: Say we have table signups in the form: 

| date       | sign_ups |
|------------|----------|
| 2018-01-01 | 10       |
| 2018-01-02 | 20       |
| 2018-01-03 | 50       |
| ...        | ...      |
| 2018-10-01 | 35       |

*Task*: Write a query to get 7-day rolling (preceding) average of daily sign ups. 
*/

SELECT 
    a.date,
	AVG(b.sign_ups) average_sign_ups
FROM signups a
JOIN signups b 
ON a.date <= b.date + interval '6 days' AND a.date >= b.date
GROUP BY a.date

