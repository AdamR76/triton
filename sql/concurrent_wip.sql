with inc as (
	select  i.inc_num, u.primary_unit, i."zone", u.dispatch_time, u.clear_time, u.inc_date
	from units u 
	inner join incidents i 
		on i.inc_num = u.inc_num
	order by u.inc_date, u.dispatch_time
),
concurrent as (
	select distinct i.dispatch_time, i.clear_time, i.inc_date, count(u2.dispatch_time) add_unit_dsp
	from inc i
	right join units u2
		on u2.dispatch_time > i.dispatch_time 
		and u2.dispatch_time < i.clear_time
		and u2.inc_date = i.inc_date 
	group by i.primary_unit, i.zone, i.dispatch_time, i.clear_time, i.inc_date
)
select * from concurrent  order by inc_date, dispatch_time;


with inc as (
	select  i.inc_num, u.primary_unit, i."zone", u.dispatch_time, u.clear_time, u.inc_date
	from units u 
	inner join incidents i 
		on i.inc_num = u.inc_num
	order by u.inc_date, u.dispatch_time
)
select  ii.inc_num, ii.primary_unit, ii."zone", ii.dispatch_time, ii.clear_time, ii.inc_date,
(select count(*) 
from inc i 
where i.dispatch_time > ii.dispatch_time
and i.dispatch_time < ii.clear_time
and i.inc_date = ii.inc_date
)
from inc ii