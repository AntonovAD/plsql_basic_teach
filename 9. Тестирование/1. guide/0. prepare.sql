create or replace package antonov.pkg_ticket
as
    function check_if_already_journal(
        p_id_ticket number,
        p_id_patient number
    )
    return boolean;

    function get_ticket_by_id(
        p_id_ticket number
    )
    return kabenyk_st.tickets%rowtype;

    function write_to_journal(
        p_id_ticket number,
        p_id_patient number
    )
    return kabenyk_st.patients_journals.id_journal%type;
end;
/

create or replace package body antonov.pkg_ticket
as
    function check_if_already_journal(
        p_id_ticket number,
        p_id_patient number
    )
    return boolean
    as
        v_count number;
    begin
        select count(*)
        into v_count
        from kabenyk_st.patients_journals pj
        where pj.id_patient = p_id_patient
          and pj.id_ticket = p_id_ticket
          and pj.id_journal_record_status in (1,2);

        return v_count>0;
    end;

    function get_ticket_by_id(
        p_id_ticket number
    )
    return kabenyk_st.tickets%rowtype
    as
        v_ticket kabenyk_st.tickets%rowtype;
    begin
        select *
        into v_ticket
        from kabenyk_st.tickets t
        where t.id_ticket = p_id_ticket;

        return v_ticket;
    end;

    function write_to_journal(
        p_id_ticket number,
        p_id_patient number
    )
    return kabenyk_st.patients_journals.id_journal%type
    as
        v_id_journal kabenyk_st.patients_journals.id_journal%type;
    begin
        insert into kabenyk_st.patients_journals(
            id_journal_record_status, day_time, id_patient, id_ticket
        )
        values (1, sysdate, p_id_patient, p_id_ticket)
        returning id_journal into v_id_journal;

        commit;

        return v_id_journal;
    end;
end;
/

create or replace package antonov.pkg_patient
as
    function get_patient_by_id(
        p_id_patient number
    )
    return kabenyk_st.patients%rowtype;
end;
/

create or replace package body antonov.pkg_patient
as
    function get_patient_by_id(
        p_id_patient number
    )
    return kabenyk_st.patients%rowtype
    as
        v_patient kabenyk_st.patients%rowtype;
    begin
        select *
        into v_patient
        from kabenyk_st.patients p
        where p.id_patient = p_id_patient;

        return v_patient;
    end;
end;
/

create or replace package antonov.pkg_specialty
as
    function check_if_sex_match(
        p_id_patient number,
        p_id_specialty number
    )
    return boolean;

    function check_if_age_match(
        p_id_patient number,
        p_id_specialty number
    )
    return boolean;

    function get_specialty_from_doctor_specialty(
        p_id_doctor_specialty number
    )
    return kabenyk_st.specializations%rowtype;
end;
/

create or replace package body antonov.pkg_specialty
as
    function check_if_sex_match(
        p_id_patient number,
        p_id_specialty number
    )
    return boolean
    as
        v_count number;
    begin
        select count(*)
        into v_count
        from kabenyk_st.patients p
        join kabenyk_st.gender g
        on p.id_gender = g.id_gender
        join kabenyk_st.specializations s
        on s.id_gender = g.gender
        where p.id_patient = p_id_patient
          and s.id_specialization = p_id_specialty
          and (
            p.id_gender = s.id_gender
            or s.id_gender is null
          );

        return v_count>0;
    end;

    function check_if_age_match(
        p_id_patient number,
        p_id_specialty number
    )
    return boolean
    as
        v_patient kabenyk_st.patients%rowtype;
        v_age number;
        v_count number;
    begin
        v_patient := antonov.pkg_patient.get_patient_by_id(p_id_patient);

        v_age := antonov.calc_age_from_date(v_patient.date_of_birth);

        select count(*)
        into v_count
        from kabenyk_st.specializations s
        where s.id_specialization = p_id_specialty
          and (s.min_age <= v_age or s.min_age is null)
          and (s.max_age >= v_age or s.max_age is null);

        return v_count>0;
    end;

    function get_specialty_from_doctor_specialty(
        p_id_doctor_specialty number
    )
    return kabenyk_st.specializations%rowtype
    as
        v_specialty kabenyk_st.specializations%rowtype;
    begin
        select s.*
        into v_specialty
        from kabenyk_st.specializations s
        join kabenyk_st.doctors_specializations ds
            on ds.id_doctor_specialization = p_id_doctor_specialty
            and ds.id_specialization = s.id_specialization;

        return v_specialty;
    end;
end;
/

create or replace function antonov.calc_age_from_date(
    p_date date
)
return number
as
    v_age number;
begin
    select months_between(sysdate, p_date)/12
    into v_age
    from dual;

    return v_age;
end;
/

create or replace package antonov.pkg_doctor
as
    function get_doctor_by_id(
        p_id_doctor number
    )
    return kabenyk_st.doctors%rowtype;
end;
/

create or replace package body antonov.pkg_doctor
as
    function get_doctor_by_id(
        p_id_doctor number
    )
    return kabenyk_st.doctors%rowtype
    as
        v_doctor kabenyk_st.doctors%rowtype;
    begin
        select *
        into v_doctor
        from kabenyk_st.doctors d
        where d.id_doctor = p_id_doctor
            and d.data_of_record_deletion is null;

        return v_doctor;
    end;
end;
/

create or replace function antonov.accept_ticket_by_rules(
    p_id_ticket number,
    p_id_patient number
)
return varchar2
as
    v_ticket kabenyk_st.tickets%rowtype;
    v_doctor kabenyk_st.doctors%rowtype;
    v_specialty kabenyk_st.specializations%rowtype;
    v_id_journal kabenyk_st.patients_journals.id_journal%type;
    v_message varchar2(100);
begin
    v_ticket := antonov.pkg_ticket.get_ticket_by_id(p_id_ticket);

    v_specialty := antonov.pkg_specialty.get_specialty_from_doctor_specialty(v_ticket.id_doctor_specialization);

    if (
        not antonov.pkg_ticket.check_if_already_journal(
            p_id_ticket => p_id_ticket,
            p_id_patient => p_id_patient
        )
        and antonov.pkg_specialty.check_if_sex_match(
            p_id_patient => p_id_patient,
            p_id_specialty => v_specialty.id_specialization
        )
        and antonov.pkg_specialty.check_if_age_match(
            p_id_patient => p_id_patient,
            p_id_specialty => v_specialty.id_specialization
        )
    ) then
        v_id_journal := antonov.pkg_ticket.write_to_journal(
            p_id_ticket => p_id_ticket,
            p_id_patient => p_id_patient
        );

        v_message := 'Успешная запись';
    else
        v_message := 'Ошибка';
    end if;

    return v_message;
end;
/
