create or replace procedure student.third
as
begin

    student.pkg_error.raise('Мой собственный текст ошибки');

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
begin

    student.first();

exception
    when student.pkg_error.c_app_exception then
    declare

        v_error_message varchar2(1000);

    begin

        v_error_message := student.pkg_error.get_message(dbms_utility.format_error_stack());

        dbms_output.put_line('v_error_message');
        dbms_output.put_line(v_error_message);
        dbms_output.put_line(chr(13));

        dbms_output.put_line('sqlerrm');
        dbms_output.put_line(sqlerrm);
        dbms_output.put_line(chr(13));

        dbms_output.put_line('sqlcode');
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(chr(13));

        dbms_output.put_line('dbms_utility.format_error_backtrace()');
        dbms_output.put_line(dbms_utility.format_error_backtrace());
        dbms_output.put_line(chr(13));

        dbms_output.put_line('dbms_utility.format_error_stack()');
        dbms_output.put_line(dbms_utility.format_error_stack());
        dbms_output.put_line(chr(13));

    end;

end;
/