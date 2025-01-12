"Find the customer with the highest daily total order cost between 2019-02-01 to 2019-05-01. If customer had more than 
one order on a certain day, sum the order costs on daily basis. Output customer's first name, total cost of their items, and the date."
  
WITH highest_order AS (
    SELECT
        first_name,
        order_date,
        SUM(total_order_cost) AS total_day
    FROM customers c
    JOIN orders o ON o.cust_id = c.id
    GROUP BY order_date, first_name
    HAVING order_date BETWEEN '2019-02-01' AND '2019-05-01'
)
SELECT 
    first_name,
    order_date,
    total_day
FROM highest_order
"had to create otherwise SQL doesn't know which first_name and order_date
to show when there are multiple rows associated with that maximum total_day if i would use max(total_day) in a select" 
WHERE total_day = (SELECT MAX(total_day) FROM highest_order);
