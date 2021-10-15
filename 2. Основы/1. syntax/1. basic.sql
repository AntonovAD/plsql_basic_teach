create type student.variable_type as object (
    field number
);

--структура pl/sql кода

--блок обьявления переменных
--(необязательный)
declare
    v_variable variable_type := 'init_value';
    c_constant variable_type := 1;
    p_parameter variable_type := null; --default null
    out_parameter variable_type := sysdate;

--основной блок
--(обязательный)
begin
    --code
    null; --блок не может не содержать код

--блок перехвата исключений
--(необязательный)
exception --подробнее на лекции 6. Обработка исключений
    when error_type then
        --pl/sql code

--закрывающая конструкция
--основного блока
end;
/
