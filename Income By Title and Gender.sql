"Find the average total compensation based on employee titles and gender. 
Output the employee title, gender (i.e., sex), along with the average total compensation."
    
SELECT 
    employee_title,
    sex,
    avg(salary + total_bonus) as avg_compensation
from sf_employee e
join 
    (SELECT worker_ref_id,
            SUM(bonus) AS total_bonus
    FROM sf_bonus
    GROUP BY worker_ref_id) b on e.id = b.worker_ref_id
GROUP BY employee_title,
         sex
