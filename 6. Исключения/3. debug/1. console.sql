/**
  DEBUG
 */



create or replace procedure student.third
as
    ex_exception exception;
    v_result number;
begin
    /*dbms_output.put_line('dbms_utility.format_call_stack()');
    dbms_output.put_line(dbms_utility.format_call_stack());
    dbms_output.put_line(chr(13));*/

    --v_result := 1/0;

    raise ex_exception;
end;
/
create or replace procedure student.second
as
begin
    student.third();
end;
/
create or replace procedure student.first
as
begin
    student.second();
end;
/



declare

    ex_exception exception;

begin
    dbms_output.put_line(chr(13));

    --raise ex_exception;
    student.first();

--ошибка попадает в блок не как переменная,
--как достать инфу?
exception when others then --могу ли я указать не OTHERS ?

    --Формулировку ORA-номер
    dbms_output.put_line('sqlerrm');
    dbms_output.put_line(sqlerrm);
    dbms_output.put_line(chr(13));

    --SQLCODE
    dbms_output.put_line('sqlcode');
    dbms_output.put_line(sqlcode);
    dbms_output.put_line(chr(13));

    --ORA-06510: unhandled user-defined exception
    --(необработанное исключение, определенное пользователем)

    --ORA-06512: это общая ошибка Oracle для исключений PL/SQL
    --является частью стека сообщений
    dbms_output.put_line('dbms_utility.format_error_backtrace()');
    dbms_output.put_line(dbms_utility.format_error_backtrace());
    dbms_output.put_line(chr(13));

    dbms_output.put_line('dbms_utility.format_error_stack()');
    dbms_output.put_line(dbms_utility.format_error_stack());
    dbms_output.put_line(chr(13));

end;
/
