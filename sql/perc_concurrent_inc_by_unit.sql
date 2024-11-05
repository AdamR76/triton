with total as (
	select count(*)
	from cad
	where inc_num is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'T74', 'S71')
	and enroute_time is not null
	and dispatch_time is not null
	and onscene_time is not null
),
distinct_unit as (
	select distinct inc_num, unit
	from cad
	where unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'T74', 'S71')
	and inc_num is not null
	and enroute_time is not null
	and dispatch_time is not null
	and onscene_time is not null
),
unit_inc as (
	select inc_num, count(inc_num) unit_count
	from distinct_unit
	where inc_num is not null
	group by inc_num
)
select distinct unit_count, round(sum(unit_count) / (select * from total), 4)
from unit_inc
group by unit_count;
