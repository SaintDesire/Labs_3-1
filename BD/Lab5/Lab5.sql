-- 1. ���������� ����� ������ ������� SGA.
select sum(value) from v$sga;

-- 2. ���������� ������� ������� �������� ����� SGA.
select * from v$sga;
select sum(min_size), sum(max_size), sum(current_size) from v$sga_dynamic_components;

-- 3. ���������� ������� ������� ��� ������� ����.
select
    component,
    current_size,
    max_size,
    last_oper_mode,
    last_oper_time,
    granule_size,
    current_size/granule_size as Ratio
from v$sga_dynamic_components;

-- 4. ���������� ����� ��������� ��������� ������ � SGA.
select current_size from v$sga_dynamic_free_memory;

-- 5. ���������� ������������ � ������� ������ ������� SGA.
select value from v$parameter where name = 'sga_target';
select value from v$parameter where name = 'sga_max_size';
show parameter sga; -- sqlplus

-- ���� --
select name, value
from v$parameter
where name like 'sga%'
   or name = 'memory_target';

-- 6. ���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.
select 
    component, 
    min_size,
    max_size, 
    current_size 
from v$sga_dynamic_components
where component in ('KEEP buffer cache', 'DEFAULT buffer cache', 'RECYCLE buffer cache');

-- 7. �������� �������, ������� ����� ���������� � ��� ���P.
-- ����������������� ������� �������.
create table KEEP_TABLE (num int) storage (buffer_pool keep) tablespace users;
insert into KEEP_TABLE values (1);
insert into KEEP_TABLE values (25);

select * from KEEP_TABLE;
select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where segment_name like 'KEEP%';

-- 8. �������� �������, ������� ����� ������������ � ���� DEFAULT. 
-- ����������������� ������� �������.
create table DEFAULT_TABLE (num int) storage (buffer_pool default) tablespace users;
insert into DEFAULT_TABLE values (2);
insert into DEFAULT_TABLE values (10);

select * from DEFAULT_TABLE;
select segment_name, segment_type, tablespace_name, buffer_pool
from user_segments where segment_name like 'DEFAULT%';

drop table KEEP_TABLE;
drop table DEFAULT_TABLE;

-- 9. ������� ������ ������ �������� �������.
show parameter log_buffer; -- sqlplus

-- 10. ������� ������ ��������� ������ � ������� ����.
select * from  v$sgastat where pool = 'large pool';

select 
    component, 
    min_size,
    max_size, 
    current_size,
    max_size - current_size as free_space
from v$sga_dynamic_components
where component = 'large pool';

-- 11. ���������� ������ ������� ���������� � ��������� (dedicated, shared).
select 
    username, 
    service_name, 
    server 
from v$session where username is not null;

-- ���� --
select sid, serial#, username, server, program
from v$session
where type != 'BACKGROUND';

-- 12. �������� ������ ������ ���������� � ��������� ����� ������� ���������.
select count(*) from v$bgprocess;
select name, description from v$bgprocess where paddr != hextoraw('00') order by name;

-- 13. �������� ������ ���������� � ��������� ����� ��������� ���������.
select pname, program from v$process where background is null order by pname;

-- 14. ����������, ������� ��������� DBWn �������� � ��������� ������.
select count(*) from v$bgprocess where name like 'DBW%';
select * from v$bgprocess where name like 'DBW%';

-- 15. ���������� ������� (����� ����������� ����������).
select name, network_name, pdb from v$services;

-- 16. �������� ��������� ��� ��������� �����������.
select * from v$dispatcher;
show parameter dispatcher; -- sqlplus

-- 17. ������� � ������ Windows-�������� ������, ����������� ������� LISTENER.
-- OracleOraDB19Home1TNSListener
select * from v$services;
-- services.msc->%listener%

-- 18. ����������������� � �������� ���������� ����� LISTENER.ORA.
-- ��������� �� ���� C:\WINDOWS.X64_193000_db_home\network\admin\listener.ora

-- 19. ��������� ������� lsnrctl � �������� �� �������� �������.
-- � CMD ����� lsnrctl � ��������))))
--commands:
    /*
        1. start - ��������� ��������� ��� ������ Oracle.
        2. servacls - ���������� ������ �������� � �� ������� ��� ����������� ����� ���������.
        3. trace - �������� ��� ��������� ������� ����������� ��� ���������.
        4. show - ���������� ������� ��������� ��������� ��� ���������� � ������������ ��������.
        5. stop - ������������� ��������� ��� ������ Oracle.
        6. version - ���������� ������ ���������.
        7. quit ��� exit - ������� �� lsnrctl.
        8. status - ���������� ������� ������ ���������.
        9. reload - ������������� ������������ ��������� ��� ��� ���������.
        10. services - ���������� ������ ��������� ��������, ������� ����� ���� �������� ����� ���������.
        11. save_config - ��������� ������� ������������ ��������� � ����.
    */

-- 20. �������� ������ ����� ��������, ������������� ��������� LISTENER.
-- � CMD ����� lsnrctl � ����� services