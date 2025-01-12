"Calculate the net change in the number of products launched by companies in 2020 compared to 2019. 
Your output should include the company names and the net difference.
(Net difference = Number of products launched in 2020 - The number launched in 2019.)"

with p_19 as(
select company_name,
count(product_name) as pr_19
from car_launches
where year = '2019'
group by company_name),

p_20 as (
select company_name,
count(product_name) as pr_20
from car_launches
where year = '2020'
group by company_name)

select 
p_19.company_name,
pr_20-pr_19 as net
from p_19
left join p_20 on p_19.company_name=p_20.company_name
