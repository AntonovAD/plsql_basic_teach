create or replace package student.pkg_error
as
    c_app_exception exception;

    procedure raise(
        p_message varchar2
    );

    function get_message(
        p_format_error_stack varchar2
    )
    return varchar2;
end;
/

create or replace package body student.pkg_error
as
    c_error_code constant integer := -20000;

    procedure raise(
        p_message varchar2
    )
    as
    begin
        raise_application_error(c_error_code, p_message);
    exception when others then raise c_app_exception;
    end;

    function get_message(
        p_format_error_stack varchar2
    )
    return varchar2
    as
    begin
        for i in (
            select
                regexp_substr (
                    p_format_error_stack, --строка для поиска
                    '[^('||chr(13)||chr(10)||')]+', --маска регулярного выражения
                    --такая маска говорит о том, что во вхождение попадает всё,
                    --пока не встретятся символы chr(13) и chr(10)
                    1, --позиция начала в строке
                    level --какое вхождение брать (0 = все вхождения)
                ) as step,
                level
            from dual
            connect by regexp_substr (
                p_format_error_stack,
                '[^('||chr(13)||chr(10)||')]+',
                1,
                level
            ) is not null --условие выхода чтобы преобразованная строка была не пуста
        )
        loop
            if i.level = 3 then
                return replace(i.step, 'ORA'||c_error_code||': ', '');
            end if;
        end loop;

        return p_format_error_stack;
    end;
end;
/



--рекурсивный запрос
select level --текущий уровень рекурсии
from dual
--start with {условие} - указание на корневую строчку
--prior - доступ к предыдущей записи
connect by level <= 3;
