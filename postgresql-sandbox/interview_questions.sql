/*
Sample question: On many social network services (i.e. Twitter, Facebook, Quora, etc.), there is a way for a user to follow another account to hear their status updates. In particular, lots of users follow sport players. We want to understand how many users follow sport players.

The schema: A table listing all the sport players' accounts of interest. 2nd table listing all of Instagram's users' basic information. 3rd table that logged all follows among accounts. (Follower_id and target_id are both referring user_id).

sport_accounts (
user_name string, -- e.g. 'michaelphelps', 'peyton_manning'
sport_category string -- e.g. 'NBA', 'NFL'
)

dim_all_users (
user_id int,
user_name string,
registration_date string,
active_last_month boolean
)

follow_relations (
follower_id int,
target_id int,
following_date string
)


*/

-- Question 1: How many total users follow sport accounts?
SELECT 
  COUNT(DISTINCT t3.follower_id) AS cnt_all_sport_followers
FROM sport_accounts t1
INNER JOIN dim_all_users t2
ON t1.user_name = t2.user_name
INNTER JOIN follow_relations t3
ON t2.user_id = t3.target_id



-- Question 2: How many ACTIVE users follow each type of sport?
SELECT 
  COUNT(DISTINCT t4.user_id) AS cnt_sports_category_followers
FROM sport_accounts t1
INNTER JOIN dim_all_users t2
ON t1.user_name = t2.user_name
INNTER JOIN follow_relations t3
ON t2.user_id = t3.target_id
INNTER JOIN dim_all_users t4
ON t3.follower_id = t4.user_id
  AND t4.active_last_month is true
GROUP BY 1;