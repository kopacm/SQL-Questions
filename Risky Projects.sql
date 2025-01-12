"Identify projects that are overbudget. A project is overbudget if the prorated cost of all employees assigned to it exceeds the project’s budget.
To determine this, prorate each employee's annual salary to match the project's duration. For example, if a project with a six-month duration has a budget of $10,000.
Output a list of overbudget projects with the following details: project name, project budget, and prorated total employee expenses (rounded up to the nearest dollar).
Hint: Assume all years have 365 days and disregard leap years."


select 
title,
budget,
"ceiling returns the smallest integer value that is bigger than or equal to a number"
"DATEDIFF() function returns the number of days between two date values (end date first) "
CEILING((DATEDIFF(end_date, start_date) * SUM(emp.salary)/365)) AS prorated_employee_expense
from linkedin_projects
join linkedin_emp_projects p on linkedin_projects.id=p.project_id
join linkedin_employees emp on p.emp_id = emp.id 
group by p.project_id
having prorated_employee_expense > budget
