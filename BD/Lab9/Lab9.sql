alter pluggable database KNI_PDB open;
show con_name;
-- ============================================================

-- 1. ������������ ��, ��������������� ������ ��������� SELECT � ������ ��������.

SELECT * FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE = '��';

-- 2. ������������ ��, ��������������� ������ ��������� SELECT � �������� ������ ��������. 
-- ����������� ����������� WHEN OTHERS ������ ���������� � ���������� �������   
-- SQLERRM, SQLCODE ��� ���������������� �������� �������.
set SERVEROUTPUT on;

DECLARE
  v_AUDITORIUM_TYPE     AUDITORIUM_TYPE.AUDITORIUM_TYPE%TYPE;
  v_AUDITORIUM_TYPENAME AUDITORIUM_TYPE.AUDITORIUM_TYPENAME%TYPE;
BEGIN
  SELECT AUDITORIUM_TYPE,
         AUDITORIUM_TYPENAME
  INTO
    v_AUDITORIUM_TYPE,
    v_AUDITORIUM_TYPENAME
  FROM AUDITORIUM_TYPE
  WHERE AUDITORIUM_TYPE LIKE '%��-�%';

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM_TYPE: ' || v_AUDITORIUM_TYPE || ', AUDITORIUM_TYPENAME: ' || v_AUDITORIUM_TYPENAME);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
end;

-- 3. ������������ ��, ��������������� ������ ����������� WHEN TO_MANY_ROWS 
-- ������ ���������� ��� ���������������� �������� �������.
DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  SELECT AUDITORIUM,
         AUDITORIUM_NAME,
         AUDITORIUM_CAPACITY
  INTO
    v_AUDITORIUM,
    v_AUDITORIUM_NAME,
    v_AUDITORIUM_CAPACITY
  FROM AUDITORIUM
  WHERE AUDITORIUM_TYPE = '��-�';

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
end;

select * from AUDITORIUM;

-- 4. ������������ ��, ��������������� ������������� � ��������� ���������� NO_DATA_FOUND.
DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  SELECT AUDITORIUM,
         AUDITORIUM_NAME,
         AUDITORIUM_CAPACITY
  INTO
    v_AUDITORIUM,
    v_AUDITORIUM_NAME,
    v_AUDITORIUM_CAPACITY
  FROM AUDITORIUM
  WHERE AUDITORIUM_TYPE = '��-notfound';

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
end;

-- 5. ������������ ��, ��������������� ���������� ��������� �������� �������.
select * from AUDITORIUM;
DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  FOR auditorium_rec IN (
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_TYPE = '��'
  )
  LOOP
    -- ����������� �������� ����� �� �������� ������� ����������
    v_AUDITORIUM := auditorium_rec.AUDITORIUM;
    v_AUDITORIUM_NAME := auditorium_rec.AUDITORIUM_NAME;
    v_AUDITORIUM_CAPACITY := auditorium_rec.AUDITORIUM_CAPACITY;

    -- ������� ���������� � ������ ���������
    DBMS_OUTPUT.PUT_LINE('���������: ' || v_AUDITORIUM);
    DBMS_OUTPUT.PUT_LINE('��������: ' || v_AUDITORIUM_NAME);
    DBMS_OUTPUT.PUT_LINE('�����������: ' || v_AUDITORIUM_CAPACITY);
    DBMS_OUTPUT.PUT_LINE('-------------------------');
  END LOOP;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('��� ������');
END;


-- 6. ������������ ��, ��������������� ���������� ��������� UPDATE 
-- ��������� � ����������� COMMIT/ROLLBACK.
select * from AUDITORIUM;

update AUDITORIUM set AUDITORIUM_CAPACITY = 15 where AUDITORIUM = '206-1';

