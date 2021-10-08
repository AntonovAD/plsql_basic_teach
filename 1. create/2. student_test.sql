--select from dual
select sysdate from dual;


--output
begin
    --public
    dbms_output.put_line('test output');

    --sys
    sys.dbms_output.put_line('test output');
end;
/


--tables
create table student.test(
    id number
);
insert into student.test(id) values (1);
commit;
alter table student.test
    add name varchar2(100);
select * from student.test;
drop table student.test;

--not owner
--ORA-01031
create table antonov.test(
    id number
);

--view
create view student.v_test as select sysdate as "time" from dual;
select * from student.v_test;

--not available
--ORA-01031
create or replace function student.func
return number
as
begin
    return 1;
end;
/

create user hacker
    identified by hacker
    default tablespace users
    temporary tablespace temp
    profile default
    account unlock;