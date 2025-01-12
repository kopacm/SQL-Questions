select 
first_name,
target
from ( select
first_name,
target,
rank() over(order by target desc) as ranking
from salesforce_employees
where manager_id = 13 ) as ranked_employees
where ranking = 1