DECLARE
  v_old_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  v_new_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  -- ������� ������� ����������� ��������� '206-1'
  SELECT AUDITORIUM_CAPACITY INTO v_old_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('������� ����������� ��������� 206-1: ' || v_old_capacity);

  -- �������� ����������� ��������� '206-1' �� 20
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 20
  WHERE AUDITORIUM = '206-1';

  -- ������� ����� ����������� ��������� '206-1'
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����� ����������� ��������� 206-1: ' || v_new_capacity);

  -- ������ ���������
  COMMIT;

  -- ������� ����������� ����������� ��������� '206-1' ����� �������
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����������� ����������� ��������� 206-1 ����� �������: ' || v_new_capacity);

  -- �������� ����������� ��������� '206-1' �� 25
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 25
  WHERE AUDITORIUM = '206-1';

  -- ������� ����� ����������� ��������� '206-1'
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����� ����������� ��������� 206-1: ' || v_new_capacity);

  -- ����� ���������
  ROLLBACK;

  -- ������� ����������� ��������� '206-1' ����� ������
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('����������� ��������� 206-1 ����� ������: ' || v_new_capacity);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('��������� ������: ' || SQLERRM);
    -- ����� ��������� � ������ ������
    ROLLBACK;
END;

-- 7. ����������������� �������� UPDATE, ���������� ��������� ����������� � ���� ������. 
-- ����������� ��������� ����������.
select * from AUDITORIUM;

DECLARE
BEGIN
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = '���������'
  WHERE AUDITORIUM_CAPACITY = 90;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

-- 8. ������������ ��, ��������������� ���������� ��������� INSERT 
-- ��������� � ����������� COMMIT/ROLLBACK.
select * from AUDITORIUM;
delete from AUDITORIUM where AUDITORIUM = '111-1';

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('111-1', '111-1', 100, '��')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  COMMIT;

  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('112-1', '112-2', 100, '��')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);

  ROLLBACK;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;


-- 9. ����������������� �������� INSERT, ���������� ��������� ����������� � ���� ������. 
-- ����������� ��������� ����������.
select * from AUDITORIUM;

DECLARE
BEGIN
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values ('429-4', '429-4', '��', 90);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

-- 10. ������������ ��, ��������������� ���������� ��������� DELETE 
-- ��������� � ����������� COMMIT/ROLLBACK.
DECLARE
  v_count_before NUMBER;
  v_count_after NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count_before FROM AUDITORIUM;
  DBMS_OUTPUT.PUT_LINE('���������� ������� �� ��������: ' || v_count_before);
  DELETE FROM AUDITORIUM WHERE AUDITORIUM_TYPE = '��';
  SELECT COUNT(*) INTO v_count_after FROM AUDITORIUM;
  DBMS_OUTPUT.PUT_LINE('���������� ������� ����� ��������: ' || v_count_after);
  
  -- ���� ��� ������ �������, ��������� ���������
  --COMMIT;
  
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('��������� ���� ��������.');
  
EXCEPTION
  WHEN OTHERS THEN
    -- ���� ��������� ������, ���������� ���������
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('��������� ������. ��������� ���� ��������.');
END;

-- 11. ����������������� �������� DELETE, ���������� ��������� ����������� � ���� ������. 
-- ����������� ��������� ����������.
select * from AUDITORIUM_TYPE;

DECLARE
BEGIN
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 11;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('������: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

-- 12. �������� ��������� ����, ��������������� ������� TEACHER � ����������� 
-- ������ ������� LOOP-�����. ��������� ������ ������ ���� �������� � ����������, 
-- ����������� � ����������� ����� %TYPE.
select * from TEACHER;

DECLARE
  v_TEACHER      TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT       TEACHER.PULPIT%TYPE;
  CURSOR c_TEACHER IS
    SELECT TEACHER,
           TEACHER_NAME,
           PULPIT
    FROM TEACHER;
BEGIN
  FOR i IN c_TEACHER
    LOOP
      v_TEACHER := i.TEACHER;
      v_TEACHER_NAME := i.TEACHER_NAME;
      v_PULPIT := i.PULPIT;
      DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME || ', PULPIT: ' ||
                           v_PULPIT);
    END LOOP;
end;

-- 13. �������� ��, ��������������� ������� SUBJECT � ����������� 
-- ������ ������� � WHILE-�����. 
-- ��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.
DECLARE
  v_SUBJECT SUBJECT%ROWTYPE;
  CURSOR c_SUBJECT IS
    SELECT *
    FROM SUBJECT;
