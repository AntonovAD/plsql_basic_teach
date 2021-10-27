
/**
  PROCEDURE
 */

create or replace procedure student.print_random_varchar

as

begin

    dbms_output.put_line(dbms_random.string('X', 10));

end;
/



declare

    v_number number;

begin

    student.print_random_varchar;

    student.print_random_varchar();

    --ORA-06550
    --v_number := student.print_random_varchar;
end;
/



create or replace procedure student.insert_random_hospital(

    out_id_hospital out number,
    out_hospital out student.hospitals%rowtype

)

as

    v_id_hospital number;

    v_hospital student.hospitals%rowtype;

begin

    --1
    insert into student.hospitals(name)
    values (dbms_random.string('X', 10))
    returning id_hospital into v_id_hospital;
    --returning id_hospital into out_id_hospital;

    select *
    into v_hospital
    --into out_hospital
    from student.hospitals h
    where h.id_hospital = v_id_hospital;
    --

    --2
    insert into student.hospitals(name)
    values (dbms_random.string('X', 10))
    returning id_hospital, name, id_town into v_hospital;
    --returning id_hospital, name, id_town into out_hospital;
    --

    out_id_hospital := v_id_hospital;
    out_hospital := v_hospital;

end;
/



declare

    v_id_hospital number;

    v_hospital student.hospitals%rowtype;

begin

    --ORA-06550
    --student.insert_random_hospital();


    --передавать все out параметры обязательно
    student.insert_random_hospital(
        v_id_hospital,
        v_hospital
    );

    student.insert_random_hospital(
        out_id_hospital => v_id_hospital,
        out_hospital => v_hospital
    );

    dbms_output.put_line(
        'out_id_hospital => '||v_id_hospital||chr(10)
        ||'out_hospital => '||v_hospital.id_hospital||' | '||v_hospital.name
    );

end;
/




begin

    /**
      параметры

      IN

      OUT

      IN OUT

      где будет от них реальная польза?
     */

end;
/



begin

    /**
      гранты

      какие надо выдавать гранты на использование других схем?
      если функция делает селект в другой схеме на это надо выдавать грант
      именно на селект и тд, всему владельцу функции
     */

end;
/

grant select on antonov.test_table to student;
revoke select on antonov.test_table from student;

--create or replace не трогает выданные на обьект гранты

--если сделать drop а потом create все гранты пропадут