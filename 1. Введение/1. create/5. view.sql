grant
    create view,
    create materialized view
to student;

create or replace view student.v_view as
select * from dual;
--drop view student.v_view;

create or replace force view student.v_view as
select * from dual;

--only create like table
create materialized view student.mv_view
refresh fast start with sysdate
next  sysdate + 1/48
as select count(*) from student.hospitals;
