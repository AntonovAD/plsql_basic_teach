
/**
  PACKAGE
 */

begin

    --сколько у вас получилось разных функций и процедур с прошлой дз?

    /**
      пакеты помогают группировать логически связанные обьекты:
      функции, процедуры, типы, константы
     */

    /**
      пакет также состоит из спецификации (головы) и тела,
      но только для пакета можно действительно разделить их создание,
      а также разделять это для других внутри него обьектов.
     */

end;
/



create or replace package student.pkg_const
as

    --public interface
    --то что обьявлено в голове видно всем извне и внутри пакета

    --varchar
    c_varchar_constant constant varchar2(20) := 'it_is_constant';

    --number
    c_number_constant constant number := 100;

    --boolean
    c_is_debug constant boolean := true;

    --date (BAD USING, NOT REPEAT)
    c_tomorrow constant date := sysdate + 1;

    --type array (table)
    type t_arr_number is table of number
    index by binary_integer;

    --record
    type t_record is record (
        name varchar2(100),
        value varchar2(100)
    );

    --record array (table)
    type t_arr_record is table of t_record --student.pkg_util.t_record
    index by binary_integer;

    --cursor
    cursor cursor_weak(
        p_id_hospital number default null
    )
    is
    select *
    from student.hospitals h
    where (
        p_id_hospital is not null
        and h.id_hospital = p_id_hospital
    )
    or p_id_hospital is null;
    --слаботипизированный не получится оставить только как спецификацию

    cursor cursor_strong(
        p_id_hospital number default null
    )
    return t_record; --student.pkg_util.t_record

    --named exception
    --подробнее на лекции 6. Обработка исключений
    e_my_custom_exception exception;

    --function
    function my_function(
        p_parameter number
    )
    return t_record; --student.pkg_util.t_record

    --перегрузка ->:159
    function my_function(
        p_parameter varchar2
    )
    return t_record; --student.pkg_util.t_record

    --procedure
    procedure my_procedure(
        p_parameter number,
        out_parameter out t_record --student.pkg_util.t_record
    );

    /**
      можно создавать только голову.
      это может быть применимо в двух случаях:
      1. когда вы должны уже выдать интерфейсы для других своих обьектов
      или для другого разработчика чтобы он мог пользоваться
      2. (чаще всего) когда вам нужен пакет констант
     */

end;
/

create or replace package body student.pkg_const
as

    --public interface implementation + private interface
    --то что обьявлено только в теле видно только в теле (приватные поля и методы)

    cursor cursor_strong(
        p_id_hospital number default null
    )
    return t_record
    is
    select h.name, h.id_hospital
    from student.hospitals h
    where (
        p_id_hospital is not null
        and h.id_hospital = p_id_hospital
    )
    or p_id_hospital is null;

    function my_function(
        p_parameter number
    )
    return t_record
    as
    begin
        return null; --code
    end;

    function my_function(
        p_parameter varchar2
    )
    return t_record
    as
    begin
        return null; --code
    end;

    procedure my_procedure(
        p_parameter number,
        out_parameter out t_record
    )
    as
    begin
        null; --code
    end;

end;
/

create function student.overload(p number) return number as begin return null; end;
create function student.overload(p varchar2) return number as begin return null; end;
