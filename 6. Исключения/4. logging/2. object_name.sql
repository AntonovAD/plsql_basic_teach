
create or replace package student.pkg_fail
as
    procedure fail_method(
        p_value varchar2,
        p_need_handle boolean
    );
end;
/



create or replace package body student.pkg_fail
as
    procedure fail_method(
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

            exception
                when others then

                    student.add_error_log(
                        $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
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
end;
/



declare
    v_value varchar2(100) := 'string';
begin

    student.pkg_fail.fail_method(
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



/**
  $$plsql_unit_owner    хранит название владельца обьекта
  $$plsql_unit          хранит название обьекта

  $$plsql_unit_owner||'.'||$$plsql_unit     получить автоматом название обьекта со схемой
  в анонимном блоке переменные вернут пустоту и вы получите "."

  $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)   получить название для метода в пакете
 */
