/**
  USING

  тесты нужно писать через пакеты
  с определенным синтаксисом
  специфичным только для фраемворка utPLSQL
 */



--нейминг test_имя-тестируемого-обьекта
create or replace package antonov.test_pkg_patient
as
    /*
     нельзя писать комментарии:
     - на той же строке с аннотацией
     - между аннотацией и связанной с ней процедурой
     */


    --%suite
    --пакет относится к тестам

    --%rollback(manual)
    --управление транзакциями вручную

    --%beforeall
    procedure seed_before_all;
    --запуск перед всеми тестами один раз

    --%afterall
    procedure rollback_after_all;
    --запуск после всех тестов один раз

    --%beforeeach
    procedure print_before_each;
    --запуск перед каждым тестом

    --%aftereach
    procedure print_after_each;
    --запуск после каждого теста

    /*
     в любом из before/after тригеров
     можно указать имя другого исполняемого
     обьекта в БД
     */

    --

    --пометка что это тест и его нужно запускать
    --%test(проверка получения по id)
    procedure get_by_id;

    --пометка что успех теста будет сброшенное исключение
    --допускаются именованные ошибки, системные ошибки, ORA-номер ошибок
    --%test(ошибка получения по id)
    --%throws(no_data_found)
    procedure failed_get_by_id;

    --пометка что тест выключен
    --%test(выключенный тест)
    --%disabled
    procedure disabled_test;

    --%test(тест на foreign_key id_gender)
    --%throws(-01400)
    procedure check_patient_id_gender_constraint;

    --%test(тест на foreign_key id_account)
    --%throws(-01400)
    procedure check_patient_id_account_constraint;

    --%test(тест на surname is not null)
    --%throws(-01400)
    procedure check_patient_surname_constraint;

    --

    /*
     процедуры и функции
     без соответствующей анотации
     за тесты не считаются
     */
    procedure usual_procedure;

end;
/

create or replace package body antonov.test_pkg_patient
as
    is_debug boolean := true;

    mock_id_patient number;
    mock_patient_surname varchar2(100);
    mock_patient_name varchar2(100);
    mock_patient_date_of_birth date;
    mock_patient_area number;
    mock_patient_id_gender number;
    mock_patient_id_account number;

    --

    procedure disabled_test
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    end;

    procedure usual_procedure
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    end;

    procedure get_by_id
    as
        v_patient kabenyk_st.patients%rowtype;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_patient := antonov.pkg_patient.get_patient_by_id(mock_id_patient);

        TOOL_UT3.UT.EXPECT(v_patient.id_patient).TO_EQUAL(mock_id_patient);

        --больше методов в TOOL_UT3.UT_EXPECTATION
    end;

    procedure failed_get_by_id
    as
        v_patient kabenyk_st.patients%rowtype;
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        v_patient := antonov.pkg_patient.get_patient_by_id(-1);
    end;

    procedure check_patient_id_gender_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.patients(
            surname,
            name,
            date_of_birth,
            area,
            id_gender,
            id_account
        )
        values (
            mock_patient_surname,
            mock_patient_name,
            mock_patient_date_of_birth,
            mock_patient_area,
            null,
            mock_patient_id_account
        );
    end;

    procedure check_patient_id_account_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.patients(
            surname,
            name,
            date_of_birth,
            area,
            id_gender,
            id_account
        )
        values (
            mock_patient_surname,
            mock_patient_name,
            mock_patient_date_of_birth,
            mock_patient_area,
            mock_patient_id_gender,
            null
        );
    end;

    procedure check_patient_surname_constraint
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        insert into kabenyk_st.patients(
            surname,
            name,
            date_of_birth,
            area,
            id_gender,
            id_account
        )
        values (
            null,
            mock_patient_name,
            mock_patient_date_of_birth,
            mock_patient_area,
            mock_patient_id_gender,
            mock_patient_id_account
        );
    end;

    --

    procedure seed_before_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;

        mock_patient_surname := 'surname';
        mock_patient_name := 'name';
        mock_patient_date_of_birth := add_months(sysdate, -(12*20));
        mock_patient_area := 1;
        mock_patient_id_gender := 1;
        mock_patient_id_account := 1;

        insert into kabenyk_st.patients(
            surname,
            name,
            date_of_birth,
            area,
            id_gender,
            id_account
        )
        values (
            mock_patient_surname,
            mock_patient_name,
            mock_patient_date_of_birth,
            mock_patient_area,
            mock_patient_id_gender,
            mock_patient_id_account
        )
        returning id_patient into mock_id_patient;
    end;

    procedure rollback_after_all
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
        rollback;
    end;

    procedure print_before_each
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    end;

    procedure print_after_each
    as
    begin
        if is_debug then dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2)); end if;
    end;
end;
/
