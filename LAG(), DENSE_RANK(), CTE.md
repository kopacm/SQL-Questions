

**MySQL Functions Used**

- `DISTINCT`
- `LAG()`
- `SUM()`
- `COUNT()`
- `MAX()`
- `DENSE_RANK()`
- `CASE` statement
- `WITH` (Common Table Expressions)

---

## My Step-by-Step Approach

When tackling this problem, I knew I needed to identify consecutive dates of user activity. My goal was to find the top 3 users with the longest streaks on or before August 10, 2022. Here is how I broke it down:

1. **Filtering and Cleaning**: First, I needed to ensure I was working with unique daily visits. I selected distinct `user_id` and `date_visited` combinations and filtered out any data after the target date of '2022-08-10'

2. **Identifying Gaps**:  I used the `LAG()` window function. By comparing the current `date_visited` with the previous one (partitioned by user), I could determine if a day was part of a streak. If the difference was exactly 1 day, it was a continuation. If not, it marked the start of a new streak.

3. **Creating Streak IDs**: I converted those "new streak" flags (0 or 1) into a unique identifier for each streak. I did this by calculating a running `SUM()` of the flags. This assigned the same ID to all consecutive days in a single streak.

4. **Measuring Lengths**: With a unique identifier for every streak (`streak_id`), I simply grouped by `user_id` and `streak_id` and used `COUNT(*)` to find out how long each streak lasted.

5. **Ranking Users**: Finally, I found the maximum streak length for each user and used `DENSE_RANK()` to rank them. I chose `DENSE_RANK` so that if multiple users tied for a spot, they would all be included without skipping rank numbers.


## How I Changed My Approach

Initially, I considered using self-joins to compare a row with the row of the "previous day." However, I realized that approach would be computationally expensive and difficult to read, especially when calculating the length of long streaks.

I changed my approach to use **Window Functions** (`LAG` and `SUM` over windows). This allowed me to process the data in a single pass for each step without complex joins. It made the code more modular and much easier to debug. The final result was a clean, step-by-step CTE structure that clearly identified the longest streaks and filtered for the top 3 rankings efficiently

## SQL Code Solution

```sql
/* 
  Step 1: Filter the data for the relevant timeframe.
*/
WITH unique_visits AS (
    SELECT DISTINCT 
        user_id,
        date_visited
    FROM user_streaks
    WHERE date_visited <= DATE '2022-08-10'
),

/* 
  Step 2: Identify when a streak breaks.
  I used LAG to look at the previous row's date. 
  If the difference is 1 day, new_streak is 0 (continuation).
  Otherwise, it's 1 (start of a new streak).
*/
streak_flags AS (
    SELECT 
        *,
        CASE 
            WHEN date_visited - LAG(date_visited) OVER (PARTITION BY user_id ORDER BY date_visited) = 1 THEN 0 ELSE 1
        END AS new_streak
    FROM unique_visits
),

/* 
  Step 3: Create a unique ID for each streak.
  By calculating a cumulative SUM of the 'new_streak' flags, 
  consecutive days (where flag is 0) get the same ID.
*/
streak_ids AS (
    SELECT 
        *,
        SUM(new_streak) OVER (PARTITION BY user_id ORDER BY date_visited) AS streak_id
    FROM streak_flags
),

/* 
  Step 4: Calculate the length of each streak.
  I group by the user and the specific streak_id generated above.
*/
streak_length AS (
    SELECT
        user_id,
        streak_id,
        COUNT(*) AS streak_lengths
    FROM streak_ids
    GROUP BY
        user_id,
        streak_id
),

/* 
  Step 5: Find the longest streak for each user.
 I aggregated again to get the single max value per user.
*/
longest_streak AS (
    SELECT 
        user_id,
        MAX(streak_lengths) AS max_streak
    FROM streak_length
    GROUP BY 
        user_id
    ORDER BY 
        max_streak DESC
),

/* 
  Step 6: Rank the users based on their longest streak.
  DENSE_RANK ensures ties are handled (e.g., two users at rank 1).
*/
ranking_streak AS (
    SELECT 
        user_id,
        max_streak,
        DENSE_RANK() OVER (ORDER BY max_streak DESC) AS ranking 
    FROM longest_streak
)

/* 
  Final Step: Select the top 3 users.
*/
SELECT 
    user_id,
    max_streak
FROM ranking_streak
WHERE ranking <= 3;

```




