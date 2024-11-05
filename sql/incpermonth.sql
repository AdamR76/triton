with incidentMonth as (
	select extract ('month' from inc_alarm_date_time)::int "month", count(*) inc
	from incidents i 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type) 
	group by month
	order by "month"
)
select month as "Month", inc/3 as "AVG_INC"
from incidentMonth