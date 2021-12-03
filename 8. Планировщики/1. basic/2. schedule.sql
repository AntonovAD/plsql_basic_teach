/*
 SCHEDULER
 */



grant create job to student;


--создание задачи
begin

    sys.dbms_scheduler.create_job(

        --имя будущего создаваемого обьекта "схема.имя"
        --нейминг job_ИМЯ
        job_name        => 'student.job_test',

        --дата старта задачи
        --TIMESTAMP WITH TIME ZONE
        start_date      => to_timestamp_tz('2021/12/01 14:00:00.000000 +07:00','yyyy/mm/dd hh24:mi:ss.ff tzh:tzm'),

        --интервал повторения задачи
        --"YEARLY" | "MONTHLY" | "WEEKLY" | "DAILY" | "HOURLY" | "MINUTELY" | "SECONDLY"
        --настраивать можно гораздо тоньше
        --вплоть до конкретных дней в году и тд
        repeat_interval => 'FREQ=SECONDLY;INTERVAL=3;',

        --дата конца задачи
        --null = бесконечно
        end_date        => null,

        --класс задачи
        --"DEFAULT_JOB_CLASS" | "HIGH" | "MEDIUM" | "LOW"
        --влияет на потребление ресурсов, уровень и кол-во логов
        --можно создавать свои классы задач
        job_class       => 'DEFAULT_JOB_CLASS',

        --тип задачи
        --"PLSQL_BLOCK" | "STORED_PROCEDURE" | "EXECUTABLE" | "CHAIN" | "EXTERNAL_SCRIPT" | "SQL_SCRIPT" | "BACKUP_SCRIPT"
        job_type        => 'PLSQL_BLOCK',

        --основная часть задачи
        --что непосредственно делать?
        --нейминг job_ИМЯ_action
        job_action      => 'begin student.job_test_action; end;',

        --свободный комменатрий
        comments        => 'Тестовая задача'

    );

    --можно ли перезапустить задачу
    sys.dbms_scheduler.set_attribute(
        name      => 'student.job_test',
        attribute => 'RESTARTABLE',
        value     => false
    );

    --перезапускать ли задачу при остановке БД
    sys.dbms_scheduler.set_attribute(
        name      => 'student.job_test',
        attribute => 'RESTART_ON_RECOVERY',
        value     => false
    );

    --перезапускать ли задачу при ошибке программы
    sys.dbms_scheduler.set_attribute(
        name      => 'student.job_test',
        attribute => 'RESTART_ON_FAILURE',
        value     => false
    );

    --максимальное количество сбоев,
    --допускаемых до того,
    --как задание будет помечено как "с ошибкой"
    sys.dbms_scheduler.set_attribute_null(
        name      => 'student.job_test',
        attribute => 'MAX_FAILURES'
    );

    --максимальное количество запусков до того,
    --как задание будет помечено как "завершенное"
    sys.dbms_scheduler.set_attribute_null(
        name      => 'student.job_test',
        attribute => 'MAX_RUNS'
    );

    --уровень логирования, поверх классового
    sys.dbms_scheduler.set_attribute(
        name      => 'student.job_test',
        attribute => 'LOGGING_LEVEL',
        value     => sys.dbms_scheduler.logging_full
    );

    --приоритет задачи
    sys.dbms_scheduler.set_attribute(
        name      => 'student.job_test',
        attribute => 'JOB_PRIORITY',
        value     => 3
    );

    --максимальное время задержки между запланированным
    --и фактическим запуском задания
    --до отмены выполнения задания
    sys.dbms_scheduler.set_attribute_null(
        name      => 'student.job_test',
        attribute => 'SCHEDULE_LIMIT'
    );

    --удалять ли задачу после выполнения
    sys.dbms_scheduler.set_attribute(
        name      => 'student.job_test',
        attribute => 'AUTO_DROP',
        value     => false
    );

    --будет логироваться
    --консольный вывод задачи
    sys.dbms_scheduler.set_attribute(
        name      => 'student.job_test',
        attribute => 'STORE_OUTPUT',
        value     => true
    );

end;
/



--просмотр списка задач вида SCHEDULE
select * from user_scheduler_jobs;

--просмотр логов
select * from user_scheduler_job_log;



--запуск задачи
begin
    sys.dbms_scheduler.enable(
        name      => 'student.job_test'
    );
end;
/



--остановка задачи
begin
    sys.dbms_scheduler.disable(
        name      => 'student.job_test'
    );
end;
/



--удаление задачи
begin
    sys.dbms_scheduler.drop_job(
        job_name      => 'student.job_test'
    );
end;
/
