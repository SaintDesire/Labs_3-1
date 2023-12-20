--1
-- ���� ����� ��������� �� ���� C:\WINDOWS.X64_193000_db_home\database
-- �������� ���������� ������������
CREATE TABLESPACE TS_KNI
    DATAFILE 'ts_KNI.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M;

-- ������ ������ � ��������� �������������
SELECT TABLESPACE_NAME, STATUS, CONTENTS, LOGGING FROM SYS.DBA_TABLESPACES;

-- �������� ���������� ������������ � �����
DROP TABLESPACE TS_KNI INCLUDING CONTENTS AND DATAFILES;


--2
create temporary tablespace TS_KNI_TEMP
    tempfile 'ts_KNI_TEMP.dbf'
    size 5M
    autoextend on next 3M
    maxsize 30M;
    
select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;
-- �������� ���������� ������������
CREATE TABLESPACE TS_KNI
    DATAFILE 'ts_KNI.dbf'
    SIZE 7M
    AUTOEXTEND ON NEXT 5M
    MAXSIZE 20M;

-- ������ ������ � ��������� �������������
SELECT TABLESPACE_NAME, STATUS, CONTENTS, LOGGING FROM SYS.DBA_TABLESPACES;

-- �������� ���������� ������������ � �����
DROP TABLESPACE TS_KNI_TEMP INCLUDING CONTENTS AND DATAFILES;


--3
select * from SYS.DBA_TABLESPACES;
select * from SYS.DBA_DATA_FILES;

--4
alter session set "_ORACLE_SCRIPT" = true;

create role RL_KNICORE;
grant
    connect,
    create table,
    create view,
    create procedure,
    drop any table,
    drop any view,
    drop any procedure
to RL_KNICORE;


--5
SELECT * FROM DBA_ROLES WHERE ROLE = 'RL_KNICORE';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RL_KNICORE';

--6
CREATE PROFILE PF_KNICORE LIMIT
    FAILED_LOGIN_ATTEMPTS 7 --����� ������� ����� � �������
    SESSIONS_PER_USER 3 -- ���-�� ������ �� ������������
    PASSWORD_LIFE_TIME 60 -- ����� ����� ������
    PASSWORD_REUSE_TIME 365 -- ����� �� ���������� ������������� ������
    PASSWORD_LOCK_TIME 1 -- ����� ���������� ������
    CONNECT_TIME 180 -- ����� �����������
    IDLE_TIME 30; --����� �������

    DROP PROFILE PF_KNICORE;

--7
SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PF_KNICORE';
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

--8
CREATE USER C##KNICORE
    IDENTIFIED BY 111
    DEFAULT TABLESPACE TS_KNI
    TEMPORARY TABLESPACE TS_KNI_TEMP
    PROFILE PF_KNICORE
    ACCOUNT UNLOCK
    PASSWORD EXPIRE;
    
GRANT
    CREATE SESSION,
    CREATE TABLE,
    CREATE VIEW,
    DROP ANY TABLE,
    DROP ANY VIEW
TO C##KNICORE;

DROP USER C##KNICORE;

--10
CREATE TABLE ANYTABLE (
    ID NUMBER
);

CREATE VIEW ANYVIEW AS SELECT * FROM ANYTABLE;

DROP VIEW ANYVIEW;
DROP TABLE ANYTABLE;

--11
CREATE TABLESPACE KNI_QDATA
    DATAFILE 'KNI_QDATA.dbf'
    SIZE 10M
    OFFLINE;

SELECT TABLESPACE_NAME, STATUS, CONTENTS, LOGGING FROM SYS.DBA_TABLESPACES;

ALTER TABLESPACE KNI_QDATA ONLINE;

ALTER USER C##KNICORE QUOTA 2M ON KNI_QDATA;

DROP TABLESPACE KNI_QDATA INCLUDING CONTENTS;

CONNECT C##KNICORE;
CREATE TABLE TABLETASK11 (
    ID NUMBER,
    NAME VARCHAR(10)
) TABLESPACE KNI_QDATA;

INSERT INTO TABLETASK11 VALUES (1, 'one');
INSERT INTO TABLETASK11 VALUES (2, 'two');
INSERT INTO TABLETASK11 VALUES (3, 'three');

SELECT * FROM TABLETASK11;
DROP TABLE TABLETASK11;