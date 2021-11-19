/**
  PREDEFINED EXCEPTION
 */

begin

    null; --code

exception

    --в oracle предопределены лишь несколько ошибок
    --у каждой предопределенной системой ошибки есть название, её ORA-номер и SQL-код
    --SQL-код не совпадает с ORA-номером только у no_data_found и user-defined exception

    when CASE_NOT_FOUND then null; --ORA-06592
    --Ни один из вариантов в WHEN предложениях CASE оператора не выбран,
    --и ELSE предложения нет

    when CURSOR_ALREADY_OPEN then null; --ORA-06511
    --Попытка открытия курсора, который был открыт ранее

    when INVALID_CURSOR then null; --ORA-01001
    --Попытка выполнить недопустимую операцию курсора,
    --например закрыть неоткрытый курсор

    when VALUE_ERROR then null; --ORA-06502
    --Ошибка связана с преобразованием, усечением
    --или проверкой ограничений числовых или символьных данных.
    --Это общее и очень распространенное исключение.
    --Если подобная ошибка содержится в инструкции SQL или DML,
    --то в блоке PL/SQL инициируется исключение INVALID_NUMBER

    when INVALID_NUMBER then null; --ORA-01722
    --Выполняемая SQL-команда
    --не может преобразовать символьную строку в число.
    --Это исключение отличается от VALUE_ERROR тем,
    --что оно инициируется только из SQL-команд

    when NO_DATA_FOUND then null; --ORA-01403 --SQLCODE +100
    --Оператор SELECT INTO не возвращает строк,
    --или ваша программа ссылается на удаленный элемент во вложенной таблице
    --или на неинициализированный элемент в индексируемой таблице.
    --Агрегатные функции SQL, AVG и SUM и др., всегда возвращают значение или ноль.
    --Таким образом, оператор SELECT INTO, вызывающий агрегатную функцию,
    --никогда не вызывает NO_DATA_FOUND.

    --Ожидается, что оператор FETCH в конечном итоге не вернет никаких строк,
    --поэтому, когда это происходит, исключение не возникает


    when TOO_MANY_ROWS then null; --ORA-01422
    --Оператор SELECT INTO возвращает более одной строки

    when ZERO_DIVIDE then null; --ORA-01476
    --Ваша программа пытается разделить число на ноль

    when ACCESS_INTO_NULL then null; --ORA-06530
    when COLLECTION_IS_NULL then null; --ORA-06531
    when DUP_VAL_ON_INDEX then null; --ORA-00001
    when LOGIN_DENIED then null; --ORA-01017
    when NOT_LOGGED_ON then null; --ORA-01012
    when PROGRAM_ERROR then null; --ORA-06501
    when ROWTYPE_MISMATCH then null; --ORA-06504
    when SELF_IS_NULL then null; --ORA-30625
    when STORAGE_ERROR then null; --ORA-06500
    when SUBSCRIPT_BEYOND_COUNT then null; --ORA-06533
    when SUBSCRIPT_OUTSIDE_LIMIT then null; --ORA-06532
    when SYS_INVALID_ROWID then null; --ORA-01410
    when TIMEOUT_ON_RESOURCE then null; --ORA-00051

    when others then null;
    --Перехват любой ошибки

    /**
      при первом вхождении в when код дальше не пойдет,
      значит others надо ставить в самый конец
     */

end;
/



--пустой селект в sql не выкидывает no_data_found
select h.name
from student.hospitals h
where h.id_hospital = 10;

--но пустой селект в pl/sql вызовет no_data_found
declare
    v_name varchar2(100);
begin
    --ORA-01403
    select h.name
    into v_name
    from student.hospitals h
    where h.id_hospital = 10;
end;
/



--как можно скинуть ошибку даже с агрегирующими функциями?
declare
    v_count number;
    v_number number;
begin
    select
        --success
        count(*)
        --ORA-01403
        --, rownum --любое поле из таблицы (для простоты rownum)
    into
        v_count
        --, v_number
    from student.hospitals h
    where h.id_hospital = 10
    --group by rownum
    ;
end;
/
