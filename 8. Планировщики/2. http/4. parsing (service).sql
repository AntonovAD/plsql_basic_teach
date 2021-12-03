/*
 PARSING
 */



--некий сервис
create or replace function student.service(
    --p_parameters...
    out_result out number
)
return student.t_arr_doctor
as

    v_result integer;
    v_clob clob;
    v_response student.t_arr_doctor := student.t_arr_doctor();

begin

    v_clob := student.repository(
        out_result => v_result
    );

    --на основе v_result
    --мы можем что-то делать
    --или не делать

    select student.t_doctor(
        id_doctor => r.id_doctor,
        id_hospital => r.id_hospital,
        lname => r.lname,
        fname => r.fname,
        mname => r.mname
    )
    bulk collect into v_response
    from json_table(v_clob, '$' columns(
        nested path '$[*]' columns(
            --следите за тем чтобы типы и их размерность
            --совпадали с типами в ваших обьектах
            id_doctor number path '$.id_doctor',
            id_hospital number path '$.id_hospital',
            lname varchar2(100) path '$.lname',
            fname varchar2(100) path '$.fname',
            mname varchar2(100) path '$.mname'
    ))) r;

    --phones varchar2 format json path '$.phones'

    --он может измениться по ходу действия этого участка программы
    out_result := v_result;

    --возвращаем обьекты
    return v_response;

end;
/



declare

    v_result integer;
    v_response student.t_arr_doctor := student.t_arr_doctor();

begin

    v_response := student.service(
        out_result => v_result
    );

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
        declare
            v_item student.t_doctor := v_response(i);
        begin
            dbms_output.put_line(student.to_char_t_doctor(v_item));
        end;
    end loop;
    end if;

end;
/
