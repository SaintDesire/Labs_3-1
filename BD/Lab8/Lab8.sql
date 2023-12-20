create table AUDITORIUM_TYPE (
AUDITORIUM_TYPE char(20) constraint AUDITORIUM_TYPE_PK primary key,
AUDITORIUM_TYPENAME varchar2(60) constraint AUDITORIUM_TYPENAME_NOT_NULL not null
);

create table AUDITORIUM (
AUDITORIUM char(20) primary key, -- ��� ���������
AUDITORIUM_NAME varchar2(200), -- ���������
AUDITORIUM_CAPACITY number(4), -- �����������
AUDITORIUM_TYPE char(20) not null -- ��� ���������
references AUDITORIUM_TYPE(AUDITORIUM_TYPE)
);

CREATE TABLE FACULTY (
FACULTY CHAR(20) NOT NULL,
FACULTY_NAME VARCHAR2(200),
CONSTRAINT PK_FACULTY PRIMARY KEY(FACULTY)
);

CREATE TABLE PULPIT (
PULPIT CHAR(20) NOT NULL,
PULPIT_NAME VARCHAR2(200),
FACULTY CHAR(20) NOT NULL,
CONSTRAINT FK_PULPIT_FACULTY FOREIGN KEY(FACULTY) REFERENCES FACULTY(FACULTY),
CONSTRAINT PK_PULPIT PRIMARY KEY(PULPIT)
);

CREATE TABLE TEACHER (
TEACHER CHAR(20) NOT NULL,
TEACHER_NAME VARCHAR2(200),
PULPIT CHAR(20) NOT NULL,
CONSTRAINT PK_TEACHER PRIMARY KEY(TEACHER),
CONSTRAINT FK_TEACHER_PULPIT FOREIGN KEY(PULPIT) REFERENCES PULPIT(PULPIT)
);

CREATE TABLE SUBJECT (
SUBJECT CHAR(20) NOT NULL,
SUBJECT_NAME VARCHAR2(200) NOT NULL,
PULPIT CHAR(20) NOT NULL,
CONSTRAINT PK_SUBJECT PRIMARY KEY(SUBJECT),
CONSTRAINT FK_SUBJECT_PULPIT FOREIGN KEY(PULPIT) REFERENCES PULPIT(PULPIT)
);

-- ��������� ������� AUDITORIUM_TYPE
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('��', '����������');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('��-�', '������������ �����');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('��-�', '���������� � ���. ������������');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('��-X', '���������� �����������');
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('��-��', '����. ������������ �����');

