use hr;

use information_schema;
show tables;
select * from files;
-- Question 1
create table person(slno int,Name varchar(30),place varchar(20),dob date);
insert into person values(1002,'hitesh','delhi','2000-05-01');
insert into person values(1001,'ritesh','mumbai','1998-07-12');
insert into person values(1005,'balan','kochi','1999-11-05');
select * from person;
-- write a query to display tablespace_name,file_name details
select tablespace_name,file_name from information_schema.files;
-- write a query to display details of slno 1001
select * from person where slno=1001;
-- use explain option and display plan
explain select * from person where slno=1001;
-- create index on slno and check explain format=tree
create index slno_ind on person(slno);
explain format=tree select * from person where slno=1001;
-- make slno as primary and check explain format=tree
alter table person add primary key(slno);
explain format=tree select * from person where slno=1001;
-- give observations of c,d,e
-- c question since there is no index or primary,foreign constraint on the column this goes for table scan access type
-- d since index is created the system directly as index is created and index lookup access scan come here
-- e it gives as rows are fetched before execution with the minimum cost


select distinct(table_name),index_name from information_schema.statistics where table_schema='hr' order by 1;

-- Question 2
use hr;
-- write a query to display city,region_name,country_name,location_id for brazil and india
select city,region_name,country_name,location_id from 
locations natural join regions natural join countries where country_name in ('brazil','india');
-- explain plan check and optimise the query
explain format=tree select city,region_name,country_name,location_id from 
locations natural join regions natural join countries where country_name in ('brazil','india');
-- table scan is only applied on countries table so creating an index for it 
create index coun on countries(country_name);
-- cost reduced
-- creating other indexes are resulting in the same output so this query is optimised only using one index on countries table

-- create partition table based on salary
create table emp_part(id int,ename varchar(30),sal int)
partition by range(sal)
(
partition p_3000 values less than (3000), 
partition p_4000 values less than (4000), 
partition p_6000 values less than (6000), 
partition p_7500 values less than (7500), 
partition p_9000 values less than (9000),
partition p_12000 values less than (12000),
partition p_max values less than maxvalue
);
insert into emp_part select employee_id,first_name,salary from employees;
select * from emp_part;
-- use explain and check partitions column for employees drawing salaries between 12000 and 17000
-- (indicate which partitions are used)
explain select * from emp_part where sal between 12000 and 17000;
-- partition used p_max only one

-- use explain format = tree with the previous query
explain format=tree select * from emp_part where sal between 12000 and 17000;
-- use explain with normal employee table and give your inference
explain format=tree select * from emp_part where sal between 12000 and 17000;
explain format=tree select * from employees where salary between 12000 and 17000;


-- compare above two and give your inference
-- cost reduced from 10.95 to 1.15 after using partition