BEGIN
  OPEN c_SUBJECT;
  WHILE TRUE
    LOOP
      FETCH c_SUBJECT INTO v_SUBJECT;
      EXIT WHEN c_SUBJECT%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('SUBJECT: ' || v_SUBJECT.SUBJECT || ', SUBJECT_NAME: ' || v_SUBJECT.SUBJECT_NAME ||
                           ', PULPIT: ' || v_SUBJECT.PULPIT);
    END LOOP;
end;

-- 14. �������� ��, ��������������� ��� ������� (������� PULPIT) 
-- � ������� ���� �������������� (TEACHER) �����������
-- ���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.
DECLARE
  v_PULPIT         PULPIT.PULPIT%TYPE;
  v_PULPIT_NAME    PULPIT.PULPIT_NAME%TYPE;
  v_FACULTY        PULPIT.FACULTY%TYPE;
  v_TEACHER        TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME   TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT_TEACHER PULPIT.PULPIT%TYPE;
  CURSOR c_PULPIT_TEACHER IS
    SELECT PULPIT.PULPIT,
           PULPIT.PULPIT_NAME,
           PULPIT.FACULTY,
           TEACHER.TEACHER,
           TEACHER.TEACHER_NAME
    FROM PULPIT
           JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT;
BEGIN
  FOR i IN c_PULPIT_TEACHER
    LOOP
      v_PULPIT := i.PULPIT;
      v_PULPIT_NAME := i.PULPIT_NAME;
      v_FACULTY := i.FACULTY;
      v_TEACHER := i.TEACHER;
      v_TEACHER_NAME := i.TEACHER_NAME;
      DBMS_OUTPUT.PUT_LINE('PULPIT: ' || v_PULPIT || ', PULPIT_NAME: ' || v_PULPIT_NAME || ', FACULTY: ' || v_FACULTY ||
                           ', TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME);
    END LOOP;
end;

-- 15. �������� ��, ��������������� ��������� ������ ���������: 
-- ��� ��������� (������� AUDITORIUM) � ������������ 
-- ������ 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 81 � ����. 
-- ��������� ������ � ����������� � ��� ������� ����������� ����� �� ������� �������.

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  isFirst20 boolean := true;
  isFirst30 boolean := true;
  isFirst60 boolean := true;
  isFirst80 boolean := true;
  isFirstFull boolean := true;

  CURSOR c_AUDITORIUM IS
    SELECT AUDITORIUM,
           AUDITORIUM_NAME,
           AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    ORDER BY AUDITORIUM_CAPACITY;

BEGIN
  OPEN c_AUDITORIUM;
  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    IF v_AUDITORIUM_CAPACITY >= 0 and v_AUDITORIUM_CAPACITY <= 20 THEN
      IF isFirst20 then
        DBMS_OUTPUT.PUT_LINE('------------------ 0 > 20 ----------------');
        isFirst20 := false;
      end if;
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                           ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
    END IF;

    IF v_AUDITORIUM_CAPACITY >= 21 and v_AUDITORIUM_CAPACITY <= 30 THEN
      IF isFirst30 then
        DBMS_OUTPUT.PUT_LINE('------------------ 21 > 30  ----------------');
        isFirst30 := false;
      end if;
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                           ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
    END IF;

    IF v_AUDITORIUM_CAPACITY >= 31 and v_AUDITORIUM_CAPACITY <= 60 THEN
      IF isFirst60 then
        DBMS_OUTPUT.PUT_LINE('------------------ 31 > 60 ----------------');
        isFirst60 := false;
      end if;
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                           ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
    END IF;

    IF v_AUDITORIUM_CAPACITY >= 61 and v_AUDITORIUM_CAPACITY <= 80 THEN
      IF isFirst80 then
        DBMS_OUTPUT.PUT_LINE('------------------ 61 > 80 ----------------');
        isFirst80 := false;
      end if;
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                           ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
    END IF;

    IF v_AUDITORIUM_CAPACITY >= 81 THEN
      IF isFirstFull then
        DBMS_OUTPUT.PUT_LINE('------------------ > 81 ----------------');
        isFirstFull := false;
      end if;
      DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                           ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
    END IF;
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

-- 16. �������� A�. �������� ��������� ���������� � ������� ���������� ���� refcursor. 
-- ����������������� �� ���������� ��� ������� c �����������.

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  c_AUDITORIUM          SYS_REFCURSOR;
BEGIN
  OPEN c_AUDITORIUM FOR
    SELECT AUDITORIUM,
           AUDITORIUM_NAME,
           AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_TYPE = '��';

  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                         ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

-- 17. �������� A�. ����������������� ������� ��������� ���������


DECLARE
   CURSOR task17 IS
      SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
      FROM AUDITORIUM
      WHERE AUDITORIUM_TYPE = (
         SELECT AUDITORIUM_TYPE
         FROM AUDITORIUM
         WHERE AUDITORIUM_NAME = '429-4'
      );
   auditorium_id AUDITORIUM.AUDITORIUM%TYPE;
   auditorium_name AUDITORIUM.AUDITORIUM_NAME%TYPE;
   auditorium_type AUDITORIUM.AUDITORIUM_TYPE%TYPE;
   auditorium_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
   OPEN task17;
   LOOP
      FETCH task17 INTO auditorium_id, auditorium_name, auditorium_type, auditorium_capacity;
      EXIT WHEN task17%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(
         '���������: ' || auditorium_id ||
         ', ��������: ' || auditorium_name ||
         ', ���: ' || auditorium_type ||
         ', �����������: ' || auditorium_capacity
      );
   END LOOP;
   CLOSE task17;
END;

-- 18. �������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM) 
-- ������������ �� 40 �� 80 �� 10%. 
-- ����������� ����� ������ � �����������, ���� FOR, ����������� UPDATE CURRENT OF.
select * from AUDITORIUM;
rollback;

