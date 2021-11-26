/**
  TYPE AS OBJECT
 */



--привелегия на создание типов
grant create type to student;



--типы замещающие %rowtype
create or replace type student.t_doctor as object(
    id_doctor number,
    name varchar2(100),
    id_hospital number
);
--нейминг t_...

--массив
create or replace type student.t_arr_doctor as table of student.t_doctor;
--нейминг t_arr_...



--создадим еще типов
create or replace type student.t_doctor_info as object(
    id_doctor_info number,
    id_doctor number,
    education varchar2(500),
    qualification number,
    salary number
);
create or replace type student.t_arr_doctor_info as table of student.t_doctor_info;



--расширение типов
create or replace type student.t_extended_doctor as object(
    doctor student.t_doctor, --использование типа внутри типа
    doctor_info student.t_arr_doctor_info
);
--нейминг t_extended_...
