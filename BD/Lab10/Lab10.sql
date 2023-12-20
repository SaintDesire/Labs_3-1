alter pluggable database KNI_PDB open;
alter session set container = KNI_PDB;
show con_name;
-- 1. �������� � ������� TEACHER ��� ������� BIRTHDAY (��������� ����) � SALARY, ��������� �� ����������.
   
ALTER TABLE TEACHER
ADD (BIRTHDAY DATE, SALARY NUMBER);

UPDATE TEACHER
SET BIRTHDAY = TRUNC(SYSDATE) - FLOOR(DBMS_RANDOM.VALUE(365*23, 365*3)),
    SALARY = FLOOR(DBMS_RANDOM.VALUE(30000, 80000));


ALTER TABLE TEACHER
DROP COLUMN BIRTHDAY;

ALTER TABLE TEACHER
DROP COLUMN SALARY;

  
select * from TEACHER;

-- 2. �������� ������ �������������� � ���� ������� �.�.

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


CREATE OR REPLACE FUNCTION GET_FIO(TEACHER_NAME VARCHAR2)
    RETURN VARCHAR2
IS
    FIO VARCHAR2(200);
BEGIN
    FIO := SUBSTR(TEACHER_NAME, 1, INSTR(TEACHER_NAME, ' ') - 1) || ' ' ||
                 SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ') + 1, 1) || '.' ||
                 SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ', 1, 2) + 1, 1) || '.';

    RETURN FIO;
END;

select GET_FIO(TEACHER_NAME), BIRTHDAY
from TEACHER;

-- 3. �������� ������ ��������������, ���������� � �����������.
SELECT TEACHER_NAME, BIRTHDAY FROM TEACHER
WHERE TO_CHAR(BIRTHDAY, 'D') = '1';

-- 4. �������� �������������, � ������� ��������� ������ ��������������, 
-- ������� �������� � ��������� ������.
create view TEACHERS_NEXT_MONTH as
select GET_FIO(TEACHER_NAME) as TEACHER_NAME, -- ���������� ������� � ���
       to_char(BIRTHDAY, 'DD.MM.YYYY')   as BIRTHDAY
from teacher
where to_char(BIRTHDAY, 'MM') = to_char(sysdate, 'MM') + 1;

select * from TEACHERS_NEXT_MONTH;

-- 5. �������� �������������, � ������� ��������� ���������� ��������������, 
-- ������� �������� � ������ ������.
drop table MONTHS;

create table MONTHS
(
  month_name   varchar(20),
  month_number varchar(2)
);


insert into MONTHS (month_name, month_number)
values ('������', '01');
insert into MONTHS (month_name, month_number)
values ('�������', '02');
insert into MONTHS (month_name, month_number)
values ('����', '03');
insert into MONTHS (month_name, month_number)
values ('������', '04');
insert into MONTHS (month_name, month_number)
values ('���', '05');
insert into MONTHS (month_name, month_number)
values ('����', '06');
insert into MONTHS (month_name, month_number)
values ('����', '07');
insert into MONTHS (month_name, month_number)
values ('������', '08');
insert into MONTHS (month_name, month_number)
values ('��������', '09');
insert into MONTHS (month_name, month_number)
values ('�������', '10');
insert into MONTHS (month_name, month_number)
values ('������', '11');
insert into MONTHS (month_name, month_number)
values ('�������', '12');

create view TEACHER_COUNT_BY_MONTH as
select month_name,
       (select count(*) from TEACHER where to_char(birthday, 'MM') = month_number) as count
from MONTHS;

select * from TEACHER_COUNT_BY_MONTH;
select SUM(COUNT) from TEACHER_COUNT_BY_MONTH;
select COUNT(*) from TEACHER;

-- 6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.
declare
  cursor c1 is
    select GET_FIO(TEACHER_NAME) as teacher_name,
           to_char(BIRTHDAY, 'DD.MM.YYYY')   as birthday
    from TEACHER
    where MOD((to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(BIRTHDAY, 'YYYY')) + 1), 5) = 0;
