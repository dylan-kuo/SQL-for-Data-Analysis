# SQL-for-Data-Analysis

I'll use this repo to provide introduction to data analysis using SQL language (PostgreSQL), which should be a must tool for every data analyst/data scientist - both for getting access to data, but more interesting, as a simple tool for advanced data analysis. The logic behind SQL is very similar to any other tool or language that used for data analysis (excel or python pandas). 


This repository contains the practices for the SQL concepts taught in the course [SQL for Data Analysis](https://in.udacity.com/course/sql-for-data-analysis--ud198) by [MODE](https://modeanalytics.com) at [Udacity](http://udacity.com/).

### Dataset: parch and posey 

You can restore the toy dataset  "parch and posey" to your local machines from the file **parch_and_posey_db** using the following steps:
1. Open Terminal.
2. Enter PostgreSQL console - `psql` 
3. Create a new database - `CREATE DATABASE parch_and_posey;`
4. Restore into the database - `pg_restore -d parch_and_posey /path/to/parch_and_posey_db`


### Topics:

[01-SQL-Basics](https://github.com/dylan-kuo/SQL-for-Data-Analysis/blob/master/01-Basic-SQL.sql)

[02-SQL-Joins](https://github.com/dylan-kuo/SQL-for-Data-Analysis/blob/master/02-SQL-Joins.sql)

[03-SQL-Aggregations](https://github.com/dylan-kuo/SQL-for-Data-Analysis/blob/master/03-SQL-Aggregations.sql)




---
This repo also contains a sub-repo for my notes & practices for the PostgreSQL from other resources 

[PostgreSQL Notes & Practices (postgresqltutorial.com)](https://github.com/dylan-kuo/SQL-for-Data-Analysis/tree/master/postgresql-sandbox)

[Medium-Hard-Interview-Questions (shared by Zachary Thomas)](https://github.com/dylan-kuo/SQL-for-Data-Analysis/blob/master/postgresql-sandbox/medium-hard-interview-questions.sql)
