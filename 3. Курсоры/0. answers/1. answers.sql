--случайные строки
select
    dbms_random.string('U', 10) as "U", --Returning string is in uppercase alpha characters
    dbms_random.string('L', 10) as "L", --Returning string is in lowercase alpha characters
    dbms_random.string('A', 10) as "A", --Returning string is in mixed-case alpha characters
    dbms_random.string('X', 10) as "X", --Returning string is in uppercase alpha-numeric characters
    dbms_random.string('P', 10) as "P"  --Returning string is in any printable characters
from dual;

--случайное значение в диапозоне
select
    a."value",
    round(a."value") as "round", --в большую сторону
    floor(a."value") as "floor()" --в меньшую сторону
from (
    select
        dbms_random.value(10, 20) as "value"
    from dual
) a;

-- elsif
declare
    v_is_condition boolean;
begin
    if (v_is_condition) then
        null; --code
    else
        if (v_is_condition) then
            null; --code
        else
            if (v_is_condition) then
                null; --code
            else
                if (v_is_condition) then
                    null; --code
                end if;
            end if;
        end if;
    end if;
end;
/