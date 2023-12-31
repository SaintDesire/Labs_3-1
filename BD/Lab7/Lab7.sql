-- ��� �������, ������� �� 2-��, ���������� ��������� � ������ ���������� 
-- ������������ XXX (� ������� �������� ����������� ������������ � ��������������) 
-- � ����� PDB.

alter pluggable database KNI_USER_PDB open;
alter session set container = KNI_USER_PDB;
show con_name;

create tablespace TS_KNI_USER
  DATAFILE 'TS_KNI_USER_LAB7_PDB.dbf'
  size 7M
  autoextend ON
  next 5M
  maxsize 20M;

create temporary tablespace TS_KNI_USER_TEMP
  tempfile 'TS_KNI_USER_TEMP_LAB7_PDB.dbf'
  size 5M
  autoextend ON
  next 3M
  maxsize 30M;

select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;
drop tablespace TS_KNI_USER including contents and datafiles;
drop tablespace TS_KNI_USER_TEMP including contents and datafiles;

CREATE PROFILE PF_KNI_USER LIMIT
  FAILED_LOGIN_ATTEMPTS 7
  SESSIONS_PER_USER 3
  PASSWORD_LIFE_TIME 60
  PASSWORD_REUSE_TIME 365
  PASSWORD_LOCK_TIME 1
  CONNECT_TIME 180;

select * from DBA_PROFILES where profile = 'PF_KNI_USER';
drop profile PF_KNI_USER;


CREATE USER KNI_USER identified by 111
  DEFAULT TABLESPACE TS_KNI_USER
  TEMPORARY TABLESPACE TS_KNI_USER_TEMP
  PROFILE PF_KNI_USER
  ACCOUNT UNLOCK;

select username from dba_users where USERNAME like 'KNI_USER';
drop user KNI_USER;

-- 1. ���������� ������� ��������� � ������� ������ ������������ ����������� �����.
GRANT CREATE SESSION TO KNI_USER;
GRANT RESTRICTED SESSION TO KNI_USER;
GRANT CREATE ANY TABLE TO KNI_USER;
GRANT CREATE ANY VIEW TO KNI_USER;
GRANT CREATE SEQUENCE TO KNI_USER;
GRANT UNLIMITED TABLESPACE TO KNI_USER;
GRANT CREATE CLUSTER TO KNI_USER;
GRANT CREATE SYNONYM TO KNI_USER;
GRANT CREATE PUBLIC SYNONYM TO KNI_USER;
GRANT CREATE MATERIALIZED VIEW TO KNI_USER;

select * from USER_SYS_PRIVS where username = 'KNI_USER';



-- 2. �������� ������������������ S1 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 1000; 
-- ���������� 10; 
-- ��� ������������ ��������; 
-- ��� ������������� ��������; 
-- �� �����������; 
-- �������� �� ���������� � ������; 
-- ���������� �������� �� �������������. 
-- �������� ��������� �������� ������������������. �������� ������� �������� ������������������.

create sequence S1
  start with 1000
  increment by 10
  nominvalue
  nomaxvalue
  nocycle
  nocache
  noorder;

select S1.NEXTVAL from DUAL;
select S1.CURRVAL from DUAL;

-- 3. �������� ������������������ S2 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 10; 
-- ���������� 10; 
-- ������������ �������� 100;
-- �� �����������. 
-- �������� ��� �������� ������������������. 
-- ����������� �������� ��������, ��������� �� ������������ ��������.

create sequence S2
  start with 10
  increment by 10
  maxvalue 100
  nocycle;

select S2.NEXTVAL from DUAL;

-- 5. �������� ������������������ S3 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 10; 
-- ���������� -10; 
-- ����������� �������� -100; 
-- �� �����������; 
-- ������������� ���������� ��������. 
-- �������� ��� �������� ������������������. 
-- ����������� �������� ��������, ������ ������������ ��������.

create sequence S3
  start with 10
  increment by -10
  minvalue -100
  maxvalue 100
  nocycle
  order;

select S3.NEXTVAL from DUAL;

-- 6. �������� ������������������ S4 (SEQUENCE), �� ���������� ����������������: 
-- ��������� �������� 1; 
-- ���������� 1; 
-- ����������� �������� 10; 
-- �����������; 
-- ���������� � ������ 5 ��������; 
-- ���������� �������� �� �������������. 
-- ����������������� ����������� ��������� �������� ������������������� S4.

create sequence S4
  start with 1
  increment by 1
  maxvalue 10
  cycle
  cache 5
  noorder;

