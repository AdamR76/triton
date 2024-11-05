with fire_inc as (
	select distinct u.inc_num, clear_time - arrival_time time_onscene
	from unit_nfirs u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where inc_code::text like '1%%'
	and arrival_time is not null
	and clear_time is not null
	and clear_time - arrival_time < '24:00:00'::interval
),
distinct_fire as (
	select distinct u.inc_num, unit
	from unit_nfirs u
),
combo_fire as (
	select df.inc_num, f.time_onscene
	from distinct_fire df
	inner join fire_inc f
		on f.inc_num = df.inc_num
),
med_inc as (
	select distinct u.inc_num, clear_time - arrival_time time_onscene
	from unit_nfirs u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where inc_code::text like '3%%'
	and arrival_time is not null
	and clear_time is not null
	and clear_time - arrival_time < '24:00:00'::interval
),
distinct_med as (
	select distinct u.inc_num, unit
	from unit_nfirs u
),
combo_med as (
	select df.inc_num, f.time_onscene
	from distinct_med df
	inner join med_inc f
		on f.inc_num = df.inc_num
),
other_inc as (
	select distinct u.inc_num, clear_time - arrival_time time_onscene
	from unit_nfirs u
	inner join incidents i 
		on i.inc_num = u.inc_num 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where inc_code::text not like '1%%'
	and inc_code::text not like '3%%'
	and arrival_time is not null
	and clear_time is not null
	and clear_time - arrival_time < '24:00:00'::interval
),
distinct_other as (
	select distinct u.inc_num, unit
	from unit_nfirs u
),
combo_other as (
	select df.inc_num, f.time_onscene
	from distinct_other df
	inner join other_inc f
		on f.inc_num = df.inc_num
)
select 'fire' call_type, date_trunc('second', avg(time_onscene)) time_onscene
from combo_fire
union
select 'medical', date_trunc('second', avg(time_onscene))
from combo_med
union
select 'other', date_trunc('second', avg(time_onscene))
from other_inc