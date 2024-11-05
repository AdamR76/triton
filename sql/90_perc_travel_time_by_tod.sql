with fire_inc as (
	select distinct u.inc_num, case when  onscene_time - enroute_time <  interval '00:00:00' then onscene_time - enroute_time + interval '24 hours' else onscene_time - enroute_time end travel_time,
	extract('hour' from inc_alarm_date_time)::int as "Hour"
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where onscene_time is not null
	and enroute_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
	and d.indistrict = 1
),
fire as (
	select inc_num, travel_time, "Hour" 
	from fire_inc
	group by inc_num, "Hour", travel_time
	order by travel_time desc
)
select "Hour",percentile_cont(0.9) within group (order by travel_time) ninety_perc_travel, count(inc_num) total_inc_count
from fire
group by "Hour";