DECLARE
  CURSOR c_AUDITORIUM IS
    SELECT *
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 40
      and AUDITORIUM_CAPACITY <= 80
      FOR UPDATE;
BEGIN
  FOR i IN c_AUDITORIUM
    LOOP
      UPDATE AUDITORIUM
      SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9
      WHERE CURRENT OF c_AUDITORIUM;
    END LOOP;
end;

-- 19. �������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20. 
-- ����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF.
select * from AUDITORIUM;
rollback;

DECLARE
  v_AUDITORIUM AUDITORIUM.AUDITORIUM%TYPE;
  CURSOR c_AUDITORIUM IS
    SELECT AUDITORIUM
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 0
      and AUDITORIUM_CAPACITY <= 20
      FOR UPDATE;
BEGIN
  OPEN c_AUDITORIUM;
  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    DELETE
    FROM AUDITORIUM
    WHERE CURRENT OF c_AUDITORIUM;
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

-- 20. �������� A�. ����������������� ���������� ������������� ROWID 
-- � ���������� UPDATE � DELETE.
select * from AUDITORIUM;
rollback;

DECLARE
  CURSOR c_AUDITORIUM IS
    SELECT ROWID
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 0
      and AUDITORIUM_CAPACITY <= 20
      FOR UPDATE;
BEGIN
  FOR i IN c_AUDITORIUM
    LOOP
      UPDATE AUDITORIUM
      SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9
      WHERE ROWID = i.ROWID;
      DELETE
      FROM AUDITORIUM
      WHERE ROWID = i.ROWID;
    END LOOP;
end;

-- 21. ������������ � ����� ����� ���� �������������� (TEACHER), 
-- �������� �������� �� ��� (�������� ������ ������ -------------).

DECLARE
  v_TEACHER      TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT       TEACHER.PULPIT%TYPE;
  CURSOR c_TEACHER IS
    SELECT TEACHER,
           TEACHER_NAME,
           PULPIT
    FROM TEACHER;
BEGIN
  OPEN c_TEACHER;
  LOOP
    FETCH c_TEACHER INTO v_TEACHER, v_TEACHER_NAME, v_PULPIT;
    EXIT WHEN c_TEACHER%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME || ', PULPIT: ' ||
                         v_PULPIT);
    IF MOD(c_TEACHER%ROWCOUNT, 3) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('-----------------');
    END IF;
  END LOOP;

  CLOSE c_TEACHER;
end;