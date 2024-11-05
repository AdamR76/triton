select trim(regexp_replace(street_num || ' ' || coalesce(prefix, '') || ' ' || street_name || ' ' || street_type || ' ' || coalesce(street_suffix,''), '\s{2,}', ' ', 'g')) "address", count(*) "total"
from incidents i
inner join district d 
	on d.inc_num = i.inc_num 
group by trim(regexp_replace(street_num || ' ' || coalesce(prefix, '') || ' ' || street_name || ' ' || street_type || ' ' || coalesce(street_suffix,''), '\s{2,}', ' ', 'g'))
order by "total" desc
limit 10