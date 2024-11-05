with fire_inc as (
	select distinct u.inc_num, case when onscene_time - dispatch_time <  interval '00:00:00' then onscene_time - dispatch_time + interval '24 hours' else onscene_time - dispatch_time end response_time
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
	order by inc_num, response_time
),
fire as (
	select inc_num, min(response_time) response_time
	from fire_inc
	group by inc_num
	order by response_time desc
),
med_inc as (
	select u.inc_num, case when onscene_time - dispatch_time <  interval '00:00:00' then onscene_time - dispatch_time + interval '24 hours' else onscene_time - dispatch_time end response_time 
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
	order by inc_num, response_time
),
med as (
	select inc_num, min(response_time) response_time
	from med_inc
	group by inc_num
	order by response_time desc
),
other_inc as (
	select u.inc_num, case when onscene_time - dispatch_time <  interval '00:00:00' then onscene_time - dispatch_time + interval '24 hours' else onscene_time - dispatch_time end response_time
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
	order by inc_num, response_time
),
other as (
	select inc_num, min(response_time) response_time
	from other_inc
	group by inc_num
	order by response_time desc
),
fire_count as (
	select 'fire' call_type, percentile_cont(0.9) within group (order by response_time) response_time, count(response_time) total_inc_count
	from fire
	order by call_type
),
med_count as (
	select 'medical' call_type, percentile_cont(0.9) within group (order by response_time)  , count(response_time) 
	from med
	order by call_type
),
other_count as (
	select 'other' call_type, percentile_cont(0.9) within group (order by response_time), count(response_time)
	from other
	order by call_type
)
select * from fire_count
union all
select * from med_count
union all
select * from other_count;