with total_inc as (
	select count(*) as total
	from incidents i
	inner join district d
		on d.inc_num = i.inc_num
	where d.indistrict = 1
),
inc_counts as (
	select extract('hour' from inc_alarm_date_time)::int as "Hour", count(*) as "TOTAL"
	from incidents i 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where d.indistrict = 1
	group by extract('hour' from inc_alarm_date_time)
	order by extract('hour' from inc_alarm_date_time)
)
select "Hour", 100.0 * round("TOTAL" / (select total from total_inc)::numeric, 3) perc
from inc_counts