drop user student cascade;

create user student
    identified by student
    default tablespace users
    temporary tablespace temp
    profile default
    account unlock;

grant connect to student;

select privilege
from sys.dba_sys_privs
where grantee = 'STUDENT';

select privilege
from dba_role_privs rp join role_sys_privs rsp on (rp.granted_role = rsp.role)
where rp.grantee = 'ANTONOV'
order by privilege;

alter user student quota 100m on users;

select tablespace_name, username, bytes, max_bytes
from dba_ts_quotas
;

grant
    create table
to student;