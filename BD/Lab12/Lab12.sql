-- 1. �������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����.
create table STUDENT
(
  STUDENT      varchar(20) primary key,
  STUDENT_NAME varchar(100) unique,
  PULPIT       char(20),
  foreign key (PULPIT) references PULPIT (PULPIT)
);

-- 2. ��������� ������� �������� (10 ��.).
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S001', '������ ����', '����');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S002', '������ ����', '����');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S003', '������� �������', '������');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S004', '������� �������', '��');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S005', '����� �������', '��');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S006', '�������� �����', '��');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S007', '�������� ������', '��');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S008', '�������� �����', '������');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S009', '������ ���������', '��');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S010', '������� �����', '�����');

select * from STUDENT;
drop table STUDENT;

GRANT CREATE SESSION TO KNI;
GRANT RESTRICTED SESSION TO KNI;
GRANT CREATE ANY TABLE TO KNI;
GRANT CREATE ANY VIEW TO KNI;
GRANT CREATE SEQUENCE TO KNI;
GRANT UNLIMITED TABLESPACE TO KNI;
GRANT CREATE CLUSTER TO KNI;
GRANT CREATE SYNONYM TO KNI;
GRANT CREATE PUBLIC SYNONYM TO KNI;
GRANT CREATE MATERIALIZED VIEW TO KNI;
GRANT CREATE ANY PROCEDURE TO KNI;
GRANT CREATE TYPE TO KNI;
GRANT CREATE TRIGGER TO KNI;


-- 3. �������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
drop trigger STUDENT_TRIGGER_OPERATORS_BEFORE;

create or replace trigger STUDENT_TRIGGER_OPERATORS_BEFORE
  before insert or delete or update
  on STUDENT
begin
  dbms_output.put_line('STUDENT_TRIGGER OPERATORS BEFORE');
end;

INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S011', '������ ������', '����');

delete from STUDENT where STUDENT = 'S011';

-- 4. ���� � ��� ����������� �������� ������ �������� ��������� �� ��������� ������� (DMS_OUTPUT) �� ����� ����������� ������.

-- 5. �������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
drop trigger STUDENT_TRIGGER_ROW_BEFORE;

create or replace trigger STUDENT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on STUDENT
  for each row
begin
  dbms_output.put_line('STUDENT_TRIGGER ROW BEFORE');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;

-- 6. ��������� ��������� INSERTING, UPDATING � DELETING.
drop trigger STUDENT_TRIGGER_ROW_BEFORE;

create or replace trigger STUDENT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on STUDENT
  for each row
begin
  if inserting then
    dbms_output.put_line('STUDENT_TRIGGER ROW INSERTING BEFORE');
  elsif updating then
    dbms_output.put_line('STUDENT_TRIGGER ROW UPDATING BEFORE');
  elsif deleting then
    dbms_output.put_line('STUDENT_TRIGGER ROW DELETING BEFORE');
  end if;
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;

INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S011', '��������� ����������', '����');

delete from STUDENT where STUDENT = 'S011';

-- 7. ������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
drop trigger STUDENT_TRIGGER_OPERATORS_AFTER;

create or replace trigger STUDENT_TRIGGER_OPERATORS_AFTER
  after insert or delete or update
  on STUDENT
begin
  dbms_output.put_line('STUDENT_TRIGGER OPERATORS AFTER');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;

-- 8. ������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
drop trigger STUDENT_TRIGGER_ROW_AFTER;

create or replace trigger STUDENT_TRIGGER_ROW_AFTER
  after insert or delete or update
  on STUDENT
  for each row
begin
  dbms_output.put_line('STUDENT_TRIGGER ROW AFTER');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;

-- 9. �������� ������� � ������ AUDIT. ������� ������ ��������� ����: 
-- OperationDate,
-- OperationType (�������� �������, ���������� � ��������),
-- TriggerName(��� ��������),
-- Data (������ � ���������� ����� �� � ����� ��������).

create table AUDIT_LOG
(
  OperationDate date,
  OperationType varchar(100),
  TriggerName   varchar(100)
);

-- 10. �������� �������� ����� �������, ����� ��� �������������� ��� �������� 
-- � �������� �������� � ������� AUDIT.
drop trigger STUDENT_TRIGGER_OPERATORS_BEFORE;
drop trigger STUDENT_TRIGGER_ROW_BEFORE;
drop trigger STUDENT_TRIGGER_OPERATORS_AFTER;
drop trigger STUDENT_TRIGGER_ROW_AFTER;

create or replace trigger STUDENT_TRIGGER_OPERATORS_BEFORE
  before insert or delete or update
  on STUDENT
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER OPERATORS BEFORE', 'STUDENT_TRIGGER_OPERATORS_BEFORE');
end;

create or replace trigger STUDENT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on STUDENT
  for each row
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER ROW BEFORE', 'STUDENT_TRIGGER_ROW_BEFORE');
end;

create or replace trigger STUDENT_TRIGGER_OPERATORS_AFTER
  after insert or delete or update
  on STUDENT
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER OPERATORS AFTER', 'STUDENT_TRIGGER_OPERATORS_AFTER');
end;

create or replace trigger STUDENT_TRIGGER_ROW_AFTER
  after insert or delete or update
  on STUDENT
  for each row
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER ROW AFTER', 'STUDENT_TRIGGER_ROW_AFTER');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;
select * from AUDIT_LOG;
truncate table AUDIT_LOG;

-- 11. ��������� ��������, ���������� ����������� ������� �� ���������� �����. 
-- ��������, ��������������� �� ������� ��� �������. ��������� ���������.

INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S001', '������ ����', '����');

select TRIGGER_NAME from DBA_TRIGGERS where OWNER = 'KNI';
select * from AUDIT_LOG;

-- 12. ������� (drop) �������� �������. ��������� ���������. 
-- �������� �������, ����������� �������� �������� �������.

drop table STUDENT;

flashback table STUDENT to before drop;

select * from STUDENT;

create or replace trigger BEFORE_DROP
  before drop on KNI.SCHEMA
begin
  if ORA_DICT_OBJ_NAME <> 'STUDENT' then
    return;
  end if;

  raise_application_error(-20001, '������ ������� ������� STUDENT');
end;

-- 13. ������� (drop) ������� AUDIT. 
-- ����������� ��������� ��������� � ������� SQL-DEVELOPER. 
-- ��������� ���������. �������� ��������.

drop table AUDIT_LOG;
flashback table AUDIT_LOG to before drop;
select TRIGGER_NAME, STATUS from USER_TRIGGERS;

-- 14. �������� ������������� ��� �������� ��������. 
-- ������������ INSTEADOF INSERT-�������. 
-- ������� ������ ��������� ������ � �������.
drop trigger STUDENT_VIEW_TRIGGER;

create view STUDENT_VIEW
as
select * from STUDENT;

create or replace trigger STUDENT_VIEW_TRIGGER
  instead of insert on STUDENT_VIEW
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_VIEW_TRIGGER', 'STUDENT_VIEW_TRIGGER');
  insert into STUDENT values (:new.STUDENT, :new.STUDENT_NAME, :new.PULPIT);
end;

INSERT INTO STUDENT_VIEW (STUDENT, STUDENT_NAME, PULPIT) 
VALUES ('S018', '������� ���������', '����');
delete from STUDENT where STUDENT = 'S018';

select * from STUDENT;
select * from AUDIT_LOG;
truncate table AUDIT_LOG;

-- 15. �����������������, � ����� ������� ����������� ��������.