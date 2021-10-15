create type student.object_type as object (
    field number
);

select name, value
from v$parameter
where name = 'max_string_size';

declare

    /*
    STRING_TYPES(max_size in BYTE [CHAR])
    */

    var_name char(2000); --standard
    var_name char(32767); --extended

    var_name char;
    var_name char(1 char);

    var_name varchar(4000); --всегда

    var_name varchar2(4000); --standard
    var_name varchar2(32767); --extended

    --varchar
    --делает разницу между пустой строкой и null

    --varchar2
    --не делает разницы между пустой строкой и null
    --превращает и то и то в null

    /*
    NUMERIC_TYPES
    */

    --range of -(10**125) to +(10**125)
    var_name number; --(с плавающей точкой) всегда 21 byte
    var_name number; --default (38,0)
    var_name number(*,2);
    var_name number(3);
    var_name number(4,4);

    --range of (-2**31) to +(2**31)
    var_name integer; --(целое) всегда 4 byte
    var_name integer(38); --на самом деле синоним number(*)
    -- без точности

    --range of (-2**31) to +(2**31)
    var_name binary_integer; --синоним integer

    /*
    LOB_TYPES
    */

    var_name clob; --динамический размер до 4 Gb
    -- но можно и расширить в настройках oracle

    /*
    BOOL_TYPES
    */

    var_name boolean;
    --boolean не поддерживается в SQL запросах (в контексте SQL)
    --при выполнении набора инструкций
    --oracle вынужден переключаться между контекстами
    --SQL и PL/SQL

    /*
    ARRAYS
    */

    type arr_type is table of number
    index by binary_integer;
    var_name arr_type;
    var_name binary_integer := 1; --без разницы
    -- потому что это таблица, а не массив
    -- обращение по индексу через ()

    /*
    DATE_TYPES
    */

    --янв 1 1000 н.э. - дек 31 9999 н.э.

    --день месяц год часы минуты секунды
    var_name date := sysdate;
    --sysdate текущее время

    --день месяц год часы минуты секунды
    --милисекунды часовой пояс
    var_name timestamp := systimestamp;
    --systimestamp текущее время

    --арифметические операции с датами
    --date + number = date
    --date - number = date
    --date – date = number
    --date + number/24 = date (number/24 = 1 час)

    --операции сравнения дат
    --date > date
    --date = date

    --функции для работы с датами
    --between()
    --months_between()
    --add_months()
    --next_day()
    --last_day()

    --функции преобразования дат
    --trunc(date, mask) по умолчанию режет до дня

    /*
    TABLE_ROW/COLUMN_TYPES
    */

    var_name student.regions%rowtype;
    var_name student.regions.id_region%type;

    var_name student.object_type;
    --подробнее на лекции 7. Типы и объекты

begin
    --консольный вывод
    dbms_output.put_line(varchar2);
    --надо еще заранее включить консоль
end;
/
