create table student.doctors(
    id_doctor number primary key,
    name varchar2(100),
    salary number,
    id_hospital number references student.hospitals(id_hospital)
);
--drop table student.doctors;

insert into student.doctors(id_doctor,name,salary,id_hospital)
values(1, '1', 10000,1);
insert into student.doctors(id_doctor,name,salary,id_hospital)
values(2, '2', 20000,1);
insert into student.doctors(id_doctor,name,salary,id_hospital)
values(3, '3', 30000,2);
insert into student.doctors(id_doctor,name,salary,id_hospital)
values(4, '4', 40000,2);
insert into student.doctors(id_doctor,name,salary,id_hospital)
values(5, '5', 50000,1);

commit;

select
    d.id_hospital,
    --count(*) as "count"
    --sum(*)
    min(salary)
    --max(*)
    --avg(*)
from student.doctors d
--where d.salary >= 20000
group by d.id_hospital
--having min(d.salary) >= 20000;