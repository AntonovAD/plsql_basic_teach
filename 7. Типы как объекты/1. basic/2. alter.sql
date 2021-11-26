/**
  ALTER
 */



--пересоздание
create or replace type student.t_doctor as object(
    id_doctor number,
    fname varchar2(100),
    lname varchar2(100),
    mname varchar2(100),
    id_hospital number
);
--ORA-02303
--непересоздастся если на него ссылаются
--либо пишем alter
--либо пишем drop+create скрипты



--alter
alter type student.t_doctor
drop attribute name;
--ORA-22312
--режим cascade - обновит все зависимые типы
--режим invalidate - пометит все зависимые как разваленные

alter type student.t_doctor
drop attribute name cascade;

alter type student.t_doctor
add attribute fname varchar2(100) cascade;

alter type student.t_doctor
add attribute lname varchar2(100) cascade;

alter type student.t_doctor
add attribute mname varchar2(100) cascade;

/**
  нюанс при просмотре ddl скрипта
  там всё накапливается как есть
  т.е. чтобы увидеть текущую структуру нужно смотреть
  именно в навигатор
 */
