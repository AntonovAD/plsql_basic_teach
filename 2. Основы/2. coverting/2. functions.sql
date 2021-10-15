select
    lower('UPPER_TEXT') as "lower()",
    upper('lower_text') as "upper()",
    mod(10,3) as "mod()", --остаток от деления
    rownum, --номер строки в конкретной выборке
    rowid, --некий уникальный id строки
    dbms_random.random() as "random()", --рандомное число
    nvl(null, 1) as "nvl()",
    nvl2(41, 'if not null', 'if null') as "nvl2()",
    nvl2(null, 'if not null', 'if null') as "nvl2()",
    coalesce(null, null, null, 10, 2) as "coalesce()",
    nullif(12, 13) as "nullif()",
    nullif(13, 13) as "nullif()"
from dual;