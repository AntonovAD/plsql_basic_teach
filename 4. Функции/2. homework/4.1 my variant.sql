
create or replace function antonov.check_if_already_journal(
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
/

create or replace function antonov.check_if_sex_match(
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
/

--связана ли функция как-то с пациентом?
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

create or replace function antonov.get_patient_by_id(
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
/

create or replace function antonov.check_if_age_match(
    p_id_patient number,
    p_id_specialty number
)
return boolean
as
    v_patient kabenyk_st.patients%rowtype;
    v_age number;
    v_count number;
begin
    v_patient := antonov.get_patient_by_id(p_id_patient);

    v_age := antonov.calc_age_from_date(v_patient.date_of_birth);

    select count(*)
    into v_count
    from kabenyk_st.specializations s
    where s.id_specialization = p_id_specialty
        and (s.min_age <= v_age or s.min_age is null)
        and (s.max_age >= v_age or s.max_age is null);

    return v_count>0;
end;
/

create or replace function antonov.get_ticket_by_id(
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
/

create or replace function antonov.get_doctor_by_id(
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
/

create or replace function antonov.write_to_journal(
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
/

--вопросы
/**
  использовал ли я курсоры здесь?
  использовал ли я здесь какие-то приемы, о которых не рассказывал на лекциях?
  забыл ли какие-то условия в реализованных проверках?
 */
create or replace function antonov.accept_ticket_by_rules(
    p_id_ticket number,
    p_id_patient number
)
return varchar2 --или что угодно на своё усмотрение: id, row, code, message
as
    v_ticket kabenyk_st.tickets%rowtype;
    v_doctor kabenyk_st.doctors%rowtype;
    v_id_journal kabenyk_st.patients_journals.id_journal%type;
    v_message varchar2(100);
begin
    v_ticket := antonov.get_ticket_by_id(p_id_ticket);

    v_doctor := antonov.get_doctor_by_id(v_ticket.id_doctor);

    --как правильно забирать специальность при много ко многим
    /*declare
        v_ticket kotlyarov_dm.tickets%rowtype;
        v_doctor kotlyarov_dm.doctors%rowtype;
        v_specialty kotlyarov_dm.specialities%rowtype;
    begin
        v_ticket.id_doctor_speciality;
    end;*/

    if (
        not antonov.check_if_already_journal(
            p_id_ticket => p_id_ticket,
            p_id_patient => p_id_patient
        )
        and antonov.check_if_sex_match(
            p_id_patient => p_id_patient,
            p_id_specialty => v_doctor.id_specialty
        )
        and antonov.check_if_age_match(
            p_id_patient => p_id_patient,
            p_id_specialty => v_doctor.id_specialty
        )

        --как правильно делать сборное сообщение
        /*or antonov.check_for_accept(
            p_id_ticket => p_id_ticket,
            p_id_patient => p_id_patient,
            p_id_specialty => v_doctor.id_specialty,
            p_lazy_check => false,
            out_messages => v_message
        )*/
    ) then
        v_id_journal := antonov.write_to_journal(
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

create or replace function antonov.check_for_accept(
    p_id_ticket number,
    p_id_patient number,
    p_id_specialty number,
    p_lazy_check boolean default false,
    out_messages out varchar2 --массив varchar2
)
return boolean
as
    v_result boolean := false;
begin
    if (not antonov.check_if_already_journal(
        p_id_ticket => p_id_ticket,
        p_id_patient => p_id_patient
    )) then
        v_result := true;
    else
        v_result := false;
        out_messages := out_messages||chr(10)
            ||'- пациент уже записан на этот талон';
        if (p_lazy_check) then return v_result; end if;
    end if;

    if (antonov.check_if_sex_match(
        p_id_patient => p_id_patient,
        p_id_specialty => p_id_specialty
    )) then
        v_result := true;
    else
        v_result := false;
        out_messages := out_messages||chr(10)
            ||'- несовпадение пола пациента с полом специальности';
        if (p_lazy_check) then return v_result; end if;
    end if;

    if (antonov.check_if_age_match(
        p_id_patient => p_id_patient,
        p_id_specialty => p_id_specialty
    )) then
        v_result := true;
    else
        v_result := false;
        out_messages := out_messages||chr(10)
            ||'- непопадание по возрасту пациента в возрастной диапазон специальности';
        if (p_lazy_check) then return v_result; end if;
    end if;

    return v_result;
end;
/
