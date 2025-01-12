"We have data on rental properties and their owners. 
Write a query that figures out how many different apartments (use unit_id) are owned by people under 30,
broken down by their nationality. 
We want to see which nationality owns the most apartments, so make sure to sort the results accordingly."

select count(distinct(unit_id)) as apartments , nationality
from airbnb_hosts h
join airbnb_units u on h.host_id = u.host_id
where age < 30 and unit_type = 'apartment'
group by nationality
order by apartments desc
