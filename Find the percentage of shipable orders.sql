"Find the percentage of shipable orders.
Consider an order is shipable if the customer's address is known."

with percentage as (
select count(
case when c.address is not null 
then c.id else null end
) as shipable,
count(c.id) as total
from orders o
join customers c on o.cust_id = c.id)
select
(shipable/total)*100 as per_shipable
from percentage
