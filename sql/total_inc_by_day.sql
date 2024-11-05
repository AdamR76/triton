select to_char(inc_alarm_date_time, 'Dy') as "Day", count(*) inc
from incidents i 
inner join codes c 
	on lower(c.inc_desc) = lower(i.inc_type) 
group by to_char(inc_alarm_date_time, 'Dy')
order by 
	to_char(inc_alarm_date_time, 'Dy') != 'Mon', 
	to_char(inc_alarm_date_time, 'Dy') != 'Tue',
	to_char(inc_alarm_date_time, 'Dy') != 'Wed',
	to_char(inc_alarm_date_time, 'Dy') != 'Thu',
	to_char(inc_alarm_date_time, 'Dy') != 'Fri',
	to_char(inc_alarm_date_time, 'Dy') != 'Sat'