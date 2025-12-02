
**Here are the MySQL functions I used:**

- DATEDIFF
- COUNT(DISTINCT ...)
- ROUND

## Question 

Market penetration is an important metric for understanding Spotify's performance and growth potential in different regions. You are part of the analytics team at Spotify and are tasked with calculating the active user penetration rate in specific countries.

For this task, 'active_users' are defined based on the following criterias:

- last_active_date: The user must have interacted with Spotify within the last 30 days. 
- sessions: The user must have engaged with Spotify for at least 5 sessions.
- listening_hours: The user must have spent at least 10 hours listening on Spotify.

Based on the condition above, calculate the active 'user_penetration_rate' by using the following formula.

- Active User Penetration Rate = (Number of Active Spotify Users in the Country / Total users in the Country)

Total Population of the country is based on both active and non-active users. ​ 

The output should contain 'country' and 'active_user_penetration_rate' rounded to 2 decimals.

Let's assume the current_day is 2024-01-31.


## Step 1: Interpreting the question

First, I focused on understanding what “active user penetration rate” means in this problem. I noted that the penetration rate is defined as active users divided by total users for each country, and that “active” is determined by three conditions: minimum sessions, minimum listening hours, and recent activity relative to a fixed date (2024-01-31). That told me I would need two key metrics per country: active_users and total_users.

## Step 2: First idea and adjustment

My initial thinking was to create one aggregated result directly, but I realized it would be clearer and more flexible to separate active users and total users into two CTEs. This way, I could independently verify that each CTE returned the expected counts. I also had to be careful with the “current date” reference; instead of using a dynamic function, I used the fixed date '2024-01-31' in the DATEDIFF condition to match the problem statement.

## Step 3: Building cte_active_users

Next, I created cte_active_users to capture only users who met the “active” criteria. In this CTE, I filtered rows using the three conditions: sessions >= 5, listening_hours >= 10, and DATEDIFF('2024-01-31', last_active_date) <= 30. I then grouped by country and used COUNT(DISTINCT user_id) to get the number of active users per country. This gave me a clean active_users metric by country.

## Step 4: Building cte_total_users

After that, I built cte_total_users to represent the total user base per country, without any activity filtering. I grouped by country and again used COUNT(DISTINCT user_id) as total_users. This ensured that both CTEs used a consistent definition of “user” and that the denominator in my penetration rate was correct.

## Step 5: Joining and calculating penetration rate

Finally, I joined cte_total_users with cte_active_users on country. In the SELECT, I calculated the penetration rate as ROUND(active_users / total_users, 2) and ordered the result by this ratio in descending order. This gave me the active user penetration rate per country, sorted from highest to lowest, which aligns with the business goal of comparing country performance.

## Final SQL solution

```sql
-- CTE to calculate active users per country based on the given conditions
with cte_active_users as (
select 
    country,
    count(distinct(user_id)) as active_users
from penetration_analysis
where 
    sessions >= 5 
    AND listening_hours >= 10 
    AND DATEDIFF('2024-01-31',last_active_date) <= 30
GROUP BY country
order by active_users desc
),

-- CTE to calculate total users per country
cte_total_users as (
select 
    country,
    count(distinct(user_id)) as total_users
from penetration_analysis
GROUP BY country
order by total_users desc
)

-- Final query to compute penetration rate per country
select 
    ctu.country,
    ROUND(active_users / total_users,2) as user_penetration_rate
from cte_total_users ctu
left join cte_active_users cau ON ctu.country = cau.country
order by active_users / total_users desc;

```

---
Links:
  - https://platform.stratascratch.com/coding/10369-spotify-penetration-analysis?code_type=3
---

