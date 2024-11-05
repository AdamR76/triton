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
	where inc_code::text like '1%%'
	and onscene_time is not null
	and d.indistrict = 1
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
),
dumb_things_fire as (
	select * 
	from fire_inc
),
med_inc as (
	select u.inc_num, case when onscene_time - received_time <  interval '00:00:00' then onscene_time - received_time + interval '24 hours' else onscene_time - received_time end total_response, 
	extract('hour' from inc_alarm_date_time)::int as "Hour"
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where inc_code::text like '3%%'
	and onscene_time is not null
	and d.indistrict = 1
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
),
dumb_things_med as (
	select * 
	from med_inc
),
other_inc as (
	select u.inc_num, case when onscene_time - received_time <  interval '00:00:00' then onscene_time - received_time + interval '24 hours' else onscene_time - received_time end total_response, 
	extract('hour' from inc_alarm_date_time)::int as "Hour"
	from cad u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where not inc_code::text like '1%%'
	and not inc_code::text like '3%%'
	and onscene_time is not null
	and d.indistrict = 1
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and i.response_mode = 'Code 3'
),
dumb_things_other as (
	select * 
	from other_inc
),
fire_count as (
	select 'fire' call_type, "Hour", date_trunc('second', avg(total_response)) total_response, count(total_response) total_response
	from dumb_things_fire
	group by "Hour"
	order by call_type,"Hour"
),
med_count as (
	select 'medical' call_type, "Hour",date_trunc('second', avg(total_response))  , count(total_response) 
	from dumb_things_med
	group by "Hour"
	order by call_type,"Hour"
),
other_count as (
	select 'other' call_type, "Hour",date_trunc('second', avg(total_response)), count(total_response)
	from dumb_things_other
	group by "Hour"
	order by call_type,"Hour"
)
select * from fire_count
union all
select * from med_count
union all
select * from other_count;
