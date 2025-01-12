"Find the 3 most profitable companies in the world. Sort the result based on profits in descending order. 
If multiple companies have the same profit, assign them the same rank and include all tied companies in the top results. 
Output the result along with the corresponding company name."

with ranked_companies as (
select
company,
profits,
DENSE_RANK() OVER (ORDER BY profits DESC)as ranking
from forbes_global_2010_2014
)
select company,
profits
from ranked_companies
where ranking <= 3
