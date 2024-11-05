with twenty1 as (
	select unit, count(u.inc_num) "total"
	from cad u 
	where unit != ''
	and extract ('year' from date) = 2021
	and dispatch_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and length(unit) >= 3
	group by unit 
	order by "total" desc
),
twenty2 as (
	select unit, count(u.inc_num) "total"
	from cad u 
	where unit != ''
	and extract ('year' from date) = 2022
	and dispatch_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and length(unit) >= 3
	group by unit 
	order by "total" desc
),
twenty3 as (
	select unit, count(u.inc_num) "total"
	from cad u 
	where unit != ''
	and extract ('year' from date) = 2023
	and dispatch_time is not null
	and unit in ('BC71', 'E71', 'E72', 'E73', 'E74', 'E75', 'E78', 'M71', 'M72', 'M73', 'M74', 'M75', 'M78', 'T74', 'R71','E371', 'E572', 'E373', 'E574', 'E575', 'S72')
	and length(unit) >= 3
	group by unit 
	order by "total" desc
)
select '2021' as year, *
from twenty1
where total > 21
union all
select '2022', *
from twenty2
where total > 21
union all
select '2023',*
from twenty3
where total > 21