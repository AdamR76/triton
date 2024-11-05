with turnout_times as (
	select unit, case when enroute_time - dispatch_time <  interval '00:00:00' then enroute_time - dispatch_time + interval '24 hours' else enroute_time - dispatch_time end turnout_time
	from cad u 
	inner join incidents i
		on u.inc_num = i.inc_num
	where unit != ''
	and dispatch_time is not null
	and enroute_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
	group by unit, turnout_time
	order by unit desc
),
filtered as (
	select * 
	from turnout_times
	where turnout_time < interval '00:10:00'
		and turnout_time > interval '00:00:03'
),
perc as (
	select unit, percentile_cont(0.9) within group (order by turnout_time) unit_90
	from filtered
	group by unit
)
select unit, date_trunc('second', unit_90) as turnout_time_90th
from perc;