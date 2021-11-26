/**
  CLASS
 */

--drop type student.t_animal;
create or replace type student.t_animal as object(
    nickname varchar2(100),
    color varchar2(100),

    --статичный метод
    static function class_name
    return varchar2,

    --абстрактный метод
    not instantiable member procedure say,

    --обычный метод
    member procedure renickname( --rename зарезервированное имя
        nickname varchar2
    ),
    member procedure recolor(
        color varchar2
    )
)
--[ NOT ] FINAL - ненаследуемый (default = final)
--[ NOT ] INSTANTIABLE - разрешено создавать экземпляры (default = instantiable)
not final
not instantiable --абстрактный
;

create or replace type body student.t_animal
as
    --приватные поля не поддерживаются,
    --только приватные методы

    static function class_name
    return varchar2
    as
    begin
        return $$plsql_unit_owner||'.'||$$plsql_unit;
    end;

    member procedure renickname(
        nickname varchar2
    )
    as
    begin
        self.nickname := nickname;
    end;

    member procedure recolor(
        color varchar2
    )
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        self.color := color;
    end;
end;
/


--drop type student.t_cat;
create or replace type student.t_cat under student.t_animal(
    --сначала без переопределения PLS-00634
    overriding member procedure say,
    overriding member procedure recolor(
        color varchar2
    )
)
final
instantiable
;

create or replace type body student.t_cat
as
    overriding member procedure say
    as
    begin
        dbms_output.put_line('мяу');
    end;

    overriding member procedure recolor(
        color varchar2
    )
    as
    begin
        dbms_output.put_line($$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2));
        (self as student.t_animal).recolor(color);
    end;
end;



declare

    v_animal student.t_animal;

    v_cat student.t_cat;

begin

    --не ловится так как ошибка компиляции
    /*begin v_animal := student.t_animal('nickname', 'color'); exception when others
    then dbms_output.put_line(sqlerrm); end;*/

    --инициализация экземпляра
    v_cat := student.t_cat('кошка', 'рыжый');

    --вызов статической функции
    dbms_output.put_line(student.t_cat.class_name());

    --обращение к полям экземпляра
    dbms_output.put_line(v_cat.nickname||' говорит: ');
    --обращение к процедурам экземпляра
    v_cat.say();

    --вызов родительских методов
    dbms_output.put_line(v_cat.nickname||' сейчас имеет цвет: '||v_cat.color);
    v_cat.recolor('серый');
    dbms_output.put_line(v_cat.nickname||' теперь имеет цвет: '||v_cat.color);

end;
/
