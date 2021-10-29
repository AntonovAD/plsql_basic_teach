
/**
  FUNCTION
 */

grant create procedure to student;
--procedure
--function
--package



--с параметрами

--create
--create or replace
create or replace function student.get_hospital_by_id (

    p_id_hospital in number

)

return student.hospitals%rowtype

as --is --declare
--здесь допускается использование обоих

    /**
      AS

      create or replace view student.v_view AS

      create type student.object_type AS object

      IS

      type arr_type IS table of number

      type my_record IS record

      cursor cursor_1 IS

      AS/IS

      create or replace function/procedure/package AS/IS
     */

    v_hospital student.hospitals%rowtype;

begin

    select *
    into v_hospital
    from student.hospitals h
    where h.id_hospital = p_id_hospital;

    dbms_output.put_line('in function 1');
    dbms_output.put_line(v_hospital.id_hospital||' | '||v_hospital.name);

    --return в любом месте завершает выполнение функции
    return v_hospital;

end;
/



declare

    v_id_hospital number := 2;

    v_hospital student.hospitals%rowtype;

begin

    --вызов с параметрами можно делать просто передавая аргументы по порядку,
    --они будут адресоваться по порядку так как было обьявлено
    v_hospital := student.get_hospital_by_id(v_id_hospital);

    --именнованый(пацанский) вызов функций/процедур (когда юзать? чуть позже)
    /*v_hospital := student.get_hospital_by_id(
        p_id_hospital => v_id_hospital
    );*/

    --ORA-06550
    --при вызове функции результат обязательно надо куда-то присваивать
    --student.get_hospital_by_id(v_id_hospital);

    dbms_output.put_line('in anonymous block');
    dbms_output.put_line(v_hospital.id_hospital||' | '||v_hospital.name);

end;
/



--без параметров
create or replace function student.get_random_hospital

return student.hospitals%rowtype

as

    v_id_hospital number;

    v_hospital student.hospitals%rowtype;

begin

    select h.id_hospital
    into v_id_hospital
    from (
        select h.id_hospital, rownum
        from (
            select h.id_hospital
            from student.hospitals h
            order by dbms_random.random()
        ) h
        where rownum = 1
    ) h;

    v_hospital := student.get_hospital_by_id(v_id_hospital);

    dbms_output.put_line('in function 2');
    dbms_output.put_line(v_hospital.id_hospital||' | '||v_hospital.name);

    return v_hospital;

end;
/



declare

    v_hospital student.hospitals%rowtype;

    v_id_hospital number;

begin

    --при вызове процедуры/функции если она без параметров можно без скобок
    v_hospital := student.get_random_hospital;

    --но лучше со скобками
    v_hospital := student.get_random_hospital();

    dbms_output.put_line('in anonymous block');
    dbms_output.put_line(v_hospital.id_hospital||' | '||v_hospital.name);

    --если вернуть обьект можно сразу забрать только нужное поле через точку "."
    v_id_hospital := student.get_random_hospital().id_hospital;

    dbms_output.put_line('random: '||v_id_hospital);

end;
/



--drop function student.invalid_function;
create or replace function student.invalid_function(

    --default значение
    p_parameter in number default 10

    /**
      параметры адресуются по порядку так как было обьявлено

      соответственно тогда вы обязаны все default параметры указывать в конце - а это не практично.
      любой параметр может в любой момент стать по дефолту

      рискуете при изменении интерфейсов - а такое случается очень часто
      в скрипте не понятно куда что передается, если смотреть без ide

      чтобы всего это избежать надо использовать именнованый(пацанский) вызов через =>

      можно сделать поблажку разве что для одноагрументовых функций или системных утилит
     */

)
return number
as
begin

    /**
      невалидные функция или обьект всегда создаются
      и будут уже хранится в бд но разваленные,
      т.е на них можно ссылаться, но нельзя вызвать
     */

end;
/



begin

    /**
      иногда когда перекомпилируешь обьекты,
      зависимые от них обьекты могут развалиться даже если ничего не нарушено.
      это не страшно, oracle сам их восстановит при первом к ним обращении
      (но в это первое обращение будет ошибка, потом не будет).
      либо можно вручную такие обьекты перекомпилировать
     */

end;
/


--посмотреть все разваленные обьекты
SELECT owner, object_type, object_name
FROM all_objects
WHERE status = 'INVALID';
