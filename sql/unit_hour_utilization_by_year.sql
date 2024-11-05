with twenty1 as (
	select unit, case when clear_time - dispatch_time <  interval '00:00:00' then clear_time - dispatch_time + interval '24 hours' else clear_time - dispatch_time end all_calls
	from cad u 
	where unit != ''
	and extract ('year' from date) = 2021
	and dispatch_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'M71', 'M72', 'M73', 'M74', 'M75', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	group by unit, clear_time, dispatch_time
),
seconds as (
	select unit, extract(epoch from all_calls) / 60 all_calls
	from twenty1
	group by unit, all_calls
),
perc_time as (
	select unit, round(sum(all_calls / 525600)::numeric,3) as unit_hour
	from seconds
	group by unit
),
twenty2 as (
	select unit, case when clear_time - dispatch_time <  interval '00:00:00' then clear_time - dispatch_time + interval '24 hours' else clear_time - dispatch_time end all_calls
	from cad u 
	where unit != ''
	and extract ('year' from date) = 2022
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'M71', 'M72', 'M73', 'M74', 'M75', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and dispatch_time is not null
	group by unit, clear_time, dispatch_time
),
seconds2 as (
	select unit, extract(epoch from all_calls) / 60 all_calls
	from twenty2
	group by unit, all_calls
),
perc_time2 as (
	select unit, round(sum(all_calls / 525600)::numeric,3) as unit_hour
	from seconds2
	group by unit
),
twenty3 as (
	select unit, case when clear_time - dispatch_time <  interval '00:00:00' then clear_time - dispatch_time + interval '24 hours' else clear_time - dispatch_time end all_calls
	from cad u 
	where unit != ''
	and extract ('year' from date) = 2023
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'M71', 'M72', 'M73', 'M74', 'M75', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and dispatch_time is not null
	group by unit, clear_time, dispatch_time
),
seconds3 as (
	select unit, extract(epoch from all_calls) / 60 all_calls
	from twenty3
	group by unit, all_calls
),
perc_time3 as (
	select unit, round(sum(all_calls / 525600)::numeric,3) as unit_hour
	from seconds3
	group by unit
)
select '2021' as year, *
from perc_time
union all
select '2022', *
from perc_time2
union all
select '2023',*
from perc_time3
;