declare
    v_is_condition boolean;
    v_number number;
    type arr_type is table of number
    index by binary_integer;
    a_array arr_type;
    a_index binary_integer := 1;
    v_cursor sys_refcursor;
begin
    /*
    УСЛОВНЫЕ ОПЕРАТОРЫ
    */

    --if (condition) then
    if (
        v_is_condition
        -- >, <, =
        -- !=, <>
        -- is null, is not null
        and v_is_condition != false
        or v_is_condition is null
    ) then

        null; --code
        dbms_output.put_line('if (condition) then');

    elsif (v_is_condition) then

        null; --code
        dbms_output.put_line('elsif (condition) then');

    else

        null; --code
        dbms_output.put_line('else');

    end if;

    --case - аналог switch
    case
        when v_is_condition then

            null; --code

        when v_is_condition then

            null; --code

        else

            null; --code

    end case;
    --end - контекст sql
    --end case; - контекст pl/sql

    /*
    ПРИСВАИВАНИЕ
    */

    v_number := 123;
    --все переменные мутабельные
    --настоящие константы доступны только в пакетах
    --подробнее на лекции 5. Пакеты

    /*
    ПРОСТЫЕ ЦИКЛЫ
    */

    --while c пост условием
    a_index := a_array.first;
    loop
        exit when a_index = a_array.last;

        null; --code
        dbms_output.put_line('loop exit when');

        a_index := a_array.next(a_index);
    end loop;

    --while c пред условием
    while v_is_condition
    loop

        null; --code
        dbms_output.put_line('while (condition) loop');

    end loop;

    /*
    ЦИКЛЫ ПО КУРСОРАМ
    --подробнее на лекции 3. Курсоры
    */

    --цикл по sys_refcursor
    for i in v_cursor
    loop

        null; --code
        dbms_output.put_line(i.field);

    end loop;

    --цикл по select
    for i in (
        select *
        from student.regions
    )
    loop

        null; --code
        dbms_output.put_line(i.id_region);

    end loop;

    --цикл по числам
    for i in 1..100
    --for i in a_array.first..a_array.last
    loop

        null; --code
        dbms_output.put_line(i);

    end loop;

    --вложеннность, области видимости (declare внутри)

end;
