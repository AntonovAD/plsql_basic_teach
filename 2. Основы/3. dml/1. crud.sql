begin
    --DDL
    /*
    Data
    Definition
    Language
    */

    --DML
    /*
    Data
    Manipulate
    Language
    */

    insert into student.hospitals(name, id_town)
    values ('name', 1);

    update student.hospitals h
    set h.id_town = 2
    where h.name = 'name';

    delete from student.hospitals h
    where h.name = 'name';

    merge into student.hospitals a
    using (
        select 1 as id_hospital from dual
    ) b
    on (
        a.id_hospital = b.id_hospital
    )
    when not matched then
        insert (name, id_town)
        values ('name', 1)
    when matched then
        update
        set a.id_town = 2
    ;

    --ddl
    truncate table student.hospitals;

    --динамический sql
    execute immediate 'truncate table student.hospitals';
end;
/
