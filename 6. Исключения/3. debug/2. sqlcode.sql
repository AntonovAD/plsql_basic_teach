
create or replace package body student.pkg_error
as
    procedure throw_application_error
    as
    begin
        dbms_standard.raise_application_error(-20000, 'мой текст ошибки'); --keeperrorstack => false
    end;

    procedure throw_pkg_error
    as
    begin
        raise student.pkg_error.e_custom_exception;
    end;
end;
/

--как присвоить своей ошибке ORA-номер, SQLCODE; и зачем?
declare

    e_local_exception exception;
    --от -20999 до -20000
    /*
    с_exception_code number := -20000; --так не работает
    */
    pragma exception_init(e_local_exception, -20000);

    /**
      через pragma указываются директивы для компилятора

      виды директив:

      AUTONOMOUS_TRANSACTION
      — приказывает исполнительному ядру PL/SQL выполнить сохранение или откат любых изменений,
      внесенных в базу данных в текущем блоке, без воздействия на главную или внешнюю транзакцию.

      EXCEPTION_INIT
      — приказывает компилятору связать конкретный номер ошибки с идентификатором,
      объявленным в программе как исключение.
      Идентификатор должен соответствовать правилам объявления исключений.

      RESTRICT_REFERENCES
      — задает для компилятора уровень чистоты программного пакета
      (отсутствия действий, вызывающих побочные эффекты).

      SERIALLY_REUSABLE
      — сообщает исполнительному ядру PL/SQL,
      что данные уровни пакета не должны сохраняться между обращениями к ним.
     */

    procedure fourth
    as
    begin
        --есть синоним в public, можно вызывать без dbms_standard
        dbms_standard.raise_application_error(-20000, 'мой текст ошибки');
    end;

begin

    --будет ORA-номер, SQLCODE, но нет сообщения,
    --это больше не user-defined exception
    --raise e_local_exception;

    --теперь будет и сообщение
    /**
      какие здесь проблемы?:
      1. можно ли использовать переменную для передачи кода? - нет
     */
    --fourth(); --локальная функция

    /**
      какие здесь проблемы?:
      1. в пакете теряется имя функции
      2. ошибки скинутые через dbms_standard.raise_application_error()
      ловятся только через OTHERS
     */
    --student.pkg_error.throw_application_error(); --пакетная функция
    --student.pkg_error.throw_pkg_error(); --пакетная функция

    dbms_output.put_line('SUCCESS COMPLETE!');

exception when others then --student.pkg_error.e_custom_exception -- -20000

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
/