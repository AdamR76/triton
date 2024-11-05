with fire_inc as (
	select distinct u.inc_num, case when dispatch_time - received_time <  interval '00:00:00' then dispatch_time - received_time + interval '24 hours' else dispatch_time - received_time end process_time
	from units u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num	
	where inc_code::text like '1%%'
	and dispatch_time is not null
	and indistrict = 1
	order by process_time desc
),
dumb_things_fire as (
	select * 
	from fire_inc
	where process_time < interval '00:10:00'
	and process_time > interval '00:00:03'
),
med_inc as (
	select u.inc_num, case when dispatch_time - received_time <  interval '00:00:00' then dispatch_time - received_time + interval '24 hours' else dispatch_time - received_time end process_time
	from units u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where inc_code::text like '3%%'
	and dispatch_time is not null
	and indistrict = 1
),
dumb_things_med as (
	select * 
	from med_inc
	where process_time < interval '00:10:00'
	and process_time > interval '00:00:03'
),
other_inc as (
	select u.inc_num, case when dispatch_time - received_time <  interval '00:00:00' then dispatch_time - received_time + interval '24 hours' else dispatch_time - received_time end process_time
	from units u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where not inc_code::text like '1%%'
	and not inc_code::text like '3%%'
	and dispatch_time is not null
	and indistrict = 1
),
dumb_things_other as (
	select * 
	from other_inc
	where process_time < interval '00:10:00'
	and process_time > interval '00:00:03'
)
select 'fire' call_type, percentile_cont(0.9) within group (order by process_time)
from dumb_things_fire
union
select 'medical' call_type, percentile_cont(0.9) within group (order by process_time)
from dumb_things_med
union
select 'other' call_type, percentile_cont(0.9) within group (order by process_time)
from dumb_things_other