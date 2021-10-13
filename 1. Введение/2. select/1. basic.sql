--могут быть функции
--нельзя результат их юзать в where, надо обернуть
--from несколько
--алиасы

select
    *,
    student.hospitals.*,
    r.*,
    t.name as name,
    r.name as "region_name",
    h.id_hospital as айди_больницы,
    h.name имя

--[bulk collect] into

from student.regions r

join student.towns t
    on r.id_region = t.id_region
join student.hospitals h
    on t.id_town = h.id_town

where r.id_region = 1
    and t.id_town in (2,3) --may be select
    or h.name like '%1%'

order by h.id_hospital desc nulls last

offset 10 rows fetch next 20 rows only;
