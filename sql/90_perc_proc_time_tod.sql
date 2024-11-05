with fire_inc as (
	select distinct u.inc_num, case when dispatch_time - received_time <  interval '00:00:00' then dispatch_time - received_time + interval '24 hours' else dispatch_time - received_time end process_time, 
	extract('hour' from inc_alarm_date_time)::int as "Hour"
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where dispatch_time is not null
	order by process_time desc
),
dumb_things_fire as (
	select * 
	from fire_inc
	where process_time < interval '00:10:00'
	and process_time > interval '00:00:03'
),
fire_count as (
	select "Hour", percentile_cont(0.9) within group (order by process_time)  process_time, count(process_time) total
	from dumb_things_fire
	group by "Hour"
	order by "Hour"
)
select * from fire_count;