
--НЕЯВНЫЕ

declare

    cursor cursor_1 is
    select *
    from student.hospitals h;

    v_cursor sys_refcursor;

    type arr_varchar is table of varchar2(100)
    index by binary_integer;
    a_varchar arr_varchar;

    type my_record is record (
        id number,
        value varchar2(100)
    );
    type arr_record is table of my_record
    index by binary_integer;
    a_record arr_record;

begin

    --неявный курсор
    --цикл по select
    dbms_output.put_line('--цикл по select');
    for i in (
        select *
        --select h.id_hospital, h.name
        from student.hospitals h
    )
    loop
    declare

        --нужно ли специально задавать другое имя алиасу "i" ?

        --i будет (всегда разный)%rowtype от select
        v_item student.hospitals%rowtype := i;

    begin

        dbms_output.put_line('----------');
        --ORA-06550
        --dbms_output.put_line(i);

        dbms_output.put_line(i.name);

        dbms_output.put_line(i.id_hospital||i.name);

        dbms_output.put_line(i.id_hospital||', '||i.name);
        dbms_output.put_line('----------');

    end;
    end loop;

    --цикл по cursor

    --ORA-06511
    --open cursor_1;

    dbms_output.put_line('--цикл по cursor');
    for i in cursor_1
    loop
    declare
        v_item student.hospitals%rowtype := i;
    begin

        dbms_output.put_line('----------');
        dbms_output.put_line('i=      '||i.name);
        dbms_output.put_line('v_item= '||v_item.name);
        dbms_output.put_line('----------');

    end;
    end loop;

    a_varchar(1) := '1 row';
    a_varchar(2) := '2 row';
    a_varchar(3) := '3 row';

    --цикл по числам
    --for i in 1..10
    --цикл по массиву
    dbms_output.put_line('--цикл по массиву varchar');
    for i in a_varchar.first..a_varchar.last
    loop
    declare
        v_index number := i;
        v_item varchar2(100) := a_varchar(i); --a_array(v_index)
    begin

        dbms_output.put_line('----------');
        dbms_output.put_line('i=       '||i);
        dbms_output.put_line('v_index= '||v_index);
        dbms_output.put_line('v_item=  '||v_item);
        dbms_output.put_line('----------');

    end;
    end loop;

    --ORA-06550
    --подробнее на лекции 7. Типы и объекты
    --a_record(1) := my_record(1, '1 record');

    a_record(1).id := 1;
    a_record(1).value := '1 record';

    /*select h.id_hospital, h.name
    bulk collect into a_record
    from student.hospitals h;*/

    dbms_output.put_line('--цикл по массиву record');
    for i in a_record.first..a_record.last
    loop
    declare
        v_index number := i;
        v_item my_record := a_record(i);
    begin

        dbms_output.put_line('----------');
        dbms_output.put_line('i=             '||i);
        dbms_output.put_line('v_index=       '||v_index);
        dbms_output.put_line('v_item.value=  '||v_item.value);
        dbms_output.put_line('----------');

    end;
    end loop;

end;