begin
  for i in c1
    loop
      dbms_output.put_line(i.teacher_name || ' ' || i.birthday);
    end loop;
end;

-- 7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����,
-- ������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.
select * from TEACHER;
select * from FACULTY;

DECLARE
  CURSOR c_average_salary IS
    SELECT P.FACULTY, AVG(T.SALARY) AS AVERAGE_SALARY
    FROM TEACHER T
    INNER JOIN PULPIT P ON T.PULPIT = P.PULPIT
    GROUP BY P.FACULTY;

  v_faculty CHAR(20);
  v_average_salary NUMBER; -- ������� �� ������ ����������
  v_count_faculty NUMBER; -- ���-�� �����������
  v_total_average_salary NUMBER := 0;
  v_average_salary_all_faculty NUMBER; -- ������� �� ���� �����������
BEGIN
  OPEN c_average_salary;
  
  DBMS_OUTPUT.PUT_LINE('Average Salary by Faculty:');
  DBMS_OUTPUT.PUT_LINE('-------------------------');
  
  LOOP
    FETCH c_average_salary INTO v_faculty, v_average_salary;
    EXIT WHEN c_average_salary%NOTFOUND;
    
    SELECT COUNT(*) INTO v_count_faculty FROM FACULTY;
    v_total_average_salary := v_total_average_salary + v_average_salary;
    v_average_salary_all_faculty := v_total_average_salary / v_count_faculty;
    
    DBMS_OUTPUT.PUT_LINE('Faculty: ' || v_faculty || ', Average Salary: ' || FLOOR(v_average_salary));
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('-------------------------');
  DBMS_OUTPUT.PUT_LINE('Total: ' || FLOOR(v_total_average_salary));
  DBMS_OUTPUT.PUT_LINE('Total Average Salary: ' || FLOOR(v_average_salary_all_faculty));
  
  CLOSE c_average_salary;
END;

-- 8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���.
-- ����������������� ������ � ���������� ��������. ����������������� � ��������� �������� ����������.

DECLARE
  -- ���������� ���� ������
  TYPE teacher_record IS RECORD (
    teacher_id NUMBER,
    teacher_name VARCHAR2(100),
    department VARCHAR2(50)
  );

  -- ���������� ���������� ���� ������
  TYPE student_record IS RECORD (
    student_id NUMBER,
    student_name VARCHAR2(100),
    major VARCHAR2(50)
  );

  -- ���������� ���������� ���� ������
  TYPE course_record IS RECORD (
    course_id NUMBER,
    course_name VARCHAR2(100),
    teacher_info teacher_record,
    student_info student_record
  );

  -- ���������� ���������� ���� ������
  course_info course_record;
BEGIN
  -- ���������� �������� ����� ���� ������
  course_info.course_id := 1;
  course_info.course_name := '��';
  course_info.teacher_info.teacher_id := 1; 
  course_info.teacher_info.teacher_name := '������ �������� �������������';
  course_info.teacher_info.department := '����';
  course_info.student_info.student_id := 1;
  course_info.student_info.student_name := '������ ������';
  course_info.student_info.major := '��';

  -- ����� �������� ����� ���� ������
  DBMS_OUTPUT.PUT_LINE('Course ID: ' || course_info.course_id);
  DBMS_OUTPUT.PUT_LINE('Course Name: ' || course_info.course_name);
  DBMS_OUTPUT.PUT_LINE('Teacher ID: ' || course_info.teacher_info.teacher_id);
  DBMS_OUTPUT.PUT_LINE('Teacher Name: ' || course_info.teacher_info.teacher_name);
  DBMS_OUTPUT.PUT_LINE('Department: ' || course_info.teacher_info.department);
  DBMS_OUTPUT.PUT_LINE('Student ID: ' || course_info.student_info.student_id);
  DBMS_OUTPUT.PUT_LINE('Student Name: ' || course_info.student_info.student_name);
  DBMS_OUTPUT.PUT_LINE('Major: ' || course_info.student_info.major);
END;