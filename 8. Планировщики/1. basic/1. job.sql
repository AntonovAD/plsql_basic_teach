/*
 JOB
 */



grant create job to student;



--создание задачи
--сразу запустит ее
declare

    v_job_id binary_integer;

begin

    DBMS_JOB.SUBMIT(
        job => v_job_id,
        what => 'begin student.job_test_action; end;', --pl/sql
        next_date => sysdate,
        interval => 'sysdate+1/24/60/60'
    );

    dbms_output.put_line('job : '||v_job_id);

    --обратите внимание на коммит
    commit;

end;
/



--просмотр списка задач вида JOB
select * from user_jobs;

--логи пишутся в файл на сервере
select value
from v$parameter
where name = 'background_dump_dest';



--остановка задачи
begin
    DBMS_JOB.BROKEN(
        job => 21,
        broken => true
    );

    commit;
end;
/



--удаление задачи
begin
    DBMS_JOB.REMOVE(
        job => 21
    );

    commit;
end;
/



/**
  автоматически dbms_job создаётся
  для автообновляемых матвью
 */