select S4.NEXTVAL from DUAL;

-- 7. �������� ������ ���� ������������������� � ������� ���� ������, 
-- ���������� ������� �������� ������������ XXX.
SELECT * FROM ALL_SEQUENCES WHERE SEQUENCE_OWNER = 'KNI_USER';
DROP SEQUENCE S1;
DROP SEQUENCE S2;
DROP SEQUENCE S3;
DROP SEQUENCE S4;

-- 8. �������� ������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), 
-- ���������� � ������������� � �������� ���� KEEP. 
-- � ������� ��������� INSERT �������� 7 �����, �������� �������� ��� �������� 
-- ������ ������������� � ������� ������������������� S1, S2, S3, S4.

CREATE TABLE T1 (
  N1 NUMBER(20),
  N2 NUMBER(20),
  N3 NUMBER(20),
  N4 NUMBER(20)
) CACHE STORAGE ( BUFFER_POOL KEEP ) tablespace TS_KNI_USER;


alter sequence s1 restart;

alter sequence s2 restart;

alter sequence s3 restart;

alter sequence s4 restart;
BEGIN
  FOR i IN 1..7 LOOP    
    INSERT INTO T1 VALUES (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
  END LOOP;
END;

SELECT * FROM T1;

DROP TABLE T1;


-- 9. �������� ������� ABC, ������� hash-��� (������ 200) � 
-- ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
CREATE CLUSTER ABC (
  X NUMBER(10),
  V VARCHAR2(12)
) SIZE 200 HASHKEYS 200;

-- 10. �������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), 
-- ������������� �������� ABC, � ����� ��� ���� ������������ �������.
CREATE TABLE A (
  XA NUMBER(10),
  VA VARCHAR2(12),
  Y NUMBER(10)
) CLUSTER ABC(XA, VA);

-- 11. �������� ������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), 
-- ������������� �������� ABC, � ����� ��� ���� ������������ �������.
CREATE TABLE B (
  XB NUMBER(10),
  VB VARCHAR2(12),
  Z NUMBER(10)
) CLUSTER ABC(XB, VB);

INSERT INTO B VALUES (1, '1', 1);

-- 12. �������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), 
-- ������������� �������� ABC, � ����� ��� ���� ������������ �������.
CREATE TABLE C (
  XC NUMBER(10),
  VC VARCHAR2(12),
  W NUMBER(10)
) CLUSTER ABC(XC, VC);

INSERT INTO C VALUES (1, '1', 1);

-- 13. ������� ��������� ������� � ������� � �������������� ������� Oracle.
SELECT TABLE_NAME FROM USER_TABLES;
SELECT CLUSTER_NAME FROM USER_CLUSTERS;

-- 14. �������� ������� ������� ��� ������� XXX.� � ����������������� ��� ����������.
CREATE SYNONYM SC FOR KNI_USER.C;
SELECT * FROM C;
SELECT * FROM SC;
drop synonym SC;

-- 15. �������� ��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.
CREATE PUBLIC SYNONYM SB FOR KNI_USER.B;
SELECT * FROM SB;


-- 16. �������� ��� ������������ ������� A � B (� ��������� � ������� �������), 
-- ��������� �� �������, �������� ������������� V1, 
-- ���������� �� SELECT... FOR A inner join B. 
-- ����������������� ��� �����������������.
CREATE TABLE A16 (
  XA NUMBER(10),
  VA VARCHAR2(12),
  Y NUMBER(10),
  CONSTRAINT PK_A16 PRIMARY KEY (XA)
);

CREATE TABLE B16 (
  XB NUMBER(10),
  VB VARCHAR2(12),
  Z NUMBER(10),
  CONSTRAINT FK_B16 FOREIGN KEY (XB) REFERENCES A16(XA)
);

INSERT INTO A16 VALUES (1, '1', 1);
INSERT INTO B16 VALUES (1, '1', 1);

CREATE VIEW V1 AS
  SELECT * FROM A16
  INNER JOIN B16 ON A16.XA = B16.XB;

SELECT * FROM V1;

-- 17. �� ������ ������ A � B �������� ����������������� ������������� MV, 
-- ������� ����� ������������� ���������� 2 ������. 
-- ����������������� ��� �����������������.
CREATE MATERIALIZED VIEW MV
  REFRESH FORCE ON DEMAND
  next SYSDATE + 2/1440
  as
    select * from A16
    inner join
    B16
    on A16.XA = B16.XB;

drop materialized view MV;

select * from MV;