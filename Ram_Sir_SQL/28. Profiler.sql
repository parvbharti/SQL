show profiles;

select @@profiling;
set @@profiling=1;
select * from emp;
select * from dept;
select count(*) from emp;
show profiles;
show profile for query 5;
select state, format(duration,6) as duration from information_schema.profiling where query_id=5;