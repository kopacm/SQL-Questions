"Find the date with the highest total energy consumption from the Meta/Facebook data centers.
Output the date along with the total energy consumption across all data centers."

WITH miro AS (
    SELECT date, consumption
    FROM fb_eu_energy
    UNION ALL
    SELECT date, consumption
    FROM fb_na_energy
    UNION ALL
    SELECT date, consumption
    FROM fb_asia_energy
),
ranking as (SELECT 
date,
sum(consumption) as total,
rank() over ( order by sum(consumption)desc )  rnk
FROM miro
group by date)
select date,total
from ranking
where rnk = 1
