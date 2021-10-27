
create or replace function student.get_all_hospitals_as_func
--никакой типизации? -да.
--это плохо? -да.
--подробнее на лекции 7. Типы и объекты
return sys_refcursor
as
    v_cursor sys_refcursor;
begin
    open v_cursor for
    select *
    from student.hospitals;

    return v_cursor;
end;
/

declare
    v_cursor sys_refcursor;
    v_record student.hospitals%rowtype;
begin
    v_cursor := student.get_all_hospitals_as_func();

    loop
        fetch v_cursor into v_record;

        exit when v_cursor%notfound;

        dbms_output.put_line (v_record.name);
    end loop;

    close v_cursor;
end;
/



create or replace procedure student.get_all_hospitals_as_proc(
    out_cursor out sys_refcursor
)
as
begin
    open out_cursor for
    select *
    from student.hospitals;
end;
/

declare
    v_cursor sys_refcursor;
    v_record student.hospitals%rowtype;
begin
    student.get_all_hospitals_as_proc(v_cursor);

    loop
        fetch v_cursor into v_record;

        exit when v_cursor%notfound;

        dbms_output.put_line (v_record.name);
    end loop;

    close v_cursor;
end;
/
