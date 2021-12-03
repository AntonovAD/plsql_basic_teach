-- noinspection SqlOverloadForFile
/*
 PACKING
 */



--некий контроллер
create or replace function student.controller/*(
    --p_parameters...
)*/
return clob
as

    v_result integer;
    v_response student.t_arr_doctor := student.t_arr_doctor();
    v_return_clob clob;

begin

    v_response := student.service(
        out_result => v_result
    );

    --в идеале это нужно обернуть в так называемые resource
    --чтобы переиспользовать сериализацию
    apex_json.free_output; --пакет apex_json доступен в расширенной версии с инструментарием ORDS
    apex_json.initialize_clob_output();
    apex_json.open_object();
    apex_json.write('code', v_result); --пакуем код логического результата
    apex_json.open_array('response'); --пакуем полезные данные
    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item student.t_doctor := v_response(i);
    begin
        apex_json.open_object();
        --есть небольшая альтернатива - написать курсор с названиями полей
        --и отдать курсор в apex_json.write(v_cursor)
        apex_json.write('id_doctor', v_item.id_doctor);
        apex_json.write('id_hospital', v_item.id_hospital);
        apex_json.write('lname', v_item.lname);
        apex_json.write('fname', v_item.fname);
        apex_json.write('mname', v_item.mname);
        apex_json.close_object();
    end;
    end loop;
    end if;
    apex_json.close_array();
    apex_json.close_object();
    v_return_clob := apex_json.get_clob_output;
    apex_json.free_output;

    return v_return_clob;

end;
/



create or replace function student.controller/*(
    --p_parameters...
)*/
return clob
as

    v_result integer;
    v_response student.t_arr_doctor := student.t_arr_doctor();
    v_json json_object_t := json_object_t();
    v_json_response json_array_t := json_array_t();
    v_return_clob clob;

begin

    v_response := student.service(
        out_result => v_result
    );

    --в идеале это нужно обернуть в так называемые resource
    --чтобы переиспользовать сериализацию
    v_json.put('code', v_result); --пакуем код логического результата

    if v_response.count>0 then
    for i in v_response.first..v_response.last
    loop
    declare
        v_item student.t_doctor := v_response(i);
        v_object json_object_t := json_object_t();
    begin
        v_object.put('id_doctor', v_item.id_doctor);
        v_object.put('id_hospital', v_item.id_hospital);
        v_object.put('lname', v_item.lname);
        v_object.put('fname', v_item.fname);
        v_object.put('mname', v_item.mname);

        v_json_response.append(v_object);
    end;
    end loop;
    end if;

    v_json.put('response', v_json_response); --пакуем полезные данные

    v_return_clob := v_json.to_Clob();

    return v_return_clob;

end;
/



--некий rest handler
declare

    v_clob clob;

begin

    v_clob := student.controller();

    --dbms_output.put_line не умеет выводить clob
    --происходит автокаст,
    --но он работает пока clob по размеру <= varchar2
    dbms_output.put_line(v_clob);

end;
/



/**
  в чем разница?:

  * APEX_JSON - потоковый вывод
  * JSON_ELEMENT_T - пакуется в пямяти

  никаких явных минусов ни у того, ни у другого нет.
  просто раз при установке инструментария ORDS
  они предлагают в комплекте APEX_JSON,
  то его и было решено использовать в рабочем продукте.
  вам можно использовать стандартные инструменты JSON_ELEMENT_T
 */
