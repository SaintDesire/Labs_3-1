--ex1. ���������� ����� ������ ������� SGA.
    select * from V$SGA;
    select SUM(value) from v$sga;

--ex2. ���������� ������� ������� �������� ����� SGA.
    select * from v$sga_dynamic_components where current_size > 0;

--ex3. ���������� ������� ������� ��� ������� ����.
    select component, granule_size from v$sga_dynamic_components where current_size > 0;

--ex4. ���������� ����� ��������� ��������� ������ � SGA.
    select current_size from v$sga_dynamic_free_memory;

--ex5. ���������� ������������ � ������� ������ ������� SGA.
    SELECT value FROM v$parameter WHERE name = 'sga_target';
    SELECT value FROM v$parameter WHERE name = 'sga_max_size';

--ex6. ���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.
    select component, current_size, min_size, MAX_SIZE from v$sga_dynamic_components
    where component='KEEP buffer cache' or component='DEFAULT buffer cache' or component='RECYCLE buffer cache';

--ex7. �������� �������, ������� ����� ���������� � ��� ���P.
-- ����������������� ������� �������.
    CREATE TABLE TableLab5 (
        id NUMBER,
        name VARCHAR2(50)
    ) storage (buffer_pool keep) tablespace users;

    SELECT segment_name, segment_type, tablespace_name, buffer_pool
    FROM user_segments
    WHERE segment_name = 'TABLELAB5';

    drop table TableLab5;

--ex8. �������� �������, ������� ����� ������������ � ���� DEFAULT.
-- ����������������� ������� �������.
    CREATE TABLE cachedTableLab5 (
      id NUMBER,
      name VARCHAR2(50),
      age NUMBER
    ) CACHE;

    SELECT segment_name, segment_type, tablespace_name, buffer_pool
    FROM user_segments
    WHERE segment_name = 'CACHEDTABLELAB5';

drop table cachedTableLab5;

--ex9. ������� ������ ������ �������� �������.
    --SQL PLUS:
    --show parameter log_buffer;

--ex10. ������� ������ ��������� ������ � ������� ����.
    SELECT POOL, bytes/1024/1024 AS "Free Memory (MB)"
    FROM V$SGASTAT
    WHERE POOL = 'large pool' AND name = 'free memory';

--ex11. ���������� ������ ������� ���������� � ���������
-- (dedicated, shared).
    select username, service_name, server, osuser, machine, program, STATE
    from v$session
    where username is not null;

--ex12. �������� ������ ������ ���������� � ��������� �����
-- ������� ���������.
    SELECT name, description FROM v$bgprocess;

--ex13. �������� ������ ���������� � ��������� ����� ��������� ���������.
    select * from v$process where addr != '00';

--ex14. ����������, ������� ��������� DBWn �������� � ��������� ������.
    select count(*) from v$process where addr!= '00' and pname like 'DBW%';

--ex15. ���������� ������� (����� ����������� ����������).
    select * from v$active_services;
    --select * from v$services;

--ex16. �������� ��������� ��� ��������� �����������.
    select * from v$dispatcher;

--ex17. ������� � ������ Windows-�������� ������,
-- ����������� ������� LISTENER.
    select * from v$services;
    --services.msc->%listener%

--ex18. ����������������� � �������� ���������� ����� LISTENER.ORA.
    --path: WINDOWS.x64...(this is db_home)/network/admin/listener.ora
    --Screen: Screen_1.png

--ex19. ��������� ������� lsnrctl � �������� �� �������� �������.
    --Screen: screen_2
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

--ex20. �������� ������ ����� ��������, ������������� ��������� LISTENER.
    --Screen: Screen_3
    --command: services