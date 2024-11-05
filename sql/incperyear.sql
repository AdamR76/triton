with fire as (
	select extract ('year' from inc_alarm_date_time)::int "year", count(*) fireinc
	from incidents i 
	inner join codes c 
		on lower(c.inc_desc) = lower(i.inc_type)
	where c.inc_code::text like '1%%'
	and i.inc_num is not null
	group by year
	order by "year"
),
ems as (
	select extract ('year' from inc_alarm_date_time)::int "year", count(*) emsinc
	from incidents i 
	inner join codes c
		on lower(c.inc_desc) = lower(i.inc_type)  
	where c.inc_code::text like '3%%'
	and i.inc_num is not null 
	group by year
),
other as (
	select extract ('year' from inc_alarm_date_time)::int "year", count(*) otherinc
	from incidents i 
	inner join codes c
		on lower(c.inc_desc) = lower(i.inc_type)  
	where not c.inc_code::text like '1%%'
	and not c.inc_code::text like '3%%'
	and i.inc_num is not null
	group by year
)
select f.year as "Year", f.fireinc "Fire", e.emsinc "EMS", o.otherinc "Other"
from fire f
inner join ems e
	on e.year = f.year
inner join other o
	on o.year = f.year
order by f.year