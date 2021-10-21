
--курсорные переменные
declare

    --старый синтаксис через обьявление слабого типа
    type type_ref is ref cursor;
    v_cursor_1 type_ref;

    --новый на основе встроенного типа в oracle
    v_cursor_2 sys_refcursor;

    v_record_1 student.hospitals%rowtype;
    v_record_2 student.regions%rowtype;

begin

    --перезапись в v_cursor_1
    open v_cursor_1 for
    select * from student.hospitals;

    fetch v_cursor_1 into v_record_1;

    dbms_output.put_line(v_record_1.name);

    open v_cursor_1 for
    select * from student.regions;

    fetch v_cursor_1 into v_record_2;

    dbms_output.put_line(v_record_2.name);

    close v_cursor_1;

    --перезапись в v_cursor_2
    open v_cursor_2 for
    select * from student.hospitals;

    fetch v_cursor_2 into v_record_1;

    dbms_output.put_line(v_record_1.name);

    open v_cursor_2 for
    select * from student.regions;

    fetch v_cursor_2 into v_record_2;

    dbms_output.put_line(v_record_2.name);

    close v_cursor_2;

    --цикл по v_cursor_2
    open v_cursor_2 for
    select * from student.hospitals;

    loop
        fetch v_cursor_2 into v_record_1;

        exit when v_cursor_2%notfound;

        dbms_output.put_line (v_record_1.name);
    end loop;

    close v_cursor_2;

end;
/