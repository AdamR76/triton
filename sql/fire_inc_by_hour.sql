select extract('hour' from inc_alarm_date_time)::int as "Hour", count(*) as "TOTAL"
from incidents i 
inner join codes c 
	on lower(c.inc_desc) = lower(i.inc_type)
where inc_code::text like '1%%'
group by extract('hour' from inc_alarm_date_time)
order by extract('hour' from inc_alarm_date_time)