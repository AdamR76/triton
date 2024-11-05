with allcallsinc as (
	select i.inc_num, i.inc_type, c.inc_code / 100 inc_code
	from incidents i 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	inner join district d
		on d.inc_num = i.inc_num
	where i.city ilike '%%vacaville%%' 
	and d.indistrict = 1
),
totalcalls as (
	select count(*) allcalls
	from incidents i
	inner join district d
		on d.inc_num = i.inc_num
	where i.city ilike '%%vacaville%%'
	and d.indistrict = 1
),
grouped as (
	select inc_code, count(inc_code) total
	from allcallsinc
	group by inc_code
)
select (inc_code::text || '00')::int inc_code, round(100.0 * (total/(select allcalls from totalcalls)::float)::numeric,2)::float as perc, total
from grouped
group by inc_code, total