-- ��������� ������� AUDITORIUM
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('206-1', '206-1', '��-�', 15);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values ('301-1', '301-1', '��-�', 15);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('236-1', '236-1', '��', 60);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('313-1', '313-1', '��', 60);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('324-1', '324-1', '��', 50);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('413-1', '413-1', '��-�', 15);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('423-1', '423-1', '��-�', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('408-2', '408-2', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('103-4', '103-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('105-4', '105-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('107-4', '107-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('110-4', '110-4', '��', 30);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('111-4', '111-4', '��', 30);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('114-4', '114-4', '��-�', 90 );
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('132-4', '132-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('02�-4', '02�-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('229-4', '229-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('304-4', '304-4','��-�', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('314-4', '314-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('320-4', '320-4', '��', 90);
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )
values ('429-4', '429-4', '��', 90);

-- ��������� ������� FACULTY
insert into FACULTY (FACULTY, FACULTY_NAME )
values ('����', '����������� ���� � ����������');
insert into FACULTY (FACULTY, FACULTY_NAME )
values ('����', '���������� ���������� � �������');
insert into FACULTY (FACULTY, FACULTY_NAME )
values ('���', '����������������� ���������');
insert into FACULTY (FACULTY, FACULTY_NAME )
values ('���', '���������-������������� ���������');
insert into FACULTY (FACULTY, FACULTY_NAME )
values ('����', '���������� � ������� ������ ��������������');
insert into FACULTY (FACULTY, FACULTY_NAME )
values ('���', '���������� ������������ �������');

-- ��������� ������� PULPIT
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY )
values ('����', '������������� ������ � ���������� ', '����' );
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY )
values ('������', '���������������� ������������ � ������ ��������� ���������� ', '����' );
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('��', '�����������', '���') ;
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('��', '������������', '���') ;
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('��', '��������������', '���');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('�����', '���������� � ����������������', '���');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('������', '������������ �������������� � ������-��������� �������������','���');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('��', '���������� ����', '����');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('�����', '������ ����� � ���������� �������������', '����');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('��', '������������ �����', '���');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('��������','���������� ���������������� ������� � ����������� ���������� ����������','���');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('�������','���������� �������������� ������� � ����� ���������� ���������� ','����');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('��������','�����, ���������� ����������������� ����������� � ���������� ����������� �������', '����');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('����', '������������� ������ � ����������', '���');
insert into PULPIT (PULPIT, PULPIT_NAME, FACULTY)
values ('����', '����������� � ��������� ������������������', '���');

-- ��������� ������� TEACHER
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������ �������� �������������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('�����', '�������� ��������� ��������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('�����', '���������� ������ ����������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������ ���� �����������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������� �������� ��������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('�����', '�������� ������ ���������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('���', '����� ��������� ����������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('���', '������� ��������� �����������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('���', '��������� ����� ��������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '��������� ������� ����������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('������', '����������� ������� ����������', '����' );
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('?', '�����������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('���', '����� ������� ��������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('���', '����� ������� �������������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('������', '���������� ��������� �������������', '������');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('�����', '������� ������ ����������', '������');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('������', '����������� ��������� ��������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������� ��������� ����������', '����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������ ������ ��������', '��');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������� ������ ����������', '������');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('������', '���������� �������� ��������', '��');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('���', '������ ���������� ������������', '��');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('�����', '��������� �������� ���������', '�����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('������', '���������� �������� ����������', '��');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('������', '��������� ������� ���������', '��������');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('�����', '�������� ������ ����������', '��');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('���', '����� ������ ��������', '�����');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������ ������� ���������', '�������');
insert into TEACHER (TEACHER, TEACHER_NAME, PULPIT )
values ('����', '������� ���� ����������', '��������');

-- ��������� ������� SUBJECT
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('����', '������� ���������� ������ ������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
values ('��', '���� ������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '�������������� ����������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('����', '������ �������������� � ����������������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '������������� ������ � ������������ ��������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '��������������� ������� ����������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('����', '������������� ������ ��������� ����������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '�������������� �������������� ������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '������������ ��������� ', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('�����', '��������������� ������, �������� � �������� �����', '������');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '������������ �������������� �������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '����������� ���������������� ������������', '������');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
values ('��', '���������� ���������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '�������������� ����������������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('����', '���������� ������ ���', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '��������-��������������� ����������������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '��������� ������������������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '������������� ������', '����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('������OO','�������� ������ ������ � ���� � ���. ������.', '��');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('�������','������ ��������������� � ������������� ���������', '������');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '���������� �������� ', '��');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '�����������', '�����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('��', '������������ �����', '��');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '���������� ��������� �������', '��������');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '������ ��������� ����', '��');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('����', '���������� � ������������ �������������', '�����');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('����', '���������� ���������� �������� ���������� ', '�������');
insert into SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT )
values ('���', '���������� ������������', '��������');

select table_name from all_tables where owner = 'KNI';

drop table AUDITORIUM_TYPE;
drop table AUDITORIUM;
drop table FACULTY;
drop table PULPIT;
drop table TEACHER;
drop table SUBJECT;

-- 1. ������������ ���������� ��������� ���� PL/SQL (��), �� ���������� ����������.

BEGIN
  NULL;
END;

-- 2. ������������ ��, ��������� �Hello World!�. ��������� ��� � SQLDev � SQL+.

DECLARE
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END;
/

-- 3. ����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode.

DECLARE
  v_num NUMBER;
BEGIN
  v_num := 1/0;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
end;

-- 4. ������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.

DECLARE
  v_num NUMBER;
BEGIN
  declare
  begin
    v_num := 1/0;
  exception
    when others then
      dbms_output.put_line('Error: ' || sqlerrm);
      dbms_output.put_line('Error code: ' || sqlcode);
  end;
  dbms_output.put_line('Hello World!');
end;

-- 5. ��������, ����� ���� �������������� ����������� �������������� � ������ ������.
select
  type,
  value
from
  v_$parameter
where
  name = 'plsql_warnings';

-- 6. ������������ ������, ����������� ����������� ��� ����������� PL/SQL.

select
  keyword
from
  V_$RESERVED_WORDS
where
  LENGTH = 1 and
  KEYWORD <> 'A';

-- 7. ������������ ������, ����������� ����������� ��� �������� ����� PL/SQL.

select
  keyword
from
  V_$RESERVED_WORDS
where
  LENGTH > 1 and
  keyword <> 'A'
order by keyword;

-- 8. ������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL. 
-- ����������� ��� �� ��������� � ������� SQL+-������� show.
select
  name,
  value
from
  v_$parameter
where
  name like 'plsql%';
  
show parameter plsql;

-- 9. ������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
-- 10. ���������� � ������������� ����� number-����������;

DECLARE
  v_num1 NUMBER := 1;
  v_num2 INTEGER := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

-- 11. �������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;

DECLARE
  v_num1 NUMBER := 1;
  v_num2 NUMBER(3) := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1 + v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 - v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 * v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 / v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 mod v_num2);
END;

-- 12. ���������� � ������������� number-���������� � ������������� ������;

DECLARE
  v_num1 NUMBER := 1.1;
  v_num2 NUMBER(3, 1) := 2.2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

-- 13. ���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� 
-- (����������);

DECLARE
  v_num1 NUMBER := 1.1;
  v_num2 NUMBER(3, -1) := 2.2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2); 
END;

-- 14. ���������� � ������������� BINARY_FLOAT-����������;

DECLARE
  v_num BINARY_FLOAT := 1.1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num);
end;

-- 15. ���������� � ������������� BINARY_DOUBLE-����������;

DECLARE
  v_num BINARY_DOUBLE := 1.1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num);
END;

-- 16. ���������� number-���������� � ������ � ����������� ������� E (������� 10) 
-- ��� �������������/����������;

DECLARE
  v_num1 NUMBER := 1.1E1;
  v_num2 NUMBER := 1.1E-1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

-- 17. ���������� � ������������� BOOLEAN-����������

DECLARE
  v_bool BOOLEAN := TRUE;
BEGIN
  IF v_bool THEN
    DBMS_OUTPUT.PUT_LINE('TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('FALSE');
  END IF;
END;

-- 18. ������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). 
-- ����������������� ��������� �������� �����������.

DECLARE
   v_varchar2_const CONSTANT VARCHAR2(20) := 'Hello World!';
   v_char_const CONSTANT CHAR(10) := 'ABC';
   v_number_const CONSTANT NUMBER := 10;

   v_concatenated_string VARCHAR2(30);
   v_sum_of_numbers NUMBER;
BEGIN
   v_concatenated_string := v_varchar2_const || ' PL/SQL Test';
   DBMS_OUTPUT.PUT_LINE(v_concatenated_string);

   v_concatenated_string := v_char_const || 'DEF';
   DBMS_OUTPUT.PUT_LINE(v_concatenated_string);

   v_sum_of_numbers := v_number_const + 5;
   DBMS_OUTPUT.PUT_LINE('����� �����: ' || v_sum_of_numbers);
END;

-- 19. ������������ ��, ���������� ���������� � ������ %TYPE. ����������������� �������� �����.

DECLARE
  VCHAR_CONST CONSTANT VARCHAR2(20) := 'VCHAR_CONST';
  CHAR_CONST CONSTANT CHAR(20) := 'CHAR_CONST';
  NUMBER_CONST CONSTANT NUMBER := 1;
  VCHAR_CONST2 VCHAR_CONST%TYPE := 'VCHAR_CONST2';
  CHAR_CONST2 CHAR_CONST%TYPE := 'CHAR_CONST2';
  NUMBER_CONST2 NUMBER_CONST%TYPE := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(VCHAR_CONST2);
  DBMS_OUTPUT.PUT_LINE(CHAR_CONST2);
  DBMS_OUTPUT.PUT_LINE(NUMBER_CONST2);
END;

-- 20. ������������ ��, ���������� ���������� � ������ %ROWTYPE. ����������������� �������� �����.

DECLARE
  AUDITORIUM_TYPE_ROW AUDITORIUM_TYPE%ROWTYPE;
BEGIN
  AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPENAME := '���������';
  AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPE := 'Auditorium';

  DBMS_OUTPUT.PUT_LINE(AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPE);
  DBMS_OUTPUT.PUT_LINE(AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPENAME);
end;

-- 21. ������������ ��, ��������������� ��� ��������� ����������� ��������� IF.

DECLARE
  v_num NUMBER := 1;
BEGIN
  IF v_num = 1 THEN
    DBMS_OUTPUT.PUT_LINE('v_num = 1');
  ELSIF v_num = 2 THEN
    DBMS_OUTPUT.PUT_LINE('v_num = 2');
  ELSIF v_num is null THEN
    DBMS_OUTPUT.PUT_LINE('v_num is null');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_num = 3');
  END IF;
END;

-- 22. ������������ ��, ��������������� ��� ��������� ����������� ��������� IF.
-- ������ 21 )))

-- 23. ������������ ��, ��������������� ������ ��������� CASE.

DECLARE
  v_num NUMBER := 1;
BEGIN
  CASE v_num
    WHEN 1 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 1');
    WHEN 2 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 2');
    WHEN 3 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 3');
    ELSE
      DBMS_OUTPUT.PUT_LINE('v_num is null');
  END CASE;
END;

-- 24. ������������ ��, ��������������� ������ ��������� LOOP.

DECLARE
  v_num NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num + 1;
    EXIT WHEN v_num > 10;
  END LOOP;
END;

-- 25. ������������ ��, ��������������� ������ ��������� WHILE.

DECLARE
  v_num NUMBER := 1;
BEGIN
  WHILE v_num <= 10 LOOP
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num + 1;
  END LOOP;
END;

-- 26. ������������ ��, ��������������� ������ ��������� FOR.

DECLARE
  v_num NUMBER := 1;
BEGIN
  FOR i IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;