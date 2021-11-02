
begin

    dbms_output.put_line('student.pkg_const.c_varchar_constant = '||student.pkg_const.c_varchar_constant);

    dbms_output.put_line('student.pkg_const.c_number_constant = '||student.pkg_const.c_number_constant);

    dbms_output.put_line('student.pkg_const.c_is_debug = '||case when student.pkg_const.c_is_debug then 'true' else 'false' end);

    dbms_output.put_line('student.pkg_const.c_tomorrow = '||to_char(student.pkg_const.c_tomorrow, 'dd.mm.yyyy hh24:mi:ss'));

end;
/



declare

    v_arr_number student.pkg_const.t_arr_number;

begin

    v_arr_number(1) := 1;
    v_arr_number(2) := 2;
    v_arr_number(3) := 3;

    for i in v_arr_number.first..v_arr_number.last
    loop
    declare
        v_item number := v_arr_number(i);
    begin

        dbms_output.put_line('v_arr_number('||i||') = '||v_item);

    end;
    end loop;

end;
/



declare

    v_record student.pkg_const.t_record;

    v_arr_record student.pkg_const.t_arr_record;

begin

    --3. Курсоры/2. implicit/1. for i in.sql:104
    --ORA-06550
    --подробнее на лекции 7. Типы и объекты
    v_record := student.pkg_const.t_record(
        'гвозди',
        12
    );
    v_arr_record(1) := v_record;

    dbms_output.put_line(v_record.name||' | '||v_record.value);

end;
/



declare

    v_record student.hospitals%rowtype;

begin

    open student.pkg_const.cursor_weak(2); --null

    loop
        fetch student.pkg_const.cursor_weak into v_record;

        exit when student.pkg_const.cursor_weak%notfound;

        dbms_output.put_line (v_record.name);
    end loop;

    close student.pkg_const.cursor_weak;

end;
/



declare

    v_record student.pkg_const.t_record;

begin

    open student.pkg_const.cursor_strong(2); --null

    loop
        fetch student.pkg_const.cursor_strong into v_record;

        exit when student.pkg_const.cursor_strong%notfound;

        dbms_output.put_line (v_record.name);
    end loop;

    close student.pkg_const.cursor_strong;

end;
/
