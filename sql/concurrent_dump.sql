with inc as (
	select  i.inc_num, u.primary_unit, i."zone", u.dispatch_time, u.clear_time, u.inc_date
	from units u 
	inner join incidents i 
		on i.inc_num = u.inc_num
	order by u.inc_date, u.dispatch_time
),
concurrent as (
	select distinct i.inc_num, (i.inc_date::date  + i.dispatch_time::time)::timestamp dispatch_time, (i.inc_date::date  + i.clear_time::time)::timestamp clear_time, (u2.inc_date + u2.dispatch_time)::timestamp add_unit_dsp
	from inc i
	left join units u2
		on u2.dispatch_time > i.dispatch_time 
		and u2.dispatch_time < i.clear_time
		and u2.inc_date = i.inc_date 
	group by i.inc_num, i.primary_unit, i.zone, i.dispatch_time, i.clear_time, i.inc_date, add_unit_dsp
)
select * from concurrent  order by dispatch_time;