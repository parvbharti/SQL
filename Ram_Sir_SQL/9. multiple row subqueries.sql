use hr;
-- find employees who donot have subordinates
select first_name from employees where employee_id not in (select manager_id from employees where manager_id is not null);

-- find out employees who are working in location 1700
select first_name from employees where department_id in (select distinct(department_id) from departments where location_id=1700);

-- find out employees who take more salary than the average salary 
-- and who work in department with a employee containing 'u' in his lastname
select first_name from employees 
where salary>(select avg(salary) from employees)
and department_id in (select distinct(department_id) from employees where last_name like '%u%');

-- find out employees who are taking highest salary of each department
select first_name,salary,department_id from employees 
where (salary,department_id) in (select max(salary),department_id from employees group by department_id);

select first_name,salary,department_id from employees 
where salary in (select max(salary) from employees 
where department_id in (select distinct(department_id) from employees where department_id is not null)group by department_id );

select first_name,salary,department_id from employees
where first_name in (select first_name,department_id from employees group by department_id) and department_id is not null;

select first_name,department_id from employees group by department_id;

-- find out job id having maximum no of employees
select job_id from employees 
where job_id is not null group by job_id 
having count(employee_id) in (select max(a.cnt) from (select count(*) cnt from employees group by job_id) a);

-- find all those employees
select first_name from employees where job_id=(select job_id from employees 
where job_id is not null group by job_id 
having count(employee_id) in (select max(a.cnt) from (select count(*) cnt from employees group by job_id) a));

-- find dname of the employees who have joined on 1st thursday
select department_name from departments 
where department_id in 
(select department_id from employees 
where month(hire_date)!=month(date_sub(hire_date,interval '7' day)) and dayname(hire_date)='Thursday');

-- correlated sub queries
-- this is a type of query in which the outer query also supports the inner query

-- find employees who are having salaries grater than the avg salaries of that purticular department
select first_name, department_id, salary from employees e 
where salary>(select avg(salary) from employees where department_id=e.department_id);

select first_name,m.department_id,salary,e.avsal from employees m
 inner join (select avg(salary) avsal,department_id from employees group by department_id) e
 on e.department_id=m.department_id and m.salary>e.avsal order by 2; 
 
-- Group Concat
-- It concatinates rows based upon conditions and grouping
-- it is similar to listagg in oracle
select group_concat(first_name) 'name in same dept',department_id from employees
where department_id in (60,90) group by department_id; 
select group_concat(first_name) 'name in same dept',department_id from employees 
where department_id not in (50,80) group by department_id; 
