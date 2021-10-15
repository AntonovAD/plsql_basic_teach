declare
    v_id_hospital number;

    --спорные штуки
    v_id_hospital_2 student.hospitals.id_hospital%type;
    v_hospital student.hospitals%rowtype;

    --гораздо эффективнее использовать типы (objects)
    --подробнее на лекции 7. Типы и объекты
    type arr_type is table of student.hospitals%rowtype
    index by binary_integer;
    a_hospital arr_type;
begin
    select h.id_hospital
    into v_id_hospital --в контексте pl/sql наличие обязательно
    --в контексте sql отсутствие обязательно
    from student.hospitals h
    where h.id_hospital = 1;

    select h.id_hospital
    into v_id_hospital_2
    from student.hospitals h
    where h.id_hospital = 1;

    select *
    into v_hospital
    from student.hospitals h
    where h.id_hospital = 1;

    select *
    bulk collect into a_hospital
    from student.hospitals h;
end;
/