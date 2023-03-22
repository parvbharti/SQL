use hr;
create table job_grades
(grade_level char(1),
 lowest_sal numeric(11,2),
 high_sal numeric(11,2));

insert into job_grades
values ("A",1000,2999),
("B",3000,5999),
("C",6000,9999),
 ("D",10000,14999),
 ("E",15000,24999),
 ("F",25000,40000);
 
 select * from employees;
 select * from job_grades;
 select * from departments;
 -- find out grade of each employee
 select  concat(first_name,' ',last_name),salary,grade_level from employees join job_grades on salary between lowest_sal and high_sal;
 -- combine employees,departments,jobgrades table
 select first_name,salary,grade_level,department_name 
 from employees e
 inner join departments d on d.department_id=e.department_id
 join job_grades on salary between lowest_sal and high_sal;
 -- join countries,locations and regions tables and get region_name,country_name,city
 select * from countries;
 select * from regions;
 select * from locations;
 select country_name,region_name,city
 from countries c
 inner join regions r on r.region_id=c.region_id
 inner join locations l on l.country_id=c.country_id;
 -- get the details of employee name,department name,city
 select * from locations;
 select * from employees;
 select * from departments;
 select concat(first_name,' ',last_name),department_name,city
 from departments d
 inner join employees e on e.department_id=d.department_id
 inner join locations l on l.location_id=d.location_id;
 
 -- Cross Join
 -- This will result when ever join conditions are ommitted or not corretly specified
 -- here all rows of one table are joined with all rows of second table
 select * from locations cross join departments;
 select * from employees cross join departments;
 
 -- Self Join
 -- The table is joined with itself then it is called as self join
 use demo;
 select e1.ename,e2.ename from emp e1 join emp e2 on e1.mgr=e2.empno; 
 -- peerforming left join instead of join
 select e1.ename,e2.ename from emp e1 left join emp e2 on e1.mgr=e2.empno; 
 -- in this case king will also be displayed showing null as his manager
 
 -- compare no of employees reporting to blake
 select count(e1.ename) 'count of employees reporting to blake' from emp e1 join emp e2 on e1.mgr=e2.empno where e2.ename='blake';
 -- find employees who have joined before their manager
 select e1.ename,e1.HIREDATE,e2.ename,e2.HIREDATE from emp e1 join emp e2 on e1.mgr=e2.empno where e1.HIREDATE<e2.HIREDATE;
 -- find employees who have slaries more than their manager
 select e1.ename,e1.sal,e2.ename,e2.sal from emp e1 join emp e2 on e1.mgr=e2.empno where e1.sal>e2.sal;
 -- find employees who are taking same salaries
 select e1.ename,e1.sal,e2.ename,e2.sal from emp e1 join emp e2 where e1.sal=e2.sal and e1.ename!=e2.ename;
 -- same query in hr database
 use hr;
 select * from employees;
 select e1.first_name,e1.salary,e2.first_name,e2.salary from employees e1 
 join employees e2 where e1.salary=e2.salary and e1.first_name!=e2.first_name;
 -- find out the job which was filled in second half of one year and filled in first half of next year
 use demo;
 select e1.job,month(e1.HIREDATE),e2.job,month(e2.HIREDATE) from emp e1 join emp e2  
 where month(e1.hiredate) between 7 and 12 and 
 month(e2.hiredate) between 1 and 6 and 
 e1.job=e2.job and 
 year(date_add(e1.hiredate,interval '1' year))=year(e2.hiredate);
 -- using in
 select e1.job,month(e1.HIREDATE),e2.job,month(e2.HIREDATE) from emp e1 join emp e2  
 where month(e1.hiredate) in (7,8,9,10,11,12) and 
 month(e2.hiredate) in (1,2,3,4,5,6) and 
 e1.job=e2.job and 
 year(date_add(e1.hiredate,interval '1' year))=year(e2.hiredate);
 -- using quarter
 select e1.job,quarter(e1.HIREDATE),e2.job,quarter(e2.HIREDATE) from emp e1 join emp e2  
 where quarter(e1.HIREDATE) in (3,4) and 
 quarter(e2.HIREDATE) in (1,2) and 
 e1.job=e2.job and 
  year(date_add(e1.hiredate,interval '1' year))=year(e2.hiredate);
 -- using hr database
 select e1.job_id,month(e1.HIRE_DATE),e2.job_id,month(e2.HIRE_DATE) from employees e1 join employees e2  
 where month(e1.hire_date) in (7,8,9,10,11,12) and 
 month(e2.hire_date) in (1,2,3,4,5,6) and 
 e1.job_id=e2.job_id and 
 year(e1.hire_date)=year(e2.hire_date);
 
 -- Natural Join
 -- Tables are joined on common columns naturally
 -- join condition need not be specified explicitely
 -- if only one common column is present then syntax is very simple
 select ename,dname from emp natural join dept;
 -- find employees working in research as clerk
 select ename,dname,job from emp natural join dept where job='clerk' and dname='research';
 -- find employees working in chicago as clerk
 -- using natural
 select ename from emp natural join dept where job='clerk' and loc='chicago';
 -- using inner
 select ename from emp inner join dept on emp.deptno=dept.deptno where job='clerk' and loc='chicago';
 -- same query in hr table
 use hr;
 select * from employees;
 select * from departments;
 select first_name,department_name from employees natural join departments;
 -- only 32 columns are obtained as the two tables are having more than one same columns
 -- this is the reason why inner is mostly used
 
 use demo;
 
 -- Using Clause
 -- when more than 1 common column is present we can use using clause to specify the joining condition on specific column
  select first_name,department_name from employees join departments using(department_id);
  
  use hr;
  select count(distinct(department_id)),department_id from employees where last_name='smith' group by department_id;
  select distinct(count(department_id)),department_id from employees where last_name='smith' group by department_id;
  