alter session set container = KNI_PDB;
show con_name;
-- 1. ������������ ��������� ��������� GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE)
-- ��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), 
-- ���������� �� ������� �������� ����� � ���������. 
set SERVEROUTPUT on;

select * from TEACHER;

DECLARE
  PROCEDURE GET_TEACHERS(PCODE TEACHER.PULPIT%TYPE) IS
  BEGIN
    FOR i IN (SELECT * FROM TEACHER WHERE PULPIT = PCODE) LOOP
      dbms_output.put_line(i.TEACHER_NAME);
    END LOOP;
  END;
BEGIN
  GET_TEACHERS('����');
END;


-- 2. ������������ ��������� ������� GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER
-- ������� ������ �������� ���������� �������������� �� ������� TEACHER, 
-- ���������� �� ������� �������� ����� � ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

DECLARE
  FUNCTION GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE) RETURN NUMBER IS
    num NUMBER;
  BEGIN
    SELECT COUNT(*) INTO num FROM TEACHER WHERE PULPIT = PCODE;
    RETURN num;
  END;
BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('����'));
END;

-- 3. ������������ ���������:
-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- ��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), 
-- ���������� �� ����������, �������� ����� � ���������.

-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- ��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������,
-- �������� ����� ������� � ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

select * from TEACHER;

create or replace procedure GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) is
begin
  for i in (select * from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE))
    loop
      dbms_output.put_line(i.TEACHER_NAME);
    end loop;
end;

begin
  GET_TEACHERS('����');
end;

create or replace procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) is
begin
  for i in (select * from SUBJECT where PULPIT = PCODE)
    loop
      dbms_output.put_line(i.SUBJECT_NAME);
    end loop;
end;

begin
  GET_SUBJECTS('����');
end;

-- 4. ������������ ��������� �������
-- GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)RETURN NUMBER
-- ������� ������ �������� ���������� �������������� �� ������� TEACHER, ����������
-- �� ����������, �������� ����� � ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

select * from TEACHER;

DECLARE
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER IS
    num NUMBER;
  BEGIN
    SELECT COUNT(*) INTO num FROM TEACHER WHERE PULPIT IN (SELECT PULPIT FROM PULPIT WHERE FACULTY = FCODE);
    RETURN num;
  END;
BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('���'));
END;



-- GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 
-- ������� ������ �������� ���������� ��������� �� ������� SUBJECT, ������������ �� ��������, 
-- �������� ����� ������� ���������. 
-- ������������ ��������� ���� � ����������������� ���������� ���������.

select * from SUBJECT;

create or replace function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number
is
  num number;
begin
  select count(*) into num from SUBJECT where PULPIT = PCODE;
  return num;
end;

begin
  dbms_output.put_line(GET_NUM_SUBJECTS('����'));
end;

-- 5. ������������ ����� TEACHERS, ���������� ��������� � �������:
-- GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
-- GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
-- GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER 
-- GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER

create or replace package TEACHERS is
  procedure GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE);
  procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE);
  function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number;
  function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number;
end TEACHERS;

-- 6. ������������ ��������� ���� � ����������������� ���������� �������� � ������� ������ TEACHERS.
create or replace package body TEACHERS is
  procedure GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) is
  begin
    for i in (select * from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE))
      loop
        dbms_output.put_line(i.TEACHER_NAME);
      end loop;
  end;

  procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) is
  begin
    for i in (select * from SUBJECT where PULPIT = PCODE)
      loop
        dbms_output.put_line(i.SUBJECT_NAME);
      end loop;
  end;

  function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number
    is
    num number;
  begin
    select count(*) into num from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE);
    return num;
  end;

  function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number
    is
    num number;
  begin
    select count(*) into num from SUBJECT where PULPIT = PCODE;
    return num;
  end;
end TEACHERS;

begin
dbms_output.put_line('����� (Task6)');
  TEACHERS.GET_TEACHERS('����');
  dbms_output.put_line('========');
  TEACHERS.GET_SUBJECTS('����');
  dbms_output.put_line('========');
  dbms_output.put_line(TEACHERS.GET_NUM_TEACHERS('���'));
  dbms_output.put_line('========');
  dbms_output.put_line(TEACHERS.GET_NUM_SUBJECTS('����'));
end;