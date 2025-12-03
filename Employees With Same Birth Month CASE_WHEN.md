
Links:
  - https://platform.stratascratch.com/coding/10355-employees-with-same-birth-month?code_type=3


At the beginning of this task, I used the following SQL concepts and constructs in MySQL:


- `GROUP BY` to aggregate at the department (profession) level
- `SUM()` as an aggregate function
- `CASE WHEN ... THEN ... ELSE ... END` for conditional aggregation


## How I approached the problem

First, I made sure I understood what the question was asking: for each department, I needed to count how many employees had birthdays in each month, and display those counts as 12 separate columns (one for each month). I also confirmed the table name (`employee_list`) and the key columns: `profession` for department and `birth_month` for the numeric month of birth.

Initially, my mental model was to group by both department and month, but that would have produced one row per `(profession, birth_month)` pair instead of a single row per department. I realized I needed a pivot-like structure: one row per profession and 12 columns for months, which pointed me towards conditional aggregation with `SUM(CASE WHEN ...)`.

## How I refined and corrected my approach

My first instinct was to extract the month from a date column (for example, using something like `MONTH(birthday)`), but once I noticed there was already a `birth_month` column, I simplified the logic by using that directly. This reduced complexity and avoided repeated function calls on the date field.

Next, I focused on the shape of the final output. I aliased `profession` as `department` to match the problem statement and then defined 12 expressions using `SUM(CASE WHEN birth_month = N THEN 1 ELSE 0 END)` for each month from 1 to 12. This gave me a clear and systematic way to count employees per month while ensuring that months with no employees would still show as 0 because of the `ELSE 0`.

## Final result and what I learned

The final query groups only by `profession`, ensuring that each profession appears once, with the month counts spread across the 12 columns. I learned that conditional aggregation is a powerful way to pivot data without using explicit PIVOT syntax, and that using an existing numeric month column (`birth_month`) keeps the query both clean and efficient.

This pattern is reusable for other similar pivot-style problems, just by changing the grouping column and the condition inside the `CASE`.

## Final SQL

```sql
SELECT
	-- Rename profession to department for clearer output
    profession AS department,      
    -- Count employees born in January etc.                 
    SUM(CASE WHEN birth_month = 1  THEN 1 ELSE 0 END) AS month_1,   
    SUM(CASE WHEN birth_month = 2  THEN 1 ELSE 0 END) AS month_2,  
    SUM(CASE WHEN birth_month = 3  THEN 1 ELSE 0 END) AS month_3,   
    SUM(CASE WHEN birth_month = 4  THEN 1 ELSE 0 END) AS month_4,   
    SUM(CASE WHEN birth_month = 5  THEN 1 ELSE 0 END) AS month_5,  
    SUM(CASE WHEN birth_month = 6  THEN 1 ELSE 0 END) AS month_6,  
    SUM(CASE WHEN birth_month = 7  THEN 1 ELSE 0 END) AS month_7,   
    SUM(CASE WHEN birth_month = 8  THEN 1 ELSE 0 END) AS month_8,  
    SUM(CASE WHEN birth_month = 9  THEN 1 ELSE 0 END) AS month_9,   
    SUM(CASE WHEN birth_month = 10 THEN 1 ELSE 0 END) AS month_10, 
    SUM(CASE WHEN birth_month = 11 THEN 1 ELSE 0 END) AS month_11, 
    SUM(CASE WHEN birth_month = 12 THEN 1 ELSE 0 END) AS month_12   
FROM employee_list
-- Aggregate at the department (profession) level      
GROUP BY profession;                                    
```


