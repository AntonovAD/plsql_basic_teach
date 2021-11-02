
create or replace package student.pkg_cache
as

    --функция может быть одновременно и детерминированной,
    --и использующей RESULT_CACHE
    function pass_number(
        i number
    )
    return number
    --для чистоты оставим только RESULT_CACHE
    result_cache;

end;
/

create or replace package body student.pkg_cache
as

    function pass_number(
        i number
    )
    return number
    result_cache
    is
    begin
        dbms_output.put_line ('pass_number executed ('||i||')');
        return i;
    end;

    /**
      как достигается польза?:

      -указывает oracle, что необходимо использовать память в SGA (Shared Global Area)
      для кэширования входных и выходных результатов этой функции

      -таким образом, при вызове функции она будет исполнена лишь в том случае,
      если отсутствует кэшированный результат для данных входных параметров

      -область действия за рамками одного блока PL/SQL или SQL-запроса

      -иначе (при "попадании" в кэш этого набора входных значений)
      результат будет просто получен из кэша и возвращен в вызывающий контекст

      -если функция зависит от (ссылается на) любых таблиц базы данных,
      то при любом commit в эти таблицы закэшированные значения функции будут автоматически удаляться
     */

end;
/



declare

    n number := 0;

begin

    /**
      необходимо отметить, что это лишь верхушка айсберга.
      RESULT_CACHE - это опция заметно "круче" DETERMINISTIC
      и может оказать заметно большее воздействие
      (как положительное, так и отрицательное)
      на производительность системы в целом.

      Если вы хотите использовать RESULT_CACHE,
      то этот вопрос нужно разбирать отдельно, глубже и не на этом курсе
     */

    for i in (
        select student.pkg_cache.pass_number(100)
        from dual
        connect by level <= 6
    )
    loop
        n := n + 1;
    end loop;

    dbms_output.put_line ('all done ' || n);
end;
/

begin
    dbms_output.put_line ('100 - returned ' || student.pkg_cache.pass_number(100));
    dbms_output.put_line ('200 - returned ' || student.pkg_cache.pass_number(200));
    dbms_output.put_line ('300 - returned ' || student.pkg_cache.pass_number(300));
    dbms_output.put_line ('100 - returned ' || student.pkg_cache.pass_number(100));
    dbms_output.put_line ('200 - returned ' || student.pkg_cache.pass_number(200));
    dbms_output.put_line ('300 - returned ' || student.pkg_cache.pass_number(300));

    /**
      Кэш для функций, объявленных с использованием ключевого слова RESULT_CACHE
      сохраняется для различных блоков, сессий,
      даже для различных пользователей.

      Как следствие, использование этой функции
      может повлечь за собой цепную реакцию
      -> положительную или отрицательную
      -> во всей вашей системе.

      Нужно помнить: если неосторожно использовать функции,
      использующие result_cache,
      то можно получить ворох непредусмотренных проблем
     */
end;
/
