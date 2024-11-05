with fire_inc as (
	select distinct u.inc_num, case when  enroute_time - dispatch_time <  interval '00:00:00' then enroute_time - dispatch_time + interval '24 hours' else enroute_time - dispatch_time end turnout_time
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where inc_code::text like '1%%'
	and dispatch_time is not null
	and enroute_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
	order by turnout_time desc
),
dumb_things_fire as (
	select * 
	from fire_inc
	where turnout_time < interval '00:10:00'
	and turnout_time > interval '00:00:03'
),
med_inc as (
	select u.inc_num, case when  enroute_time - dispatch_time <  interval '00:00:00' then enroute_time - dispatch_time + interval '24 hours' else enroute_time - dispatch_time end turnout_time
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where inc_code::text like '3%%'
	and dispatch_time is not null
	and i.response_mode = 'Code 3'
	and enroute_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
),
dumb_things_med as (
	select * 
	from med_inc
	where turnout_time < interval '00:10:00'
	and turnout_time > interval '00:00:03'
),
other_inc as (
	select u.inc_num, case when  enroute_time - dispatch_time <  interval '00:00:00' then enroute_time - dispatch_time + interval '24 hours' else enroute_time - dispatch_time end turnout_time
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where not inc_code::text like '1%%'
	and not inc_code::text like '3%%'
	and dispatch_time is not null
	and i.response_mode = 'Code 3'
	and enroute_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
),
dumb_things_other as (
	select * 
	from other_inc
	where turnout_time < interval '00:10:00'
	and turnout_time > interval '00:00:03'
)
select 'fire' call_type, percentile_cont(0.9) within group (order by turnout_time)
from dumb_things_fire
union
select 'medical' call_type, percentile_cont(0.9) within group (order by turnout_time)
from dumb_things_med
union
select 'other' call_type, percentile_cont(0.9) within group (order by turnout_time)
from dumb_things_other;