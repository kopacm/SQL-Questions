```
Queries used: 

▪▪ GROUP BY 
▪▪ ORDER BY 
▪▪ Subqueries 
▪▪ RANK 
▪▪ LIMIT 
```

I wrote a query to **find the top 5 businesses with the most reviews**. Since each row represented a unique business with its total review count, I selected the business name and total reviews, then ordered the results by review count in descending order and limited the output to 5 rows.

This ensured that I outputted the **top 5 businesses by review count**, showing their names and total review numbers.

```sql
SELECT 
    name, 
    reviewcount 
FROM (
    SELECT 
        name, 
        reviewcount, 
        RANK() OVER (ORDER BY reviewcount DESC) AS ranking  -- Window function assigns ranks; ties get same rank, next skips
    FROM yelp_business  -- Source table with unique businesses and review counts
) AS rankingtop5  -- Subquery alias
WHERE ranking <= 5  -- Filter for top 5 ranks only
-- No GROUP BY needed since rows are already aggregated per business
-- ORDER BY not needed in outer query as LIMIT handles top results naturally
;
```


## What I learned ? 

- **RANK() OVER(ORDER BY ...)** returns the same rank **for ties** (rows with equal values).
	- The next rank **skips** numbers after ties.
    - Example: If two businesses tie for 3rd place, both get rank 3. The next business will be ranked 5 (not 4).

If you use **DENSE_RANK()**, then you would see: **1, 2, 3, 4, 5**—even when there are ties.

- **DENSE_RANK()**: gives the same rank to tied values, but does **not** skip the next number.
- Example:

| name        | review_count | dense_rank |
| ----------- | ------------ | ---------- |
| Iron Chef   | 331          | 1          |
| Jacs Dining | 197          | 2          |
| Grimaldi's  | 187          | 3          |
| Bella Vista | 187          | 3          |
| Signs       | 120          | 4          |


If you use **ROW_NUMBER()**, then you would get: **1, 2, 3, 4, 5** with **no ties at all**—each row gets its own unique number, even if values are the same.

- **ROW_NUMBER()**: unique number for each row, based on the ordering, regardless of ties.
- Example:

| name        | review_count | row_number |
|-------------|--------------|------------|
| Iron Chef   | 331          | 1
| Jacs Dining | 197          | 2
| Grimaldi's  | 187          | 3
| Bella Vista | 187          | 4
| Signs       | 120          | 5

| Function         | Ties get same rank? | Next rank skips? | Outputs (with a tie at 3rd place) |
| ---------------- | ------------------- | ---------------- | --------------------------------- |
| [[RANK()]]       | Yes                 | Yes              | 1, 2, 3, 3, 5                     |
| [[DENSE_RANK()]] | Yes                 | No               | 1, 2, 3, 3, 4                     |
| [[ROW_NUMBER()]] | No                  | N/A              | 1, 2, 3, 4, 5                     |

