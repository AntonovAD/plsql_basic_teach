/**
  USER-DEFINED EXCEPTION
 */



create or replace package student.pkg_error
as
    --у таких ошибок есть название, ORA-06510, SQLCODE +1

    e_custom_exception exception; --не тип, это уже обьявленный вид ошибки

    procedure throw_application_error;
    procedure throw_pkg_error;
end;
/

declare

    e_local_exception exception;
    v_result number;
    v_method number := 3;

begin

    if (v_method = 1) then
        raise e_local_exception;

    elsif (v_method = 2) then
        raise student.pkg_error.e_custom_exception;

    elsif (v_method = 3) then
        v_result := 1/0;

    end if;

    dbms_output.put_line('SUCCESS COMPLETE!');

exception
    when e_local_exception then
        dbms_output.put_line('e_local_exception');

    when student.pkg_error.e_custom_exception then
        dbms_output.put_line('student.pkg_error.e_custom_exception');

    when others then
        dbms_output.put_line('others');

end;
/
