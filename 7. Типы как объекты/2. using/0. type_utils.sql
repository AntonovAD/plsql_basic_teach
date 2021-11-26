create or replace function student.indent(n number)
return varchar2
as
    v_indent varchar2(4000);
begin
    for i in 1..n loop
        v_indent := v_indent||'     ';
    end loop;
    return v_indent;
end;
/

create or replace function student.to_char_t_doctor(
    p_doctor student.t_doctor,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return student.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'student.t_doctor('||chr(13)||
        '| '||ind(p_deep_level+1)||'id_doctor   : '||p_doctor.id_doctor||chr(13)||
        '| '||ind(p_deep_level+1)||'id_hospital : '||p_doctor.id_hospital||chr(13)||
        '| '||ind(p_deep_level+1)||'fname       : '||p_doctor.fname||chr(13)||
        '| '||ind(p_deep_level+1)||'lname       : '||p_doctor.lname||chr(13)||
        '| '||ind(p_deep_level+1)||'mname       : '||p_doctor.mname||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;
/

create or replace function student.to_char_t_extended_doctor(
    p_extended_doctor student.t_extended_doctor,
    p_deep_level number default 0
)
return varchar2
as
    function ind(n number) return varchar2 as begin return student.indent(n); end;
begin
    return (
        (case when p_deep_level <> 0 then '' else '| ' end)||'student.t_extended_doctor('||chr(13)||
        '| '||ind(p_deep_level+1)||'doctor      : '||student.to_char_t_doctor(p_extended_doctor.doctor, 1)||chr(13)||
        '| '||ind(p_deep_level+1)||'doctor_info : null'||chr(13)||
        '| '||ind(p_deep_level)||');'
    );
end;
/

create or replace function student.generate_t_doctor(id number)
return student.t_doctor
as
begin
    return student.t_doctor(
        id,id,'fname','lname','mname'
    );
end;
/
