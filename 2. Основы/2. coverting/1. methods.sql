declare
    v_number number; --1
    v_string varchar2(100); --2
    v_date date; --3
    v_boolean boolean; --4

    v_mode number := 5;
begin
    /*
    CONVERTING
    */

    --преобразование типов:
    --где это возможно, oracle всегда
    --сделает сам неявное преобразование типов

    --to_number()
    if (v_mode = 1) then

        v_number := '123';
        dbms_output.put_line(v_number);

        v_number := to_number('123');
        dbms_output.put_line(v_number);

        --ORA-06502
        --v_number := 'string';
        --dbms_output.put_line(v_number);

        --ORA-06502
        --v_number := to_number('string');
        --dbms_output.put_line(v_number);
    end if;

    --to_char()
    if (v_mode = 2) then --почему не крашиться когда v_mode = 2 ?

        v_string := to_char(sysdate, 'dd.mm.yyyy hh24:mi');
        dbms_output.put_line(v_string);

        v_string := sysdate;
        dbms_output.put_line(v_string);

        dbms_output.put_line(sysdate);
    end if;

    --to_date()
    if (v_mode = 3) then

        v_date := to_date('15.09.2021 13:30', 'dd.mm.yyyy hh24:mi');
        dbms_output.put_line(v_date);
        dbms_output.put_line(to_char(v_date, 'dd.mm.yyyy hh24:mi'));
    end if;

    --to_bool()
    if (v_mode = 4) then

        --ORA-06550
        --v_boolean := 1;

        --ORA-06550
        --dbms_output.put_line(v_boolean);

        v_boolean := null;
        v_boolean := true;
        v_number := sys.diutil.bool_to_int(v_boolean);
        dbms_output.put_line(v_number);

        v_number := null;
        --ORA-06502
        --dbms_output.put_line(case when v_number is null then 'null' else v_number end);

        dbms_output.put_line(case when v_number is null then 'null' else to_char(v_number) end);

        v_boolean := sys.diutil.int_to_bool(1);
        dbms_output.put_line(case when v_boolean then 'true' else 'false' end);
    end if;

    --concat
    if (v_mode = 5) then

        v_number := 1;
        dbms_output.put_line('v_number='||v_number);

        v_date := sysdate;
        v_string := 'string';
        dbms_output.put_line(
            'v_number='||v_number
            ||'v_date='||v_date
            ||'v_string'||v_string
        );

        dbms_output.put_line(
            'v_number='||v_number||chr(10)
            ||'v_date='||v_date||chr(10)
            ||'v_string'||v_string||chr(10)
        );

        v_string := '1+';
        v_string := concat(v_string, '2=3');
        dbms_output.put_line(v_string);
    end if;
end;
/
