-- 6
grant 
    connect, 
    create session,
    restricted session,
    alter session, 
    create any table,
    drop any table,
    SYSDBA
to C##KNI container = all;

 
create table x (id number);
insert into x values (1);
insert into x values (2);
insert into x values (3);
    

-- 10
select * from dba_segments where owner = 'C##KNI';

-- 11
create or replace view segment_summary as
select
    owner,
    segment_type,
    count(*) as segment_count,
    sum(extents) as total_extents,
    sum(blocks) as total_blocks,
    sum(bytes) / 1024 as total_size_kb
from
    dba_segments
group by
    owner,
    segment_type;
    
select * from segment_summary;