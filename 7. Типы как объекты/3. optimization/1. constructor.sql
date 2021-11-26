/**
  CONSTRUCTOR
 */



--добавление собственного конструктора
alter type student.t_doctor
add constructor function t_doctor(
    id_doctor number,
    id_hospital number,
    fname varchar default null,
    lname varchar default null,
    mname varchar default null
) return self as result
cascade;

--но тогда мы обязаны реализовать его в теле
create or replace type body student.t_doctor
as
    constructor function t_doctor(
        id_doctor number,
        id_hospital number,
        fname varchar default null,
        lname varchar default null,
        mname varchar default null
    )
    return self as result
    as
    begin
        self.id_doctor := id_doctor;
        self.id_hospital := id_hospital;
        self.fname := fname;
        self.lname := lname;
        self.mname := mname;
        return;
    end;
end;
/



--инициализация через собственный конструктор
declare

    v_doctor student.t_doctor;

begin

    v_doctor := student.t_doctor(
        id_hospital => 2,
        id_doctor => 1
    );

    dbms_output.put_line(
        student.to_char_t_doctor(v_doctor)
    );

end;
/
