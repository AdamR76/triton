with fire_inc as (
	select distinct u.inc_num, case when  enroute_time - dispatch_time <  interval '00:00:00' then enroute_time - dispatch_time + interval '24 hours' else enroute_time - dispatch_time end turnout_time, 
	extract('hour' from inc_alarm_date_time)::int as "Hour"
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where dispatch_time is not null
	and enroute_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
	order by turnout_time desc
),
fire as (
	select inc_num, turnout_time, "Hour" 
	from fire_inc
	group by inc_num, "Hour", turnout_time
	order by turnout_time desc
)
select "Hour", date_trunc('second',percentile_cont(0.9) within group (order by turnout_time)), count(inc_num) total_inc_count
from fire
group by "Hour"