with tot_time as (
	select u.inc_num, unit, clear_time - onscene_time "tot_time"
	from cad u 
	where unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and onscene_time is not null
	and clear_time is not null
),
pos_time as (
	select unit, case when tot_time < interval '00:00:00' then tot_time + interval '24 hours' else tot_time end "pos"
	from tot_time
)
select unit, date_trunc('second',avg(pos)) "avg_time_on_scene"
from pos_time
where pos < '24:00:00'::interval
group by unit
order by unit 