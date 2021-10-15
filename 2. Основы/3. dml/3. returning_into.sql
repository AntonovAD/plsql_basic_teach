declare
    v_id_hospital number;
    v_count number;
begin
    --yes
    insert into student.hospitals(id_hospital, name, id_town)
    values (default, 'name', 1) --как забрать id?
    returning id_hospital into v_id_hospital;

    --no
    update student.hospitals h
    set h.id_town = 2
    where h.name = 'name'
    returning id_hospital into v_id_hospital;

    --no
    delete from student.hospitals h
    where h.name = 'name'
    returning id_hospital into v_id_hospital;

    --если очень надо returning массив, делаем for cursor

    --super no
    --merge

    --sql%rowcount
    v_count := sql%rowcount;
end;
/