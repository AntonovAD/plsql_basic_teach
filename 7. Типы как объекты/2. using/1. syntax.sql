/**
  USING
 */



--объявление и вызов
declare

    v_doctor student.t_doctor;

    v_extended_doctor student.t_extended_doctor;

begin

    -- := null
    dbms_output.put_line(case when v_doctor is null
        then 'v_doctor is null'
        else 'v_doctor not null'
    end);

    -- доступ есть
    dbms_output.put_line(
        'v_doctor.id_doctor : '
        ||nvl(to_char(v_doctor.id_doctor), 'null')
    );

    -- и здесь тоже
    dbms_output.put_line(
        'v_extended_doctor.doctor.id_doctor : '
        ||nvl(to_char(v_extended_doctor.doctor.id_doctor), 'null')
    );

end;
/



--инициализация с данными
declare

    v_doctor student.t_doctor;

    v_extended_doctor student.t_extended_doctor;

begin

    --заполнение строго как в обьявлено при создании типа
    v_doctor := student.t_doctor(
        12, --id_doctor
        3, --id_hospital
        'fname',
        'lname',
        'mname'
    );

    dbms_output.put_line('| v_doctor := ');
    dbms_output.put_line(
        student.to_char_t_doctor(v_doctor)
    );

    --заполнение с вложенными типами
    v_extended_doctor := student.t_extended_doctor(
        v_doctor, --можем и самостоятельно через student.t_doctor()
        null --в праве любое поле заполнить null, даже массив
    );

    dbms_output.put_line(chr(13));
    dbms_output.put_line('| v_extended_doctor := ');
    dbms_output.put_line(
        student.to_char_t_extended_doctor(v_extended_doctor)
    );

end;
/



/**
  большая проблема при пересоздании/обновлении типа
  неименованный вызов здесь узкое место
  как с этим бороться? чуть дальше ->
 */



--объявление и использование массивов
declare

    v_arr_doctor student.t_arr_doctor;

begin

    dbms_output.put_line('-- := null');
    dbms_output.put_line(case when v_arr_doctor is null
        then 'v_arr_doctor is null'
        else 'v_arr_doctor not null'
    end);

    dbms_output.put_line('--доступ по индексу');
    --ORA-06531
    begin dbms_output.put_line(v_arr_doctor(1).id_doctor);
    exception when others then dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('--доступ к встроенным методам');
    dbms_output.put_line('--.first');
    --ORA-06531
    begin dbms_output.put_line(v_arr_doctor.first);
    exception when others then dbms_output.put_line(sqlerrm);
    end;
    dbms_output.put_line('--.count');
    --ORA-06531
    begin dbms_output.put_line(v_arr_doctor.count);
    exception when others then dbms_output.put_line(sqlerrm);
    end;

end;
/



--инициализация с пустым конструктором
declare

    --всегда инициализировать с конструктором по умолчанию
    v_arr_doctor student.t_arr_doctor := student.t_arr_doctor();

begin

    dbms_output.put_line('-- := null');
    dbms_output.put_line(case when v_arr_doctor is null
        then 'v_arr_doctor is null'
        else 'v_arr_doctor not null'
    end);

    dbms_output.put_line('--доступ по индексу');
    --ORA-06533
    begin dbms_output.put_line(v_arr_doctor(1).id_doctor);
    exception when others then dbms_output.put_line(sqlerrm);
    end;

    dbms_output.put_line('--доступ к встроенным методам');
    dbms_output.put_line('--.first');
    begin dbms_output.put_line(nvl(to_char(v_arr_doctor.first), 'null'));
    exception when others then dbms_output.put_line(sqlerrm);
    end;
    dbms_output.put_line('--.count');
    begin dbms_output.put_line(v_arr_doctor.count);
    exception when others then dbms_output.put_line(sqlerrm);
    end;

end;
/



--инициализация с данными
--заполнение массива
--ВРУЧНУЮ
declare

    v_doctor student.t_doctor;

    v_arr_doctor student.t_arr_doctor := student.t_arr_doctor();

begin

    v_doctor := student.generate_t_doctor(1);

    --просто заполнить по индексу нельзя
    --обязательно нужно сначала расширить коллекцию
    --перед очередным заполнением
    v_arr_doctor.extend();
    v_arr_doctor(1) := v_doctor; --отдав переменную
    v_arr_doctor.extend();
    v_arr_doctor(2) := generate_t_doctor(2); --отдав результат функции
    v_arr_doctor.extend();
    v_arr_doctor(3) := student.t_doctor( --заполнив самостоятельно
        3,3,'fname','lname','mname'
    );

    dbms_output.put_line('v_arr_doctor.count = '||v_arr_doctor.count);
    dbms_output.put_line(chr(13));

    --допустимо не использовать отступы
    --если массив все-таки может быть null,
    --то добавить еще проверку is not null
    if /*v_arr_doctor is not null and */v_arr_doctor.count>0 then
    for i in v_arr_doctor.first..v_arr_doctor.last
    loop
    declare
        v_item student.t_doctor := v_arr_doctor(i);
    begin
        dbms_output.put_line(student.to_char_t_doctor(v_item));
    end;
    end loop;
    end if;

end;
/



--заполнение массива
--ЧЕРЕЗ .count
declare

    v_arr_doctor student.t_arr_doctor := student.t_arr_doctor();

begin

    --специально не использую i хотя могу
    --показана польза именно .count
    for i in 1..10
    loop
        v_arr_doctor.extend();
        v_arr_doctor(v_arr_doctor.count) := generate_t_doctor(v_arr_doctor.count);
    end loop;

    dbms_output.put_line('v_arr_doctor.count = '||v_arr_doctor.count);
    dbms_output.put_line(chr(13));

    if v_arr_doctor.count>0 then
    for i in v_arr_doctor.first..v_arr_doctor.last
    loop
    declare
        v_item student.t_doctor := v_arr_doctor(i);
    begin
        dbms_output.put_line(student.to_char_t_doctor(v_item));
    end;
    end loop;
    end if;

end;
/
