grant
    create sequence,
    create trigger
to student;

--sequence
create sequence student.seq_id_hospital
    minvalue 1
    maxvalue 99999999999999999999999999999999
    start with 1
    increment by 1
    cache 10;
--drop sequence student.seq_id_hospital;

create table student.hospitals(
    id_hospital number default student.seq_id_hospital.nextval primary key,
    name varchar2(100),
    id_town number references student.towns(id_town)
);
--drop table student.hospitals;

--trigger. don't use anywhere
create table student.hospitals(
    id_hospital number primary key,
    name varchar2(100),
    id_town number references student.towns(id_town)
);

create or replace trigger student.bi_hospitals
    before insert on student.hospitals
    for each row
begin
    if :new.id_hospital is null then
        :new.id_hospital := student.seq_id_hospital.nextval;
    end if;
end;
--drop trigger student.bi_hospitals;

--special syntax
create table student.hospitals(
    id_hospital number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    name varchar2(100),
    id_town number references student.towns(id_town)
);
