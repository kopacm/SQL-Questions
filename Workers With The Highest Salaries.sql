"Find the job titles of the employees with the highest salary. 
If multiple employees have the same highest salary, include the job titles for all such employees."

with highest_paid_titles as
(select 
dense_rank() Over ( order by w.salary desc) as ranking,
t.worker_title as title,
salary
from worker w
join title t on w.worker_id = t.worker_ref_id
)
select title
from highest_paid_titles
where ranking <=1

