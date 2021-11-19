
/**
  проблема в том как хранить различную динамическую информацию об ошибке?:
  - плодить колонки неправильно
  - обойтись парочкой колонок не получается
  (информация всегда очень разная и разнится от метода к методу)

  в итоге я пришел к решению что я буду хранить ошибки в виде "nosql"
  то есть будет одна строковая колонка.
  в ней в виде json (можно и xml но json гораздо нагляднее) буду складывать ошибку

  есть большой минус:
  для того чтобы выудить информацию из этой nosql строчки
  нужно использовать спец. функции по "разворачивания" этого nosql
  и только потом накладывать на это какие то условия

  соответственно индексы oracle здесь никак не могут быть задействованы
  так как с каждой строчкой вы будете делать вычисления
  и поэтому для какой то статистики и анализа на большие периоды
  это абсолютно не подходит, будет очень долго грузиться

  плюсы:
  подходит только для коротких промежутков
  и для сиюминутной отладки
 */
truncate table student.error_log;
--drop table student.error_log;
create table student.error_log(
    id_log number generated by default as identity
    (start with 1 maxvalue 9999999999999999999999999999 minvalue 1 nocycle nocache noorder) primary key,

    sh_user varchar2(50) default user,
    sh_dt date default sysdate,
    object_name varchar2(200),
    log_type varchar2(1000),
    params varchar2(4000)
);
/**
  в чем плюс?
  при просмотре в иде
  ширина колонки по умолчанию не очень длинная,
  а высота всегда одна строка

  значит цель именно для поверхностного осмотра разработать такой вид
  чтобы было видно главную информацию.
  если нужно углубится то берем уже в руки инстурменты

  значит на глазах должно быть всегда видно когда ошибка произошла.
  в каком обьекте и какая именно ошибка: короткий код, короткий текст

  пример формирования будет позже
 */



--функция или процедура?
--разработать для неименованного вызова?
create or replace procedure student.add_error_log(
    p_object_name varchar2,
    p_params varchar2,
    p_log_type varchar2 default 'common'
)
as
pragma autonomous_transaction;
begin

    insert into student.error_log(object_name, log_type, params)
    values (p_object_name, p_log_type, p_params);

    commit;
end;
/



create table student.test(
    value number
);


create or replace procedure student.fail_method(
    p_value varchar2,
    p_need_handle boolean
)
as
begin

    --обернуть отдельно exception в if невозможно
    if (p_need_handle) then
    begin
        insert into student.test(value)
        values (p_value);

        insert into student.test(value)
        values (p_value);

    exception
        when others then

            student.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit,
                '{"error":"' || sqlerrm
                ||'","value":"' || p_value
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );

            --от задачи
            --rollback;

    end;
    else
        insert into student.test(value)
        values (p_value);

    end if;

end;
/



--где нужно расставить commit?
--где нужно расставить rollback?
/**
  так как все происходит в рамках транзакции
  после ошибки и ее логирования мы скорее всего сделаем rollback

  а если мы залогируем ошибку и сделаем rollback, ничего не останется

  а если сделаем commit то rollback уже ничего не сделает
 */
declare
    v_value varchar2(100) := 'string';
begin

    --а если два раза?
    student.fail_method(
        p_value => v_value,
        p_need_handle => true
    );

    commit;

exception
    when others then

        student.add_error_log(
            $$plsql_unit_owner||'.'||$$plsql_unit,
            '{"error":"' || sqlerrm
            ||'","value":"' || v_value
            ||'","backtrace":"' || dbms_utility.format_error_backtrace()
            ||'"}'
        );

        --от задачи
        --rollback;

end;
/
