with fire_inc as (
	select distinct u.inc_num, case when onscene_time - received_time <  interval '00:00:00' then onscene_time - received_time + interval '24 hours' else onscene_time - received_time end total_response, 
	extract('hour' from inc_alarm_date_time)::int as "Hour"
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where onscene_time is not null
	and d.indistrict = 1
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
	order by inc_num, total_response
),
fire as (
	select inc_num, min(total_response) total_response, "Hour" 
	from fire_inc
	group by inc_num, "Hour"
	order by total_response desc
),
fire_count as (
	select "Hour", percentile_cont(0.9) within group (order by total_response) ninety_total_response, count(total_response) total_inc_count
	from fire
	group by "Hour"
	order by "Hour"
)
select * from fire_count
