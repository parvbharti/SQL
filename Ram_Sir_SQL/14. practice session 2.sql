-- create table called dept1 as a replica of departments tables
create table dept1 as select * from departments;
-- create table called emp1 as replica of employees table (copy only structure)
create table emp1 as select * from employees where 1=0;
# this can also be created by 
create table emp2 like employees;
-- add primary key to department_id 
desc dept1;
alter table dept1 add constraint primary key(department_id);
-- add primary key on emp_id
desc emp1;
alter table emp1 add constraint primary key(employee_id);
-- establish a referential integrity between dept1 and emp1 on department_id
alter table emp1 add constraint foreign key(department_id) references dept1(department_id) on delete set null;
-- referential integrity does not mean that it should contain foreign key it is only foreign key
show create table emp1;
alter table emp1 drop constraint emp1_ibfk_1;
alter table emp1 add constraint fk1 foreign key(department_id) references dept1(department_id);
-- insert employee details who are taking maximum salary in each department_id into emp table
insert into emp1 select * from employees where employee_id in 
(select employee_id from employees where (salary,department_id) in 
(select max(salary),department_id from employees group by department_id));
select * from emp1;
select distinct(department_id) from employees;
use sample;
show tables;


