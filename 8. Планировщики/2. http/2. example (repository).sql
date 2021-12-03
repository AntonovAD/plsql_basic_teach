/*
 FETCH USING
 */



--некий репозиторий
create or replace function student.repository(
    --p_parameters...
    out_result out number
)
return clob
as

    --минимум 3 переменные
    v_success boolean;
    v_code number;
    v_clob clob;

begin

    /**
      документация к API
      https://app.swaggerhub.com/apis/AntonovAD/DoctorDB/1.0.0
     */

    --минимум 3 параметра
    v_clob := student.HTTP_FETCH(
        p_url => 'http://virtserver.swaggerhub.com/AntonovAD/DoctorDB/1.0.0/doctors',
        /*p_headers => student.t_arr_fetch_header(
            student.t_fetch_header('Accept', 'application/json; charset=utf-8')
        ),*/
        p_debug => true,
        out_success => v_success,
        out_code => v_code
    );

    --на основе результатов fetch
    --мы отдаем свой какой-то код приложения
    --из своей системы кодов (константы)
    out_result := case when v_success
        then student.pkg_code.c_ok
        else student.pkg_code.c_error
    end;

    --возвращаем сырой clob
    return v_clob;

end;
/



declare

    v_result integer;
    v_clob clob;

begin

    v_clob := student.repository(
        out_result => v_result
    );

end;
/



/*
 ACL - Access Control List
 */



--добавление правила
begin
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => 'virtserver.swaggerhub.com',
        ace => xs$ace_type(
            privilege_list => xs$name_list('connect', 'resolve'),
            principal_name => 'STUDENT',
            principal_type => xs_acl.ptype_db
        )
    );
end;

--удаление правила
begin
    DBMS_NETWORK_ACL_ADMIN.REMOVE_HOST_ACE(
        host => 'virtserver.swaggerhub.com',
        ace  =>  xs$ace_type(
            privilege_list => xs$name_list('connect', 'resolve'),
            principal_name => 'STUDENT',
            principal_type => xs_acl.ptype_db
        )
    );
end;

