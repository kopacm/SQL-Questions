
MySQL functions used:

- DATE()
- LAG()
- DATEDIFF()
- CASE WHEN
- WITH (CTE)
    

My approach for solving the "Finding Purchases" problem on StrataScratch.

I started by analyzing the problem: I needed to find Amazon customers (userid) who made a purchase within 7 days of their previous purchase. The amazon_transactions table has userid and created_at columns, so I knew I had to look at consecutive transactions per user.

Initially, I thought about using a self-join on the table, joining transactions where the second purchase's created_at was within 7 days of the first one for the same userid. But this got messy with handling multiple transactions and ensuring I got the previous one specifically, plus it might count non-consecutive pairs.

I changed my approach after realizing window functions would be cleaner. I used a CTE with LAG() to get each transaction's previous transaction date per userid, ordered by created_at. This was perfect because LAG() looks back exactly one row (the prior transaction) within each user's partition.

Then, in the main query, I applied DATEDIFF() between the current transaction date and the previous one, using CASE WHEN to flag if it was between 1 and 7 days. I filtered for those flags equal to 1 and selected distinct userids to get unique returning customers.

The final result was a clean list of userids who returned within 7 days. This approach scales well and handles multiple returns per user correctly.

```sql
WITH ordertransaction AS (
    -- CTE to calculate current and previous transaction dates per user
    SELECT 
        userid, 
        DATE(created_at) as transactiondate,  -- Extract date only for consistency
        LAG(DATE(created_at)) OVER (PARTITION BY userid ORDER BY created_at) as prevtransactiondate 
    FROM amazon_transactions
)
-- Main query to find users with returns within 7 days
SELECT DISTINCT userid 
FROM (
    SELECT 
        userid, 
        transactiondate, 
        prevtransactiondate, 
        CASE 
            WHEN DATEDIFF(transactiondate, prevtransactiondate) BETWEEN 1 AND 7 
            THEN 1 
            ELSE 0 
        END AS returnwithin7days
    FROM ordertransaction
) as returncustomer 
WHERE returnwithin7days = 1;

```

## What I have learned 

WITH AS is CTE (Common Table Expression) is a **temporary named result set** defined at the start of query

## Source

[StrataScratch](https://platform.stratascratch.com/coding/10553-finding-purchases?code_type=3)
