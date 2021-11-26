/**
  SQL
 */



--запаковка одной строки sql выборки в type
create or replace function student.get_doctor(
    p_id_doctor number
)
return student.t_doctor
as

    v_doctor student.t_doctor;

begin

    select student.t_doctor(
        id_doctor => d.id_doctor,
        lname => d.name,
        fname => d.name,
        mname => d.name,
        id_hospital => d.id_hospital
    )
    into v_doctor
    from student.doctors d
    where d.id_doctor = p_id_doctor
        and d.delete_dt is null;

    return v_doctor;

end;
/



--запаковка массива строк sql выборки в type
create or replace function student.get_doctor_by_lname(
    p_lname varchar2
)
return student.t_arr_doctor
as

    v_arr_doctor student.t_arr_doctor := student.t_arr_doctor();

begin

    select student.t_doctor(
        id_doctor => d.id_doctor,
        lname => d.name,
        fname => d.name,
        mname => d.name,
        id_hospital => d.id_hospital
    )
    bulk collect into v_arr_doctor
    from student.doctors d
    where d.name like p_lname
        and d.delete_dt is null;

    return v_arr_doctor;

end;
/



declare

    v_doctor student.t_doctor;

    v_arr_doctor student.t_arr_doctor := student.t_arr_doctor();

begin

    v_doctor := student.get_doctor(2);

    dbms_output.put_line('| v_doctor := ');
    dbms_output.put_line(
        student.to_char_t_doctor(v_doctor)
    );

    v_arr_doctor := student.get_doctor_by_lname('Васильев');

    dbms_output.put_line(chr(13));
    dbms_output.put_line('v_arr_doctor.count = '||v_arr_doctor.count);

    dbms_output.put_line(chr(13));
    dbms_output.put_line('| like "Васильев" = ');
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



--обьединение массивов
declare

    v_arr_doctor student.t_arr_doctor := student.t_arr_doctor();

    v_arr_doctor_part_1 student.t_arr_doctor := student.t_arr_doctor();

    v_arr_doctor_part_2 student.t_arr_doctor := student.t_arr_doctor();

begin

    v_arr_doctor_part_1 := student.get_doctor_by_lname('Васильев');

    v_arr_doctor_part_2 := student.get_doctor_by_lname('Петров');

    --обьединяемся с первой частью
    v_arr_doctor := v_arr_doctor multiset union v_arr_doctor_part_1;

    --обьединяемся со второй частью
    v_arr_doctor := v_arr_doctor multiset union v_arr_doctor_part_2;

    dbms_output.put_line(chr(13));
    dbms_output.put_line('v_arr_doctor_part_1.count = '||v_arr_doctor_part_1.count);
    dbms_output.put_line(chr(13));
    dbms_output.put_line('v_arr_doctor_part_2.count = '||v_arr_doctor_part_2.count);
    dbms_output.put_line(chr(13));
    dbms_output.put_line('v_arr_doctor.count = '||v_arr_doctor.count);

    dbms_output.put_line(chr(13));
    dbms_output.put_line('| like "Васильев" + "Петров" = ');
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



/**
  если коллекция очень сложная
  то её заполнение можно сделать открыв
  неявный курсор for
  и в цикле loop
  заполнить все нужные обьекты,
  и потом при необходимости
  обьединить коллекции через multiset union
 */
