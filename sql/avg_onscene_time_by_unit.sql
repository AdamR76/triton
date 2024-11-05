with tot_time as (
	select u.inc_num, unit, clear_time - onscene_time time_onscene
	from cad u 
	where unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'T74', 'S71')
	and clear_time - onscene_time < '24:00:00'::interval
	and onscene_time is not null
	and clear_time is not null
)
select t.unit, date_trunc('second',avg(time_onscene)) "avg_time_on_scene"
from tot_time t
group by t.unit
order by t.unit