--1
select * from dba_pdbs; 

--2
select * from V$INSTANCE;

--3
SELECT 
    comp_id,
    comp_name,
    version,
    status
FROM 
    dba_registry;

--5
select * from dba_pdbs;

--6
alter session set container = KNI_PDB;
alter pluggable database KNI_PDB open;
alter session set "_ORACLE_SCRIPT" = true;

alter session set container = CDB$ROOT; --вернутся к истокам

show con_name;

create tablespace TS_KNI_Lb3
  datafile 'TS_KNI_Lb3.dbf'
  size 10M
  autoextend on next 5M
  maxsize 50M;
  
create temporary tablespace TS_KNI_TEMP_Lb3
  tempfile 'TS_KNI_TEMP_Lb3.dbf'
  size 5M
  autoextend on next 2M
  maxsize 40M;

select * from dba_tablespaces where TABLESPACE_NAME like '%KNI%';

drop tablespace TS_KNI_Lb3 including contents and datafiles;
drop tablespace TS_KNI_TEMP_Lb3 including contents and datafiles;

-- role
create role KNI_PDB_RL;

grant 
    connect, 
    create session,
    alter session,
    create any table, 
    drop any table, 
    create any view, 
    drop any view, 
    create any procedure, 
    drop any procedure 
to KNI_PDB_RL;

select * from dba_roles where ROLE like '%RL%';
drop role KNI_PDB_RL;

create profile KNI_PDB_PROFILE limit
  password_life_time 365
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 10
  connect_time 180;
  
select * from dba_profiles where PROFILE like '%KNI_PDB_PROFILE%';
drop profile KNI_PDB_PROFILE;
  
-- user
create user U1_KNI_PDB 
    identified by 111
    default tablespace TS_KNI_Lb3 
    quota unlimited on TS_KNI_Lb3
    temporary tablespace TS_KNI_TEMP_Lb3
    profile KNI_PDB_PROFILE
    account unlock
    password expire;
    
    
grant 
    KNI_PDB_RL,
    SYSDBA
to U1_KNI_PDB; 

select * from dba_users where USERNAME like '%U1%';
drop user U1_KNI_PDB;

-- 7
select global_name from global_name;

create table KNI_PDB_TABLE 
(
    id int primary key,
    field varchar(50)
);

insert into KNI_PDB_TABLE values (1, 'Test1'); 
insert into KNI_PDB_TABLE values (2, 'Test2');
insert into KNI_PDB_TABLE values (3, 'Test3');
       
select * from KNI_PDB_TABLE
drop table  KNI_PDB_TABLE;

-- 8
select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_temp_files;
select * from dba_roles where ROLE like 'KNI%';
select * from dba_sys_privs where GRANTEE like 'KNI%';
select * from dba_profiles where PROFILE like 'KNI%';
select * from dba_users where USERNAME like '%KNI%';

-- 9
alter session set container = CDB$ROOT;
SHOW CON_NAME;

create user C##KNI
    identified by 111;
    
grant 
    connect, 
    create session, 
    alter session, 
    create any table,
    drop any table,
    SYSDBA
to C##KNI container = all;

select * from dba_users where USERNAME like '%C##%';

-- Запускать в коннекте Task9CDB
create table x (id int);
drop table x;

-- Запускать в коннекте Task9PDB
create table x (id int);
drop table x;

-- 10
create user C##KNI2
    identified by 111;
    
grant 
    connect, 
    create session, 
    alter session, 
    create any table,
    drop any table,
    SYSDBA
to C##KNI2 container = all;

select * from dba_users where USERNAME like '%C##%';

-- 11
-- В файле Task11.sql

-- 13
show pdbs;
alter pluggable database KNI_PDB close;
drop pluggable database KNI_PDB including datafiles;